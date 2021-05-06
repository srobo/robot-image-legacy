#!/bin/bash
set -e

source ./util.sh

info "Applying Student Robotics Branding"
cp stage1/files/issue "$BUILD_DIR/etc/issue"
cp stage1/files/motd "$BUILD_DIR/etc/motd"