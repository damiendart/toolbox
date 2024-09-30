toolbox
=======

My dotfiles and utility scripts of varying quality. They’re reasonably
well documented and organised, so spelunking is encouraged. Feel free to
use whatever you find useful here for your own use.

To get set up:

1.  Use Git to download a copy of the *toolbox* repository, ensuring
    that any [Git submodules][] (currently used to manage third-party
    Vim plugins) are also initialised and updated.
2.  Run the `install` script in the repository root to create the
    relevant symlinks in your home directory, and to generate Vim help
    tags files for the *toolbox* cheat sheet and third-party plugin
    documentation.

The `install` script doesn’t install third-party dependencies as I have
[Ansible playbooks][] for that. The Python dependencies listed in
*requirements-dev.txt* are not required to run any of the included
Python scripts.

  [Git submodules]: <https://git-scm.com/book/en/v2/Git-Tools-Submodules>
  [Ansible playbooks]: <https://www.robotinaponcho.net/git/#setup>


## Related projects

-   [nt][]: a note-taking helper application for the command line.

  [nt]: <https://www.robotinaponcho.net/git/#nt>
