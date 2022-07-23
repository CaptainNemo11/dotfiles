alias d='cd /mnt/d'
alias dp='cd /mnt/d/DESKTOP'
alias python='python3'
alias folder='explorer.exe'
alias office='libreoffice'
#alias v='wslview'
alias powershell.exe='/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe'
alias chrome='/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe'
alias cmd='/mnt/c/Windows/System32/cmd.exe'
alias battery='cat /sys/class/power_supply/BAT1/capacity'
alias ="cat /sys/class/power_supply/BAT1/capacity | tr '\n' ' ' ; printf \(; cat /sys/class/power_supply/BAT1/status | tr -d '\n'  ; printf \);"
alias text="chrome 'data:text/html,<html contenteditable>'"
#alias b='cd /mnt/d/book'
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias ls='ls --color=auto'
#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

b(){
    if [[ "${1}" == "-cd" ]]; then
        cd /mnt/d/book
    elif [[ "${1}" == "" ]]; then
        chrome file:///d:/book
    fi
}
r() {
    if [[ "${1}" == "-cd" ]]; then
        cd /mnt/d/readings
    elif [[ "${1}" == "" ]]; then
        chrome file:///d:/readings
    fi
}
#alias r='cd /mnt/d/readings'
alias c='/mnt/c/Windows/System32/clip.exe'
alias sd='wsl.exe --shutdown'
# Create a directory and cd into it
mcd() {
    mkdir "${1}" && cd "${1}"
}
# copy pwd to clipboard
cppwd() {
    pwd | c
}
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
alias cr='code -r'
alias cg='code -g'
alias t='tmux a'
alias book='/mnt/d/book'
alias readings='/mnt/d/readings'
#mv to book
mvtob()
{
    for i in "$@"
    do
        mv "${i}" /mnt/d/book
    done
}
#mv to readings
mvtor()
{
    for i in "$@"
    do
        mv "${i}" /mnt/d/readings
    done
}
#cp to readings
cptor()
{
    for i in "$@"
    do
        cp "${i}" /mnt/d/readings
    done
}
#cp to book
cptob()
{
    for i in "$@"
    do
        cp "${i}" /mnt/d/book
    done
}
#weather
#alias w='curl wttr.in/hangzhou'
#alias w='curl wttr.in/panjin'
#alias w='curl wttr.in/guangzhou'
alias w='curl wttr.in/beijing'
#cdrecv
cdrecv()
{
    if [[ "${1}" == "we" ]]; then
        cd /mnt/d/.application/wechatfiles/WeChat\ Files/wxid_5uht15nadvjq22/FileStorage/File
    elif [[ "${1}" == "qq" ]]; then
        cd /mnt/d/.application/qq/374385562/FileRecv
        if [[ "${2}" == "phone" ]];then
            cd MobileFile
        fi
    fi
}
#p from clipboard
p()
{
    powershell.exe Get-Clipboard | sed 's/\r//'
    # The `sed` will remove the unwelcome carriage-returns
}
#cd from clipboard
cdfc()
{
    cd "$(p)"
}
#shorten url
sturl(){
    for i in "$@"
    do
        curl -s tinyurl.com/api-create.php?url="${i}" | tee /dev/tty|c
        echo -e 
    done
}
#file transfer less than 256MIB
ftrsf()
{
    if [[ $(ls -al "${1}" | awk '{print $5}') -lt 268435456 ]]
    then
        curl -F file=@${1} https://ttm.sh | tee /dev/tty | c
    fi
}
#battery report 
brpt()
{
        (cd ; powershell.exe  powercfg /batteryreport  >&/dev/null ; cd - ; v ~/battery-report.html ;sleep 2)
        rm ~/battery-report.html
}
alias ws='powershell.exe'
#search in google
s()
{
    search="$*"
    v https://www.google.com/search?q="${search}"
}
#BROWSER file 
vb()
{
    "${BROWSER}" $(wslpath -w "${1}")
}
alias m="neomutt"
alias dnld="/mnt/d/.application/Aria2/AriaNg启动器.exe"
qr()
{
    echo "$*" | curl -F-=\<- qrenco.de
}
alias ccb='echo | c'
draft()
{
    if [[ ${1} == "web" ]] 
    then
        text
    else 
        cd
        vim
        cd -
    fi
}
alias now="date | awk '{print \$4}'"
alias i='vb 2.2.2.2'
alias newfolder="cd /mnt/d/DESKTOP/新建文件夹\ \(" 
alias list='joplin'

alias javastyle="python3 /mnt/d/.application/jdk19/library-sp18/style/style61b.py "
alias sc="cd /mnt/c/Users/15964/Pictures/Screenshots"
v()
{
    local arg
    #as a single file
    if [[ "${1}" == "-o" ]]; then
        shift 
        arg="$*"
        wslview "${arg}"
    #web
    elif [[ "${1}" == "-w" ]]; then
        arg="https://${2}"
        wslview "${arg}"
    #force to use browser
    elif [[ "${1}" == "-b" ]]; then
        arg="${2}"
        "${BROWSER}" $(wslpath -w "${arg}")
    #multiple files
    else
        for i in "$@"
        do
            arg="$(wslpath -w ${i})"
            wslview "${arg}"
        done
    fi
}
alias gpt='v -w chat.openai.com'
alias hn='curl -sS hkkr.in/a-f1-h | more'
tdw() {
    # Get today's date in mm/dd/yy format
    file_name=$(date +"%m_%d_%y_writing")

    # Open the file with Vim
    vim ~/.writing/"$file_name"
}
alias dotfiles='ls -a  $HOME | grep "^\."'
