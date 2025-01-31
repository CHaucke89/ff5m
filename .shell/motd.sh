#!/bin/bash

## motd generator
##
## Copyright (C) 2025, Alexander K <https://github.com/drA1ex>
##
## This file may be distributed under the terms of the GNU GPLv3 license

MOD_VERSION=$(cat /opt/config/mod/version.txt)
FIRMWARE_VERSION=$(cat /root/version)

centered() {
    local text="$1"; local width=$2; local offset=${3:-0}
    
    local p_text=$(echo -ne "$text" | sed $'s/\x1b\[[0-9;]*m//g')
    local length=${#p_text}
    
    local left_padding=$(( ($width - ${length}) / 2 ))
    local right_padding=$(( $offset + $width - ${length} - $left_padding ))
    
    printf "%*s%s%*s" $left_padding "" "$text" $right_padding ""
}

# Calculate special offset since old bash versions can't correctly calculate emoji as 1 length
_S="🔥"
_OFFSET=$(( ${#_S} - 1 ))

MOD_TEXT=$(centered "🔥 \033[36mZMOD+ v${MOD_VERSION}" 35 $_OFFSET)
FF_TEXT=$(centered "\033[1;33m⚡ \033[36mAD5M v${FIRMWARE_VERSION}" 35 $_OFFSET)

echo -e "\033[35m


 ███████╗ ██╗ █████╗ ███████╗██╗  ██╗███████╗ ██████╗ ██████╗  ██████╗ ███████╗
 ██╔════╝███║██╔══██╗██╔════╝██║  ██║██╔════╝██╔═████╗██╔══██╗██╔════╝ ██╔════╝
 █████╗  ╚██║███████║███████╗███████║█████╗  ██║██╔██║██████╔╝██║  ███╗█████╗
 ██╔══╝   ██║██╔══██║╚════██║██╔══██║██╔══╝  ████╔╝██║██╔══██╗██║   ██║██╔══╝
 ██║      ██║██║  ██║███████║██║  ██║██║     ╚██████╔╝██║  ██║╚██████╔╝███████╗
 ╚═╝      ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝██║      ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝
                                     ██║
 ${MOD_TEXT}\033[0;35m██║  ${FF_TEXT}\033[0;35m
                                     ╚═╝

\033[0m"