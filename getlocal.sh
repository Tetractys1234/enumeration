#!/bin/bash -
#
# Enumeration Demo Ethical Hacking Club
# Adapted from CyberSecurity Ops with Bash O'Reilly
#
# Description:
# Gathers general system information and dumps it into a file

# Usage:
# bash getlocal.sh < cmds.txt
# cmds.txt is a list of commands to run.

# SepCmds - seperate commands from line of input.
# DumpInfo - 

function SepCmds()
{
    LCMD=${ALINE%%|*}
    REST=${ALINE#*|}
    WCMD=${REST%%|*}
    REST=${REST#*|}
    TAG=${REST%%|*}

    if [[ $OSTYPE == "MSWin" ]]
    then
        CMD="$WCMD"
    else
        CMD="$LCMD"
    fi
}

function DumpInfo()
{
    printf '<?xml version="1.0" encoding="UTF-8" ?>\n'
    printf '<systeminfo host="%s" type="%s"' "$HOSTNAME" "$OSTYPE"
    printf ' date="%s" time="%s">\n' "$(date '+%F')" "$(date '+%T')"
    readarray CMDS
    for ALINE in "${CMDS[@]}"
    do
        # ignore comments
        if [[ ${ALINE:0:1} == '#' ]] ; then continue ; fi

        SepCmds

        if [[ ${CMD:0:3} == N/A ]]
        then
            continue
        else
            printf "<%s>\n" $TAG
            $CMD
            printf "\n</%s>\n" $TAG
        fi
    done
    printf "</systeminfo>\n"
}

OSTYPE=$(./osdetect.sh)
HOSTNM=$(hostname)
TMPFILE="${HOSTNM}.info"

DumpInfo > $TMPFILE 2>&1

