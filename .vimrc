set ruler
if has("gui_running")
    colorscheme solarized
    let g:solarized_menu=0
    set background=dark
    set cursorline
    set guifont=Inconsolata:h14
    set guioptions=cg
    set laststatus=2
    set noerrorbells
    set number
    set title
    set t_vb=
    set visualbell
    syntax enable
    if has("gui_macvim")
        " I'm particular like that.
        set titlestring=%t
    endif
endif
