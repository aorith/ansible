#!/bin/bash
set -o errexit
set -o pipefail


THRESHOLD=65.0

# testing if $1 > $2
decimal_compare() {
    [ ${1%.*} -eq ${2%.*} ] && [ ${1#*.} \> ${2#*.} ] || [ ${1%.*} -gt ${2%.*} ]
}

if [ "$(hostname)" = "pve" ]; then
    TEMP="$(/usr/bin/sensors -A -u -j|jq '."k10temp-pci-00c3"."Tdie"."temp1_input"')"
else
    TEMP="$(awk 'BEGIN{count=0}{suma+=$1}{count+=1}END{printf "%0.2f", suma/1000/count}' /sys/class/thermal/thermal_zone*/temp)"
fi

if decimal_compare ${TEMP} ${THRESHOLD}; then
    printf "KO: Temperatura media de %sC" "$TEMP"
    exit 1
fi

printf "OK: Temperatura media de %sC" "$TEMP"
