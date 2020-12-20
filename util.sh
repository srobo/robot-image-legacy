#!/bin/bash
function info {
  printf "\e[1m\e[93m%s \e[0m%s\n" "$1" "$2";
}

export -f info

function vinfo {
  if [[ $VERBOSE -gt 0 ]]; then
    info "$1" "$2"
  fi
}

function cleanup {
  info "Unmounting" "$LOOP_DEV"
  umount -R "$BUILD_DIR"
  losetup -d "$LOOP_DEV"
  exit 1
}

export -f vinfo
