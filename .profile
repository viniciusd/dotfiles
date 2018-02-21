# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

if [ $TERMINIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

# if [ ! -f /tmp/swapescape ]; then
#     /usr/bin/setxkbmap -option "caps:swapescape" 2>/dev/null
#     touch /tmp/swapescape
# fi

function firefox_kill {
    for i in $(ps aux | grep firefox | awk '{print $2}'); do kill -9 $i; done 2> /dev/null
}

function headless_screen {
    Xvfb :$1 >& /dev/null &
}

alias unittest='python -m unittest -v'
alias p='python3.5'
alias free='free -hl'
alias vim='vim -p'
hash vtop 2>/dev/null && alias top='vtop'

