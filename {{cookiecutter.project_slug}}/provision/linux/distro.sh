#!/usr/bin/env bash

# This script tries to identify the linux ditro, and prints the distro name.

# retrieved from: https://unix.stackexchange.com/questions/92199/how-can-i-reliably-get-the-operating-systems-name

# Determine OS platform
UNAME_=$(uname | tr "[:upper:]" "[:lower:]")
# If Linux, try to determine specific distribution
if [ "$UNAME_" == "linux" ]; then
    # If available, use LSB to identify distribution
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
        export DISTRO_=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
    # Otherwise, use release info file
    else
        export DISTRO_=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" |   \
                         grep -v "os-release" | cut -d'/' -f3 | cut -d'-' -f1 | \
                         cut -d'_' -f1)
    fi
fi
# For everything else (or if above failed), just use generic identifier
[ "$DISTRO_" == "" ] && export DISTRO_=$UNAME
unset UNAME_

echo $DISTRO_ | tr "[:upper:]" "[:lower:]"
