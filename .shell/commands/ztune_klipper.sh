#!/bin/bash

source /opt/config/mod/.shell/common.sh

MCU_F="/opt/klipper/klippy/mcu.py"
TOOLHEAD_F="/opt/klipper/klippy/toolhead.py"

already_done_e11() {
    echo "Communication Timeout (E0011) already in sync!"
}

fix_disable_e11() {
    echo "Reverting TRSYNC_TIMEOUT"

    grep -qe "^TRSYNC_TIMEOUT = 0.025" $MCU_F \
        && already_done_e11 && return
    
    sed -i 's|^TRSYNC_TIMEOUT = .*|TRSYNC_TIMEOUT = 0.025|' $MCU_F

    sync
    echo "Done"
}

fix_enable_e11() {
    echo "Patching TRSYNC_TIMEOUT"

    grep -qe "^TRSYNC_TIMEOUT = 0.05" $MCU_F \
        && already_done_e11 && return
    
    sed -i 's|^TRSYNC_TIMEOUT = .*|TRSYNC_TIMEOUT = 0.05|' $MCU_F

    sync
    echo "Done"
}

already_done_e17() {
    echo "Move Queue Overflow (E0017) already in sync!"
}

fix_disable_e17() {
    echo "Reverting LOOKAHEAD_FLUSH_TIME"

    grep -qe "^LOOKAHEAD_FLUSH_TIME = 0.5" $TOOLHEAD_F \
        && already_done_e17 && return
    
    sed -i 's|^LOOKAHEAD_FLUSH_TIME = .*|LOOKAHEAD_FLUSH_TIME = 0.5|' $TOOLHEAD_F

    sync
    echo "Done"
}

fix_enable_e17() {
    echo "Patching LOOKAHEAD_FLUSH_TIME"

    grep -qe "^LOOKAHEAD_FLUSH_TIME = 0.150" $TOOLHEAD_F \
        && already_done_e17 && return
    
    sed -i 's|^LOOKAHEAD_FLUSH_TIME = .*|LOOKAHEAD_FLUSH_TIME = 0.150|' $TOOLHEAD_F

    sync
    echo "Done"
}

fix_disable_all() {
    fix_disable_e11
    fix_disable_e17
}

fix_enable_all() {
    fix_enable_e11
    fix_enable_e17
}

fix_apply() {
    local enabled="$($CFG_SCRIPT "$VAR_PATH" --get "fix_e0017" "MISSING")"
    if [ "$enabled" = 'MISSING' ]; then
        enabled="$($CFG_SCRIPT "$VAR_PATH" --get "tune_klipper" "0")"
    fi

    if [ "$enabled" == "0" ]; then
        fix_disable_all
    else
        fix_enable_all
    fi
}

case "$1" in
    0)
        fix_disable_all
    ;;
    1)
        fix_enable_all
    ;;
    apply)
        fix_apply
    ;;
    *)
        echo "Command not supported"
        exit 1
esac
