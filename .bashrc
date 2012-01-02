# /etc/skel/.bashrc:
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
if [[ -f ~/.dir_colors ]]; then
	eval `dircolors -b ~/.dir_colors`
else
	eval `dircolors -b /etc/DIR_COLORS`
fi

# Change the window title of X terminals 
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
esac

source /etc/profile.d/bash-completion.sh
[[ -f /etc/profile.d/bash-completion ]] && source /etc/profile.d/bash-completion

if [ -f /usr/share/mc/mc.gentoo ]; then
  	. /usr/share/mc/mc.gentoo
fi

source ~/.bash_aliases

source ~/.bash_local
# Sets the Mail Environment Variable
export MAIL=~/Mail/inbox
export EMAIL=antonl1911@gmail.com
export EDITOR=/usr/bin/vim
export PROMPT_COMMAND="echo -ne '\a'"
set -o vi
export PAGER=~/bin/vimpager 
export MANPAGER=/usr/bin/vimmanpager
export MPD_HOST="192.168.1.3"
alias less=$PAGER
irexec &
