#!/usr/bin/env bash

# This script tries to identify the linux ditro, and prints the distro name.

# retrieved from: https://unix.stackexchange.com/questions/92199/how-can-i-reliably-get-the-operating-systems-name

usage() { 
    echo distro $0 [-i] [-r]
    echo     -i        print OS distribution id
    echo     -r        print OS distribution release
    echo     -f        "print OS distribution as <id>-<release>"
}

# Determine OS platform
UNAME_=$(uname | tr "[:upper:]" "[:lower:]")
# If Linux, try to determine specific distribution
if [ "$UNAME_" == "linux" ]; then
    # If available, use LSB to identify distribution
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
        DISTRO_=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
        DISTRO_RELEASE_=$(lsb_release --release | cut -d: -f2 | sed s/'^\t'//)
    # Otherwise, use release info file
    else
        # TODO: untested and incomplete.
        export DISTRO_=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" |   \
                         grep -v "os-release" | cut -d'/' -f3 | cut -d'-' -f1 | \
                         cut -d'_' -f1)
    fi
fi
# For everything else (or if above failed), just use generic identifier
[ "$DISTRO_" == "" ] && DISTRO_=$UNAME
unset UNAME_


while getopts "irf" opt; do
  case $opt in
    i)
      echo $DISTRO_ | tr "[:upper:]" "[:lower:]"
      ;;
    r)
      echo $DISTRO_RELEASE_
      ;;
    f)
      echo "$(echo ${DISTRO_} | tr "[:upper:]" "[:lower:]")-${DISTRO_RELEASE_}"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      usage
      ;;
  esac
done

unset UNAME_
unset DISTRO_
unset DISTRO_RELEASE_
