#!/bin/sh

VER_FF=$(cat /opt/config/mod/version.txt 2>/dev/null| cut  -d "." -f 1,2,3)
VER_MOD="0.0.0"

if [ -f "/root/printer_data/version.txt" ]
    then 
        VER_MOD=$(cat /root/printer_data/scripts/version.txt 2>/dev/null| cut  -d "." -f 1,2,3)
    else if [ -f "/root/printer_data/scripts/version.txt" ]
        then
            VER_MOD=$(cat /root/printer_data/scripts/version.txt 2>/dev/null| cut  -d "." -f 1,2,3)
    fi
fi


if [ "${VER_FF}" != "${VER_MOD}" ]
    then
        echo "RESPOND TYPE=error MSG=\"Обновите ZMOD с флешки, последняя версия ${VER_FF}, текущая версия ${VER_MOD}\"" >/tmp/printer
        echo 'RESPOND TYPE=echo MSG="https://github.com/ghzserg/zmod/wiki/Setup"' >/tmp/printer
fi
