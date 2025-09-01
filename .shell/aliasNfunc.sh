alias ls="eza --icons=always"
alias l="eza --icons=always"
# Go up [n] directories
up()
{
    local cdir="$(pwd)"
    if [[ "${1}" == "" ]]; then
        cdir="$(dirname "${cdir}")"
    elif ! [[ "${1}" =~ ^[0-9]+$ ]]; then
        echo "Error: argument must be a number"
    elif ! [[ "${1}" -gt "0" ]]; then
        echo "Error: argument must be positive"
    else
        for ((i=0; i<${1}; i++)); do
            local ncdir="$(dirname "${cdir}")"
            if [[ "${cdir}" == "${ncdir}" ]]; then
                break
            else
                cdir="${ncdir}"
            fi
        done
    fi
    cd "${cdir}"
}


# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias h='history 1'

# cd to git root directory
alias cdgr='cd "$(git root)"'

# Create a directory and cd into it
mcd() {
    mkdir "${1}" && cd "${1}"
}

path_remove() {
    PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: "\$0 != \"$1\"" | sed 's/:$//')
}

path_append() {
    path_remove "$1"
    PATH="${PATH:+"$PATH:"}$1"
}

path_prepend() {
    path_remove "$1"
    PATH="$1${PATH:+":$PATH"}"
}
alias d='cd ~/Desktop'
alias dds='cd ~/Downloads'
t() {
    if tmux ls 2>/dev/null | grep -q "^"; then
    # If there are existing sessions, attach to the first one
    tmux a
else
    # If no sessions exist, create a new session
    tmux 
fi 
}

#vocab() {
#    local word="$1"
#    local url="https://www.vocabulary.com/dictionary/$word" 
#    local short=$(wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" -qO- "$url" | htmlq --text 'p.short')
#    local long=$(wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" -qO- "$url" | htmlq --text 'p.long')
#    local BRIGHT_GREEN="\033[1;32m"
#    local BRIGHT_CYAN="\033[1;36m"
#    local RESET="\033[0m"
#    echo -e "${BRIGHT_CYAN}$short${RESET}"
#    echo -e "${BRIGHT_GREEN}$long${RESET}"
#}
alias vi='vim'
alias v='nvim'
e() {
  if [ -n "$INSIDE_EMACS" ]; then
    emacsclient -n "$@"
  elif emacsclient -e 't' >/dev/null 2>&1; then
    emacsclient -n "$@"
  else
    emacs -nw "$@"
  fi
}

en(){
  if [ -n "$INSIDE_EMACS" ]; then
    echo "Inside Emacs"
  elif emacsclient -e 't' >/dev/null 2>&1; then
    emacsclient -n -c "$@"
  else
    echo "No emacs server"
  fi
}
alias clip='xclip -sel clip'
alias cppwd='pwd | xclip -sel clip'
[[ "$TERM" == "xterm-kitty" ]] && alias ssh="TERM=xterm-256color ssh"
alias setproxy='source ~/.local/bin/setproxy'
alias unsetproxy='source ~/.local/bin/unsetproxy'

vterm_printf() {
    if [ -n "$TMUX" ] \
        && { [ "${TERM%%-*}" = "tmux" ] \
            || [ "${TERM%%-*}" = "screen" ]; }; then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

alias dots='git --git-dir="$HOME/.dots" --work-tree="$HOME"'
alias sysdots='sudo -E git --git-dir="$HOME/.sysdots" --work-tree=/etc'
