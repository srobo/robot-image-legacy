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
export -f vinfo


function cleanup {
  info "Cleaning up"
  info "Unmounting" "$OUTPUT_DEVICE"
  umount -R "$BUILD_DIR"
  if [[ "$OUTPUT_DEVICE" =~ ^/dev/loop ]]; then
    losetup -d "$OUTPUT_DEVICE"
  fi
}
export -f cleanup

function stage_banner {
  sed "s/\%/$1/" res/stage-banner
}
