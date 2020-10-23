#!/usr/bin/env bash

# =========================================================================

ME="$( basename "$0" )"

GITCONFIG=~/.gitconfig

# =========================================================================

print_usage() {
	cat - <<USAGE
<usage>
USAGE
	exit
}

print_help() {
	cat - <<HELP
<help>
HELP
	exit
}

# =========================================================================

main() {
	case "$1" in
	''		) print_usage ;;
	-h | --help	) print_help ;;

	-l | --list	) bunch_list ;;

	* 		) bunch_exec "$@" ;;
	esac
}

# =========================================================================

bunch_list() {
	sed -n 's/^\[bunch "\([^"]*\)"\].*/\1/p' "$GITCONFIG"
}

bunch_configure() {
	case "$1" in
	-l | --list )
		sed -n "/./ s/^/bunch.$BUNCH_NAME./p" <<<"$BUNCH_RAW"
		;;
	--unset )
		git config --global --unset "bunch.$BUNCH_NAME.$2"
		;;
	path | stoponerror )
		git config --global "bunch.$BUNCH_NAME.$1" "$2"
		;;
	* )
		print_usage
		;;
	esac
}

bunch_raw_config() {
	sed -n '
	/^\[bunch "'"$1"'"\]/,/^\[/ {
		/^\[/d;
		s/^\s*//;
		s/\s*=\s*/=/;
		s/\s*$//;
		p;
	}
	' "$GITCONFIG"
}

bunch_exec() {
	BUNCH_NAME="$1"
	BUNCH_ERREXIT="+o"

	unset BUNCH_PATH BUNCH_STOP

	# Read raw bunch config

	BUNCH_RAW="$( bunch_raw_config "$BUNCH_NAME" )"

	# Parse the bunch

	while IFS="=" read -r k v
	do
		case "$k" in
		path )
			BUNCH_PATH="$v"
			;;
		stoponerror )
			BUNCH_STOP="$v"
			case "$v" in
			0 | no  | off | false | ''	) BUNCH_ERREXIT="+o" ;;
			1 | yes | on  | true		) BUNCH_ERREXIT="-o" ;;
#			*	) die "Illegal value for boolean errexit: $v" ;;
			esac
			;;
		esac
	done <<<"$BUNCH_RAW"

	# Print the bunch path
	# git-bunch NAME

	shift

	[ $# -gt 0 ] || {
		echo "$BUNCH_PATH"
		return
	}

	# Configure the bunch
	# git-bunch NAME config ...

	if [ "$1" = "config" ]
	then
		shift
		bunch_configure "$@"
		return
	fi

	[ -d "$BUNCH_PATH" ] || die "Not bunch directory: $BUNCH_PATH"

	# List the bunch
	# git-bunch NAME ls

	if [ "$1" = "ls" ]
	then
		ls "$BUNCH_PATH" --color=tty
		return
	fi

	# Work through the bunch and execute the git command
	# git-bunch NAME ...

	[ "$1" = "--" ] && shift

	set "$BUNCH_ERREXIT" errexit

	for f in "$BUNCH_PATH"/*
	do
		[ -d "$f" ] || continue

		(
			set "$BUNCH_ERREXIT" errexit
			builtin cd "$f"
			git "$@"
		)
	done
}

# =========================================================================

catecho() {
	[ $# -eq 0 ] && cat - || echo "$@"
}

warn() {
	catecho "$@" >&2
}

die() {
	warn "$@"
	exit 1
}

# =========================================================================

main "$@"

# =========================================================================

# EOF
