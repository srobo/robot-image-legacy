#!/bin/bash
set -e

source ./util.sh

info "Copying configuration files"
echo "... for root"
cp stage2/files/vimrc "$BUILD_DIR/root/.vimrc"
cp stage2/files/bashrc "$BUILD_DIR/root/.bashrc"
echo "... for robot"
cp stage2/files/vimrc "$BUILD_DIR/home/robot/.vimrc"
cp stage2/files/bashrc "$BUILD_DIR/home/robot/.bashrc"

