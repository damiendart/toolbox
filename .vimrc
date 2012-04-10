set noerrorbells 
set t_vb=
set visualbell
if has("gui_running")
    colorscheme solarized
    let g:solarized_menu=0
    set background=dark
    set cursorline
    set guifont=Inconsolata:h14
    set guioptions=cg
    set laststatus=2
    set number
    set title
    syntax enable
    if has("gui_macvim")
        " I'm particular like that.
        set titlestring=%t
    endif
endif
