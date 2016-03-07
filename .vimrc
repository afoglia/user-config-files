" Use spaces instead of tabs
set expandtab

set tabstop=2

" Load indent files for specific filetypes
filetype indent on
"" Load indent and plugin files for specific filetypes
"filetype plugin indent on

" Turn on color highlighting
syntax on

" Use dark background
set background=dark

"" Use desert colorscheme
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
