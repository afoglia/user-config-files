# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

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
export HISTTIMEFORMAT='%F %T >> '

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the patter "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color)
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


# Simple function to truncate the path to three containing directories
trunc_path ()
{
    DIR=`pwd | sed -r "s,^${HOME%${USER}}($USER)?,~," `;
    DIR=`echo $DIR | awk -F / '{ if (NF>4) { print $1"/.../"$(NF-2)"/"$(NF-1)"/"$NF } else { print $0 } }' ` ;
    echo $DIR;
    return 0
}

# Need special version to pass through the exit status so we can get
# the path for the xterm title without ruining the exit status for the
# prompt coloring
ps_trunc_path ()
{
    EXITSTATUS="$?"
    trunc_path
    return $(echo ${EXITSTATUS})
}

if [ ${CLICOLOR} ] ; then
    color_prompt=yes
fi

if [ ${CLICOLOR} ] || [ "$color_prompt" = yes ] ; then
    COLOR_BOLD="\033[1m"
    COLOR_RED="\033[01;31m"
    COLOR_GREEN="\e[00;32m"
    COLOR_BLUE="\033[01;34m"
    COLOR_CYAN="\033[00;36m"
    COLOR_OFF="\033[00m"
fi

if [ "$color_prompt" = yes ] ; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1="${debian_chroot:+($debian_chroot)}\[${COLOR_RED}\]\$(echo \$? | sed 's/^0$//' | sed 's/^\(.\)$/*\1*/' )\[${COLOR_GREEN}\]\u@\h\[${COLOR_OFF}\]:\[${COLOR_BLUE}\]\$(ps_trunc_path)\[${COLOR_OFF}\]:\[${COLOR_CYAN}\]\!\[${COLOR_OFF}\]\$ "

    export LESS_TERMCAP_mb=$'\E[01;33m'      # begin blinking
    export LESS_TERMCAP_md=$'\E[01;33m'      # begin bold
    export LESS_TERMCAP_me=$'\E[0m'          # end mode
    export LESS_TERMCAP_se=$'\E[0m'          # end standout-mode
    export LESS_TERMCAP_so=$'\E[01;44;33m'   # begin standout-mode - info box
    export LESS_TERMCAP_ue=$'\E[0m'          # end underline
    export LESS_TERMCAP_us=$'\E[033m'        # begin underline

else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w:\!\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
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

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if ! shopt -oq posix ; then
    complete -e printenv
fi

# Virtualenvwrapper shell scripts
export WORKON_HOME=${HOME}/.virtualenvs
if [ -f /usr/local/bin/virtualenvwrapper_bashrc ] ; then
    . /usr/local/bin/virtualenvwrapper_bashrc
fi
