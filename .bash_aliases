if [[ $(uname -s) == "Darwin" ]] ; then
  # Use CLICOLOR to set color
  alias ls="ls -F"
  if ! hash md5sum 2> /dev/null && hash openssl 2> /dev/null ; then
    alias md5sum="openssl md5"
  fi
else
  alias ls="ls -F --color=auto"
fi

# Use bc extensions from
# http://www.terminally-incoherent.com/blog/reference/bc-extensions/
# if downloaded
bc () {
  if [[ -f "${HOME}/.bc/extensions.bc" ]]; then
    command bc -l ~/.bc/extensions.bc "$@"
  else
    echo "Note: Extensions not installed" >&2
    command bc -l "$@"
  fi
}

if command -v annotate-output > /dev/null 2>&1 ; then
  alias annotate="annotate-output"
fi

# TODO: Replace with function that can re-nice processes, or create rerealnice
alias realnice="nice -n 19 ionice -c2 -n7"
if [ -n "${BASH_VERSION}" ]; then
  complete -F _command realnice
fi

# TODO: Expand this for other common environment variables (GTK_RC_FILES?
# GTK2_RC_FILES? PYTHONPATH? And combine into a pprintenv function?
pprintpath () {
  (IFS=: arr=($PATH); printf "%s\n" "${arr[@]}")
}


#
# Search tools
#

# Undo debian/ubuntu's renaming of these utilities
if command -v ack-grep > /dev/null 2>&1 ; then
  alias ack="ack-grep"
fi

# Type-specific alias for ack and python
alias ack-py="ack --type=python"

# Type-specific aliases for ag
alias ag-go="ag --go"
alias ag-gyp="ag --file-search-regex \.gypi\?\$"
alias ag-ninja="ag --file-search-regex \.ninja\$"
alias ag-py="ag --python"
alias ag-proto="ag --proto"


# Keep Nautilus from taking over the desktop
#
if command -v nautilus > /dev/null 2>&1 ; then
  alias nautilus="nautilus --no-desktop"
fi

# Subversion aliases
#
alias svndiff="svn diff --diff-cmd colordiff --extensions=-up"
alias svndiff-gui="svn diff --diff-cmd meld"
svn-filtered-status () {
  svn status $* | egrep -v "^((\?|X|Performing ).*|)$"
}

# h5diff alias
#
# h5diff reports two cells with nans as different.  This will filter them out.
# The differences will still be counted, but the lines will not be outputted.
h5diff-no-nan () {
  h5diff $* | egrep -v "( +nan){3} *$"
}

# VNC settings
# preferred geometry: 1820x1125
# set dpi to 75 to match NX
alias vncserver-ajf="vncserver -geometry 1880x1130" # -dpi 75"

#
# Emacs
#
# On OSX, use Emacs.app
if [ -x /Applications/Emacs.app/Contents/MacOS/bin/emacsclient ] ; then
  alias emacsclient=/Applications/Emacs.app/Contents/MacOS/bin/emacsclient
  alias emacs_app=/Applications/Emacs.app/Contents/MacOS/Emacs
fi

# Use server/client mode
# Clients don't need to wait for server to finish.  (I leave my EDITOR set to
# vi for those simple, quick edits.
# Modified from /usr/share/emacs/22.1/etc/emacs.bash
function emacsc () {
  local windowsys
  if [[ "$(uname)" == "Darwin" ]]; then
    windowsys="osx"
  fi
  windowsys="${windowsys:-${WINDOW_PARENT+sun}}"
  windowsys="${windowsys:-${DISPLAY+x}}"
  if [ -n "${windowsys:+set}" ]; then
    # Do not just test if these files are sockets.  On some systems
    # ordinary files or fifos are used instead.  Just see if they exist.
    if [ -e "${HOME}/.emacs_server" -o -e "${TMPDIR:-/tmp}/emacs${UID}/server" ]
    then
       emacsclient -n "$@"
       return $?
    else
       echo "edit: starting emacs in background..." 1>&2
    fi

    case "${windowsys}" in
      x ) (emacs "$@" &) ;;
      sun ) (emacstool "$@" &) ;;
      osx ) (emacs_app "$@" &) ;;
    esac
  else
    if jobs %emacs 2> /dev/null ; then
       echo "$(pwd)" "$@" >| ${HOME}/.emacs_args && fg %emacs
    else
       emacs "$@"
    fi
  fi
}


# From <https://coderwall.com/p/psa3ng>
function vimconflicts() {
  vim +/"<<<<<<<" $( git diff --name-only --diff-filter=U | xargs )
}


