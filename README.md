# NAME

git-bunch - manage bunch directories which contain git repositories

# SYNOPSIS

``` 
  git-bunch -h | --help
  git-bunch -l | --list
  git-bunch NAME
  git-bunch NAME ls
  git-bunch NAME config -l | --list
  git-bunch NAME config config-name [config-value]
  git-bunch NAME [--] COMMAND [OPTIONS]
```

# DESCRIPTION

git-bunch or bunch is a term to refer to a directory which is supposed
to be a container for other directories being containers of git
repositories.

If you keep your repos under some directory...

If you need to execute (sometimes, not so often) some particular git
commands over these repos...

... this script for you\!

# CONFIGURE BUNCHES

The script assumes that all bunches and their settings are stored
globally in the `~/.gitconfig` file.

You can declare more than one bunch. Each directory containing git
repositories can be called a bunch. Each bunch has a name, path and
options. The name is used to refer the bunch. The path is used to locate
the bunch. Options are used to tune the bunch. There is no restriction
to declare more than one name per a bunch. In this case both names are
synonyms, but they could have different options.

# CONFIGURATIN FILE

Git bunch is per-user configuration only. That means that all bunches
are configured via user's `~/.gitconfig`. The syntax is **almost** the
same as for `gitconfig`.

## Syntax

In this example two bunches called "one" and "two" are created and setup
to particular directories:

``` 
  [bunch "one"]
    path = /var/git/bunch-1
    errexit = no
  [bunch "two"]
    path = /var/git/bunch-2
    errexit = no
```

## Values

  - pathname  
    A pathname follows Bash syntax.

  - boolean  
    The following words stand for **true** and **false**:
    
      - true  
        Boolean true literals are `yes`, `on`, `true`, `1`.
        
        **In contrast to git itself**, the single name (without `=
        value`) is treated as false.
    
      - false  
        Boolean false literals are `no`, `off`, `false`, `0` and the
        emtpy string.

## Variables

The following variables are supported for bunches:

  - `path` (string)  
    The only mandatory variable defining the bunch location.

  - `errexit` (boolean)  
    True means stop immediately if a command exits with a non-zero
    status. Defaults to false (i.e., `set +o errexit`).

# SEE ALSO

Something similar...

  - https://metacpan.org/pod/Git::Bunch  
    Something very similar, implemented in pure Perl

# COPYRIGHT

Copyright (c) 2020 Ildar Shaimordanov. MIT License.
