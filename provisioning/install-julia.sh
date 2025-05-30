#!/bin/bash
set -e

JULIA_VERSION="$1"
INSTALL_PREFIX="$2"

JULIA_VERSION_MAJOR=`echo "${JULIA_VERSION}" | cut -f 1,2 -d . | grep -o '[0-9.]*'`

DOWNLOAD_URL="https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_VERSION_MAJOR}/julia-${JULIA_VERSION}-linux-x86_64.tar.gz"
echo "INFO: Download URL: \"${DOWNLOAD_URL}\"." >&2

mkdir -p "${INSTALL_PREFIX}"
curl -L  "${DOWNLOAD_URL}" | tar --strip-components=1 -x -z -f - -C "${INSTALL_PREFIX}"
