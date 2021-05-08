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


function stage_banner {
  sed "s/\%/$1/" res/stage-banner
}
