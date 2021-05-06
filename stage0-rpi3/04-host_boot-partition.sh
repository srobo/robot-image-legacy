#!/bin/bash

source ./util.sh

if [[ "$OUTPUT_DEVICE" =~ ^/dev/loop ]]; then
  boot_part="${OUTPUT_DEVICE}p1"
else
  boot_part="${OUTPUT_DEVICE}1"
fi

echo $boot_part
