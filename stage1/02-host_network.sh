#!/bin/bash
set -e

source ./util.sh

info "Enabling DHCP for Ethernet"
cp stage1/files/eth0.network "$BUILD_DIR/etc/systemd/network/eth0.network"
