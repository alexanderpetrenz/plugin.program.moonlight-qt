#!/bin/bash

# This script resolves a string to describe the platform where this script is
# executed. Information is pulled from /etc/os-release. For more info see:
#   https://www.linux.org/docs/man5/os-release.html

set -e

cd "$(dirname "$0")"

for file in /etc/os-release /usr/lib/os-release; do
  if [ -f $file ]; then
    source $file
    break
  fi
done

if [[ -v LIBREELEC_PROJECT ]]; then
  # Parse project var and convert to lower case
  PLATFORM="$(echo "$LIBREELEC_PROJECT" | tr '[:upper:]' '[:lower:]')"
  DISTRIBUTION="libreelec"
elif [[ -v ID ]] && [[ "${ID}" = "osmc" ]]; then
  PLATFORM=rpi
  DISTRIBUTION=${ID}
fi

if [ -f "../etc/${PLATFORM}.sh" ]; then
  echo "Platform $PLATFORM and Distribution $DISTRIBUTION detected..."
else
  echo "ERROR: Unknown platform: $PLATFORM" 1>&2
  return 2
fi
