#!/bin/bash

cd "$(dirname "$0")" || exit 1
echo "===================================="
if [[ -z $ANSIBLE_CONFIG ]]; then echo "ANSIBLE_CONFIG is not defined"; else env | grep ANSIBLE_CONFIG; fi
echo "===================================="
PLAYBOOKS=( playbooks/* )

function menu() {
    echo
    echo "Pick a playbook number to run it:"
    echo "--------------------------------"
    select choice in "${PLAYBOOKS[@]}"; do
        [[ -n $choice ]] || { echo "Invalid choice..."; menu; }
        grep vault_password_file ansible.cfg | grep -q '#' && params="--ask-vault-pass" || params=""
        cmd="ansible-playbook $choice $params"
        echo
        echo "Running: $cmd"
        $cmd
        break
        echo
    done
}

menu

