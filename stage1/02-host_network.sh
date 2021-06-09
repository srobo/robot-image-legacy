#!/bin/bash
set -e

source ./util.sh

info "Copying systemd-networkd configuration"
cp stage1/files/*.net* "$BUILD_DIR/etc/systemd/network/"

info "Copying dnsmasq configuration"
cp stage1/files/dnsmasq.conf "$BUILD_DIR/etc/dnsmasq.conf"

info "Copying DNS resolver configuration"
cp stage1/files/resolv.conf "$BUILD_DIR/etc/resolv.conf"

info "Copying MQTT server configuration"
cp stage1/files/mosquitto.conf "$BUILD_DIR/etc/mosquitto/mosquitto.conf"
