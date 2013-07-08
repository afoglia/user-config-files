if [[ $(uname -s) == "Darwin" ]] ; then
  # Use CLICOLOR to set color
  alias ls="ls -F"
  if ! hash md5sum 2> /dev/null && hash openssl 2> /dev/null ; then
    alias md5sum="openssl md5"
  fi
else
  alias ls="ls -F --color=auto"
fi

alias bc="bc -l ~/.bc/extensions.bc"

if command -v ack-grep > /dev/null 2>&1 ; then
  alias ack="ack-grep"
fi

alias ack-py="ack --type=python"

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

# Emacs
# Use server/client mode
# Clients don't need to wait for server to finish.  (I leave my EDITOR set to
# vi for those simple, quick edits.
# Modified from /usr/share/emacs/22.1/etc/emacs.bash
function emacsc () {
  local windowsys="${WINDOW_PARENT+sun}"
  windowsys="${windowsys:-${DISPLAY+x}}"
  if [ -n "${windowsys:+set}" ]; then
    # Do not just test if these files are sockets.  On some systems
    # ordinary files or fifos are used instead.  Just see if they exist.
    if [ -e "${HOME}/.emacs_server" -o -e "/tmp/emacs${UID}/server" ]; then
       emacsclient -n "$@"
       return $?
    else
       echo "edit: starting emacs in background..." 1>&2
    fi

    case "${windowsys}" in
      x ) (emacs "$@" &) ;;
      sun ) (emacstool "$@" &) ;;
    esac
  else
    if jobs %emacs 2> /dev/null ; then
       echo "$(pwd)" "$@" >| ${HOME}/.emacs_args && fg %emacs
    else
       emacs "$@"
    fi
  fi
}

# Aliases for using git to manage configuration files
# 
# See <http://robescriva.com/2009/01/manage-your-home-with-git/> and
# <http://www.silassewell.com/blog/2009/03/08/profile-management-with-git-and-github/>
# To pull updates from other computers run
# $ config-vc pull origin master
alias config-vc='git --git-dir=$HOME/.config.git/ --work-tree=$HOME'
if [ -f /etc/bash_completion ] ; then
  complete -o default -o nospace -F _git config-vc
fi


# helpful Python aliases
#
# from justinlilly
pypath () {
  # Pass in arguments (e.g. "-S" for disabling site module, or "-E" to
  # ignore environmental variables)
  python $* -c "import sys; print sys.path" | tr "," "\n" | grep -v "egg"
}

# (from Ubuntu)
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# From <https://coderwall.com/p/psa3ng>
function vimconflicts() {
  vim +/"<<<<<<<" $( git diff --name-only --diff-filter=U | xargs )
}

# Site-specific stuff not to be shared cross-system
if [[ -f ${HOME}/.bash_aliases.local ]] ; then
  . ${HOME}/.bash_aliases.local
fi
