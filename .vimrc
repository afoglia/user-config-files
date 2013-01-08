" use spaces instead of tabs
set expandtab

set tabstop=3

" load indent files for specific filetypes
filetype indent on
"" load indent and plugin files for specific filetypes
"filetype plugin indent on

" turn on color highlighting
syntax on

" use dark background
set background=dark

"" use desert colorscheme
"colorscheme desert
"colorscheme darkerdesert

"colorscheme moria
"colorscheme oceanblack

let psc_cterm_transparent=1
colorscheme ps_color
"colorscheme peaksea

" Doesn't seem to work
" " Force background to be black (already grey from the terminal settings)
" "highlight Normal guibg=#000000
" "highlight Normal ctermbg=NONE

" Shortcut to write files with sudo-permissions
cmap w!! %!sudo tee > /dev/null %
