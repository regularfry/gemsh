# rv 1 "June 2013" rv "User Manuals"

## SYNOPSIS

`gemsh` [DIRNAME]

## DESCRIPTION

Generates a totally self-contained environment for ruby gems.

https://github.com/regularfry/gemsh#readme

## USAGE

    $ gemenv <dirname>

This creates the following files:

    <dirname>/
      bin/
        exec
        activate
      gem\_home/

The `activate` file contains shell script to set the `gem_home/`
directory as the ONLY place the `require` method will attempt to load
gems from, and the location where the `gem` and `bundle` commands will
install gems to.

The `exec` script is a loader which sources the `activate` script, and
runs whatever commands are passed on the command line.  When working
on a project, use it like this:

    $ env/bin/exec /bin/bash

Running exec with a shell like this provides a subshell within which
the `gem` command Does The Right Thing, and where all binaries provided
by `gem install` are loaded from within the gem environment.  To switch
environments, a Ctrl-D quits the subshell.  This makes binstubs
unnecessary, other than those that the `gem` command itself generates.

Naturally, you can replace `/bin/bash` with any executable you want to
run in the environment's context.

This combination allows you to remove runtime dependencies on bundler
from your projects, avoid the `bundle exec...` dance, and keep your
gem environment in the same place as your project.  Regenerating a gem
environment is simple: an `rm -rf <dirname>` removes the environment
completely, and `gem install bundler; bundle install` will reinstall the
gems you need from your `Gemfile.lock`, if you have one.

There are no limitations on the directory name for the environment
other than that it must be a valid path component.  Meaningful gem
environment names replace named gemsets; the activated gem environment
name is available as the $VIRTUAL\_ENV environment variable.  This can
be added to your prompt like so:

    $ export PS1="(gems: \$VIRTUAL\_ENV)\n$PS1"

It is recommended to put your gem environments in the root of your
projects.  If you use git, you can have it ignore the generated
environment by adding the gemenv name to `.git/info/exclude`.  This file
is intentionally *not* tampered with by this script.

If you use mercurial, you can have it ignore the generated environment
by adding the gemenv name to `.hg/hgignore`, and adding the following
to `.hg/hgrc`:

    [ui] 
    ignore=.hg/hgignore

Different gem environments are required for different ruby versions:
binary gems built for MRI 1.9, for instance, will segfault MRI 2.0, and
vice versa.

gemsh(1) is particularly useful when combined with a ruby environment
switcher such as chruby(1).  rv(1) combines these tools.


## ARGUMENTS

*DIRNAME*
	Root directory name for the generated gem environment.


## EXAMPLES

Generate a gem environment at `.env`:

    $ gemenv .env

Generate an environment for a rails app, load it and create an app with
the installed rails gem:

    $ gemenv rails-env
    $ rails-env/bin/exec rails myfunkyapp

or...

    $ gemenv rails-env
    $ rails-env/bin/exec /bin/bash
    $ rails myfunkyapp

The latter leaves the bash subshell running, from which you can quit
with a Ctrl-D.


## FILES

*$dirname*
	Gem environment location.  Can exist before running `gemsh`.

*$dirname/exec*
  Command runner.  A command passed on the command-line will be executed
  with the gem environment activated.

*$dirname/activate*
  A bash script which sets the appropriate shell variables to activate
  the gem environment for the shell in which it is sourced.

*$dirname/gem_home*
  The $GEM\_HOME which is activated by `bin/exec` and `bin/activate`.


## AUTHOR

Alex Young <alex@blackkettle.org>

## SEE ALSO

rv(1), rv-init(1), ruby(1), gem(1), bundle(1), chruby(1),
chruby-exec(1), git(1), hg(1)

