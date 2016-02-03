# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
set -o emacs
#bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/x/.zshrc'

autoload -Uz compinit promptinit colors
compinit
promptinit
colors
prompt redhat
# End of lines added by compinstall
#PROMPT='%d%>:%{\e[0m%} ' # default prompt
#PROMPT='[%n@%m:%c]%#' # default prompt
#RPROMPT='[%* on %D]' # prompt for right side of screen
#PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
#exec 2>>(while read line; do
#print '\e[91m'${(q)line}'\e[0m' > /dev/tty; print -n $'\0'; done &)

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

#function zle-line-init zle-keymap-select {
#    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
#    RPS2=$RPS1
#    zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select
source ~/.shell_aliases
source ~/.shell_exports

zstyle ':completion:*' menu select
setopt completealiases
setopt hist_ignore_all_dups
setopt autocd
setopt extendedglob
# bind special keys according to readline configuration
#eval "$(sed -n 's/^/bindkey /; s/: / /p' /etc/inputrc)"

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# cd not select parent dir
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# useful for path editing — backward-delete-word, but with / as additional delimiter
backward-delete-to-slash () {
  local WORDCHARS=${WORDCHARS//\//}
  zle .backward-delete-word
}
zle -N backward-delete-to-slash
bindkey -v
bindkey "^P" vi-up-line-or-history
bindkey "^N" vi-down-line-or-history

bindkey "^[[1~" vi-beginning-of-line   # Home
bindkey "^[[4~" vi-end-of-line         # End
bindkey '^[[2~' beep                   # Insert
bindkey '^[[3~' delete-char            # Del
bindkey '^[[5~' vi-backward-blank-word # Page Up
bindkey '^[[6~' vi-forward-blank-word  # Page Down
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' ${terminfo[smkx]}
    }
    function zle-line-finish () {
        printf '%s' ${terminfo[rmkx]}
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi
setopt noflowcontrol
stty -ixon
fortune | cowsay
