gwmsh
=====

Ultra-simple gem environment builder.

Usage
-----

    $ gemsh env

This builds a gem environment in `env/`.  To use this environment, run:

    $ env/bin/exec /bin/bash

This launches a bash shell with GEM\_HOME and GEM\_PATH set so that when
you run `gem install foo`, the `foo` gem is installed to
`env/gem_home/gems`.  This arrangement also works with bundler,

Because `gem install` caches the .gem file, you'll find a cache of the
installation packages at `env/gem_home/cache`.

Binaries installed by `gem install` will be in `env/gem_home/bin`.  This
directory is prepended to $PATH by `env/bin/exec`.

For the few more details of what `env/bin/exec` actually does, see
`env/bin/activate`, which is where the relevant environment variables
are set.

Note: because the absolute path to `env` is baked into the environment,
you cannot move the environment around the filesystem.  It won't work
when it's at its new location.  However, if you re-run `gemsh` at the
new location, it'll simply overwrite the paths with the new location so
you won't have to reinstall all the gems.

Author
------

Alex Young <alex@blackkettle.org>
