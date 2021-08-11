# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# shellcheck shell=bash

#echo "$(date): In .bashrc"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth
export HISTIGNORE="[bf]g:exit"

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# Add timestamp to history
HISTTIMEFORMAT='%F %T  '

# Keep carriage returns in history
shopt -s lithist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
if [[ ${BASH_VERSINFO[0]} -ge 4 ]] ; then
  shopt -s globstar
fi

# Extended globbing
shopt -s extglob

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-*color|screen-*color|*-256color)
        color_prompt=yes
        export CLICOLOR=1 ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ] ; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
        export CLICOLOR=1
    else
        color_prompt=
    fi
fi

if [[ $(uname -s) == "Darwin" ]] ; then
  _sed_extended_regexp_flag="-E"
else
  _sed_extended_regexp_flag="-r"
fi


# Simple function to truncate the path to three containing directories
trunc_path ()
{
  # DIR=$(pwd | sed ${_sed_extended_regexp_flag} "s,^${HOME%${USER}}($USER)?,~," );
  # Requires extglob shell options
  DIR=${PWD/#${HOME%${USER}}?(${USER})/\~}
  DIR=$(echo "${DIR}" | awk -F / '{ if (NF>4) { print $1"/.../"$(NF-2)"/"$(NF-1)"/"$NF } else { print $0 } }' ) ;
  echo "${DIR}";
  return 0
}

# Need special version to pass through the exit status so we can get
# the path for the xterm title without ruining the exit status for the
# prompt coloring
ps_trunc_path ()
{
    EXITSTATUS=$?
    trunc_path
    return "${EXITSTATUS}"
}

if [ ${CLICOLOR} ] || [ -n "${COLORTERM}" ] ; then
    color_prompt=yes
fi

if [ "$color_prompt" = yes ] ; then
    # Define color codes
    COLOR_BOLD="$(tput bold)"
    COLOR_RED="$(tput setaf 1)"
    COLOR_GREEN="$(tput setaf 2)"
    COLOR_YELLOW="$(tput setaf 3)"
    COLOR_BLUE="$(tput bold)$(tput setaf 4)"
    COLOR_CYAN="$(tput setaf 6)"
    COLOR_OFF="$(tput sgr0)"

    # Define prompts
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1="${debian_chroot:+($debian_chroot)}\[${COLOR_RED}\]\$(echo \$? | sed -e 's/^0$//' -e 's/^\(.\)$/*\1*/' )\[${COLOR_GREEN}\]\u@\h\[${COLOR_OFF}\]:\[${COLOR_BLUE}\]\$(ps_trunc_path)\[${COLOR_OFF}\]:\[${COLOR_CYAN}\]\!\[${COLOR_OFF}\]\$ "

    # Termcap definitions used by less.
    # See https://unix.stackexchange.com/a/108840
    # and https://www.gnu.org/software/termutils/manual/termcap-1.3/html_chapter/termcap_4.html

    # begin blinking
    export LESS_TERMCAP_mb="${COLOR_BOLD}${COLOR_YELLOW}"
    # begin bold
    export LESS_TERMCAP_md="${COLOR_BOLD}${COLOR_YELLOW}"
    # end mode
    export LESS_TERMCAP_me="${COLOR_OFF}"
    # end standout-mode
    export LESS_TERMCAP_se="${COLOR_OFF}"
    # begin standout-mode - info box
    export LESS_TERMCAP_so="${COLOR_BOLD}$(tput setab 4)${COLOR_YELLOW}"
    # end underline
    export LESS_TERMCAP_ue="${COLOR_OFF}"
    # begin underline
    export LESS_TERMCAP_us="${COLOR_YELLOW}"

else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w:\!\$ '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|screen.xterm*|screen.rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

#
# Configure programs
#
export LESS=-eIMR

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Configure ls to not use quotes. I don't like the way they stagger the output.
# Try "escape" style, and see if it's better than the old default "literal"
# https://unix.stackexchange.com/questions/258679/why-is-ls-suddenly-wrapping-items-with-spaces-in-single-quotes
# https://www.gnu.org/software/coreutils/manual/html_node/Formatting-the-file-names.html
export QUOTING_STYLE=escape

# Configure PYTHONSTARTUP file
export PYTHONSTARTUP=~/.pythonrc

# Set python to use with virtualenvwrapper
#
# Even if we use a custom python, use the system's python and virtualenv
# command to build virtualenvs.
#
# This must come before /etc/bash_completion, because that's when
# virtualenvwrapper.sh gets sourced in Ubuntu's packaging.
export VIRTUALENVWRAPPER_PYTHON=$(which python)
export VIRTUALENVWRAPPER_VIRTUALENV=$(which virtualenv)

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#echo "$(date): Setting up completion"
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if ! shopt -oq posix ; then
    complete -e printenv
fi

# Virtualenvwrapper shell scripts
#echo "$(date): Setting up virtualenvs"
export WORKON_HOME="${HOME}/.virtualenvs"
if [[ -f /usr/local/bin/virtualenvwrapper_bashrc ]]; then
  . /usr/local/bin/virtualenvwrapper_bashrc
elif [[ -f "${HOME}/Library/Python/2.7/bin/virtualenvwrapper.sh" ]]; then
  # Location of virtualenvwrapper on osx.
  . "${HOME}/Library/Python/2.7/bin/virtualenvwrapper.sh"
fi


# Go PATH
export GOPATH="${HOME}/gocode"


# Ripgrep
export RIPGREP_CONFIG_PATH="${HOME}/.config/ripgrep/conf"


# fzf
#
# TODO: Set up colors <https://github.com/junegunn/fzf/wiki/Color-schemes>

if command -v fd > /dev/null 2>&1 ; then
  export FZF_DEFAULT_COMMAND="fd"
else
  if command -v fdfind > /dev/null 2>&1 ; then
    export FZF_DEFAULT_COMMAND="fdfind"
  fi
fi

if [[ -f /usr/share/doc/fzf/examples/completion.bash ]]; then
  . /usr/share/doc/fzf/examples/completion.bash
fi

if type -t _fzf_setup_completion > /dev/null; then
  _fzf_setup_completion path emacsc
fi

if [[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]]; then
  . /usr/share/doc/fzf/examples/key-bindings.bash
fi
# TODO: Combine with logic in .lessfilter.
export FZF_CTRL_T_OPTS="--select-1 --exit-0 --preview '(highlight -O ans --style clarityi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# Other bash utilities installed
#
# Current utilities usually installed:
#   bash-command-timer: https://github.com/jichu4n/bash-command-timer
if [[ -d "${HOME}/.local/etc/bash.bashrc.d" ]]; then
  for fyle in "${HOME}"/.local/etc/bash.bashrc.d/*.sh; do
    if [[ -r "$fyle" ]]; then
      . "${fyle}"
    fi
  done
  unset fyle
fi


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#echo "$(date): Setting up aliases"
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Other local stuff that doesn't make sense to share across machines

if [ -f ~/.bashrc.local ]; then
  . ~/.bashrc.local
fi

# TODO: Refactor into a bashrc.d/ directory layout, and put all the
# color prompt stuff together.
unset color_prompt force_color_prompt

#echo "$(date): Exitting .bashrc"
