" Status bar
set laststatus=2
set ruler

" Tab completion
set wildmenu

" Use spaces instead of tabs
set expandtab

set shiftwidth=2
set softtabstop=-2

set smarttab

set autoindent

""
"" Load indent and plugin files for specific filetypes
""
" plugin customizations are in .vim/ftplugin and .vim/after/ftplugin
"
" Use ":set filetype?" to get current filetype
"
filetype plugin indent on

" Turn on color highlighting
syntax on

"" Allow mouse use in normal and visual mode
set mouse=nv

" Incremental search
set incsearch

" Use dark background
set background=dark

"" Determine colorscheme
""
"" Logic taken from:
"" https://vi.stackexchange.com/questions/3397/how-do-i-conditionally-set-colorscheme
"" Scoping taken from:
"" http://learnvimscriptthehardway.stevelosh.com/chapters/20.html

"" Customization for ps_color. (No harm setting it here.)
let psc_cterm_transparent=1

for s:colorscheme in [  "peaksea",
                      \ "desert",
                      \ "ps_color",
                      \ "darkerdesert",
                      \ "moria",
                      \ "oceanblack"]
  "" TODO: Figure out how to set this to only print in a "debug" mode
  ":echom "Looking for colorscheme ".s:colorscheme
  if globpath(&runtimepath, "colors/".s:colorscheme.".vim", 1) !=# ""
    "" TODO: Put this in a try-catch
    "" https://stackoverflow.com/questions/5698284/in-my-vimrc-how-can-i-check-for-the-existence-of-a-color-scheme
    execute "colorscheme" s:colorscheme
    break
  endif
endfor


" Doesn't seem to work
" " Force background to be black (already grey from the terminal settings)
" "highlight Normal guibg=#000000
" "highlight Normal ctermbg=NONE

" Shortcut to write files with sudo-permissions
cmap w!! %!sudo tee > /dev/null %
