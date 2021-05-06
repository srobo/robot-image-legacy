#!/bin/bash
set -e

source ./util.sh

info "Creating build metadata"
(
  echo BUILD_USER="$(whoami)"
  echo BUILD_HOST="$(hostname)"
  echo BUILD_TIME="$(date)"
  echo BUILD_COMMIT="$(git rev-parse --short HEAD)"
  echo BUILD_TAG="$(git describe --exact-match --tags)"
  if [ -n "$GITHUB_ACTIONS" ]; then
    echo GITHUB_ACTOR="${GITHUB_ACTOR}"
    echo GITHUB_REF="${GITHUB_REF}"
    echo GITHUB_REPOSITORY="${GITHUB_REPOSITORY}"
  fi
) > "$BUILD_DIR/etc/build-info"
