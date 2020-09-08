#!/bin/bash
docks stop
systemctl stop syncthing
systemctl stop bitcoind
systemctl stop transmission-daemon
systemctl stop apache2
sync
sleep 5
exit 0
