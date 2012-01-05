# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/x/.zshrc'

autoload -Uz compinit promptinit colors
compinit
promptinit
colors
prompt gentoo
# End of lines added by compinstall
#PROMPT='%d%>:%{\e[0m%} ' # default prompt
#PROMPT='[%n@%m:%c]%#' # default prompt
#RPROMPT='[%* on %D]' # prompt for right side of screen
#PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
exec 2>>(while read line; do
print '\e[91m'${(q)line}'\e[0m' > /dev/tty; print -n $'\0'; done &)

#chpwd() {
  #[[ -o interactive ]] || return
  #case $TERM in
    #sun-cmd) print -Pn "\e]l%~\e\\"
     # ;;
    #*xterm*|*rxvt|(dt|k|E)term) print -Pn "\e]2;%~\a"
     # ;;
  #esac
#}
unsetopt equals
export EDITOR="vim"
bindkey -v
bindkey "^P" vi-up-line-or-history
bindkey "^N" vi-down-line-or-history

bindkey "^[[1~" vi-beginning-of-line   # Home
bindkey "^[[4~" vi-end-of-line         # End
bindkey '^[[2~' beep                   # Insert
bindkey '^[[3~' delete-char            # Del
bindkey '^[[5~' vi-backward-blank-word # Page Up
bindkey '^[[6~' vi-forward-blank-word  # Page Down
#function zle-line-init zle-keymap-select {
#    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
#    RPS2=$RPS1
#    zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select
