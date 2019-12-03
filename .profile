# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export EDITOR=vi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi


# Computer-specific, unshareable stuff goes here...
if [ -f "${HOME}/.profile.local" ]; then
  . "${HOME}/.profile.local"
fi

# Location of user-installed python scripts on Mac
if [ -d "${HOME}/Library/Python/2.7/bin" ]; then
  PATH="${HOME}/Library/Python/2.7/bin:${PATH}"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

add_to_path () {
    echo "Adding to path ${1} ${2}"
    if [ -d $2 ] ; then
        #eval OLDPATH=\$$1
        eval export $1=$2:\$${1}
    fi
}

# My personal paths
for local_root in "${HOME}/myroot" "${HOME}/.local" ; do
    # echo "Checking local_root ${local_root}"
    if [ -d ${local_root} ] ; then
        # Should I be adding these even if the directories don't
        # exist?  If I do, if installing something creates them, it's
        # already in the PATH...
        add_to_path "PATH" "${local_root}/bin"
        # echo "Adding usr/bin to PATH"
        add_to_path "PATH" "${local_root}/usr/bin"
        add_to_path "PATH" "${local_root}/usr/local/bin"
        add_to_path "MANPATH" "${local_root}/man"
        add_to_path "MANPATH" "${local_root}/share/man"
        add_to_path "INFOPATH" "${local_root}/info"
        add_to_path "LD_LIBRARY_PATH" "${local_root}/lib"
        # echo "Setting PKG_CONFIG_PATH"
        export PKG_CONFIG_PATH=${local_root}/usr/lib/pkgconfig:${local_root}/lib/pkgconfig:${PKG_CONFIG_PATH}

        # For versions of Python before 2.6, manually set the
        # PYTHONPATH.  For other versions, PEP-370's method
        # ~/.local/lib/pythonX.Y should be used instead.
#        local PYTHONVERSION=`python --version 2>&1 | sed 's/^Python \([0-9]\.[0-9]\)\..*$/\1/g'`
#        echo PYTHONVERSION=${PYTHONVERSION}
#        if (([ "${PYTHONVERSION}" < "2.6" ] && [ "${local_root}" != "${HOME}/.local" ])) ; then
#            export PYTHONPATH=${local_root}/lib/python${PYTHONVERSION}/site-packages:${PYTHONPATH#:}
#            if [ -d "${local_root}/local" ] ; then
#                export PYTHONPATH=${local_root}/local/lib/python${PYTHONVERSION}/site-packages:$PYTHONPATH
#            fi
#        fi

    fi
done

unset -f add_to_path