# Aliases for using git to manage configuration files
# 
# See <http://robescriva.com/2009/01/manage-your-home-with-git/> and
# <http://www.silassewell.com/blog/2009/03/08/profile-management-with-git-and-github/>
# To pull updates from other computers run
# $ config-vc pull origin master
alias config-vc='git --git-dir=$HOME/.config.git/ --work-tree=$HOME'
if [ -n "${BASH_VERSION}" ]; then
  if [ -f /etc/bash_completion ] ; then
    if $(type -t _git > /dev/null) ; then
      complete -o default -o nospace -F _git config-vc
    elif $(type -t _xfunc > /dev/null) ; then
      # Bash kindly created a dynamic loading framework for completions,
      # but with no documentation or hooks on how to enable it for yourself.
      # https://github.com/scop/bash-completion/issues/49
      _xfunc git __git_complete config-vc __git_main
    fi
  fi
fi

# helpful Python aliases
#
# from justinlilly
pypath () {
  # Pass in arguments (e.g. "-S" for disabling site module, or "-E" to
  # ignore environmental variables)
  python $* -c "import sys; print sys.path" | tr "," "\n" | grep -v "egg"
}

alias lsvirtualenv="lsvirtualenv -b"

# (from Ubuntu)
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Kill all Chrome tab rendering processes
kill-chrome-renderers () {
  for PID in $(ps uxww | egrep "((/(\w+))+/chrome/chrome|Chrome Helper( \(Renderer\))?) --type=renderer" | grep -v " --extension-process" | awk '{ print $2 }' ) ; do
    echo ${PID}
    kill ${PID}
  done
}

# Kill Chrome GPU cpu hogger
kill-chrome-gpu () {
  for PID in $(ps uxww | egrep "((/(\w+))+/chrome/chrome|Chrome Helper( \(GPU\))?) --type=gpu-process" | grep -v " --extension-process" | awk '{ print $2 }' ) ; do
    echo ${PID}
    kill ${PID}
  done
}

# Mac specific
if [[ $(uname -s) == "Darwin" ]] ; then
  # Add alias to set-up and tear down permissions required for brew
  brew () {
    echo "Setting /usr/local directories as world-writeable"
    sudo chmod o+w /usr/local/{bin,etc,sbin,share,share/doc,share/zsh,share/zsh/site-functions,lib/pkgconfig,share/man/man5}
    command brew $@
    EXITVALUE=$?
    echo "Resetting permissions of /usr/local directories"
    sudo chmod o-w /usr/local/{bin,etc,sbin,share,share/doc,share/zsh,share/zsh/site-functions,lib/pkgconfig,share/man/man5}
    return "${EXITVALUE}"
  }
fi

# cd command that stays within git repo
git-cd () {
  if [[ "$1" == "--help" ]]; then
    echo "cd within a git repo"
    return 0
  fi
  if [[ -z "$1" || "$1" == /* ]]; then
    local git_root
    git_root="$(git-root)" && cd "${git_root}$1"
  else
    cd $1
  fi
}

_git-cd () {
  local curr
  COMPREPLY=()
  curr="${COMP_WORDS[COMP_CWORD]}"
  if [[ -z "${curr}" || "${curr:0:1}" != "/" ]] ; then
    COMPREPLY=( $(compgen -d ${curr}) )
  else
    local git_root
    git_root="$(git root)"
    COMPREPLY=( $( for dyr in $(compgen -d ${git_root}${curr} ) ; do echo ${dyr:${#git_root}}/ ; done ) )
  fi
}

if [ -n "${BASH_VERSION}" ]; then
  complete -o nospace -F _git-cd git-cd
fi

#
# OSX-specific aliases to make applications act like commands
#
# We run the executable directly rather than calling `open -a`,
# because when using open, the working directory is / so relative
# paths as arguments are incorrectly interpreted.
if [[ $(uname -s) == "Darwin" ]] ; then

  # Meld
  if [[ -x /Applications/Meld.app/Contents/MacOS/Meld ]]; then
    alias meld=/Applications/Meld.app/Contents/MacOS/Meld
  fi
  # Glogg log viewer, OSX alias
  if [[ -x /Applications/glogg.app/Contents/MacOS/glogg ]]; then
    alias glogg=/Applications/glogg.app/Contents/MacOS/glogg
  fi
fi


# Site-specific stuff not to be shared cross-system
if [[ -f ${HOME}/.bash_aliases.local ]] ; then
  . ${HOME}/.bash_aliases.local
fi
