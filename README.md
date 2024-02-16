toolbox
=======

My dotfiles and utility scripts of varying quality. They’re reasonably
well documented and organised, so spelunking is encouraged. Feel free to
use whatever you find useful here for your own use.

To get set up:

1.  Use Git to download a copy of the *toolbox* repository, ensuring
    that any [Git submodules][] (currently used to manage third-party
    Vim plugins) are also initialised and updated.
2.  Run the `install` script located in the repository root to create
    the relevant symlinks in your home directory.
3.  In Vim, run `:helptags ~/.vim/doc` to generate the help tags file
    for the *toolbox* Vim cheat sheet.

The `install` script doesn’t install third-party dependencies, as I have
[Ansible playbooks and stuff][] for that.

  [Git submodules]: <https://git-scm.com/book/en/v2/Git-Tools-Submodules>
  [Ansible playbooks and stuff]: <https://www.robotinaponcho.net/git/#setup>


## Related projects

-   [nt][]: a note-taking helper application for the command line.
-   [snippets][]: a bunch of reusable snippets and a little doohickey to
    replace placeholder content.

  [nt]: <https://www.robotinaponcho.net/git/#nt>
  [snippets]: <https://www.robotinaponcho.net/git/#snippets>
