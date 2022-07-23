#!/bin/sh
COLOR_DEFAULT='\033[0m'
COLOR_BLUE='\033[0;34m'

set_proxy(){
    export windows_host=`cat /etc/resolv.conf|grep nameserver|awk '{print $2}'`
    export ALL_PROXY="http://${windows_host}:7890" #10811
    export HTTP_PROXY="${ALL_PROXY}"
    export http_proxy="${ALL_PROXY}"
    export HTTPS_PROXY="${ALL_PROXY}"
    export https_proxy="${ALL_PROXY}"

    if [ "`git config --global --get proxy.https`" != "http://$windows_host:7890" ]; then #socks5 10810
                    git config --global proxy.https http://$windows_host:7890
    fi
}


if [ "$1" = "set" ]
then
        set_proxy
        echo -e "${COLOR_BLUE}#${COLOR_DEFAULT}"
fi
