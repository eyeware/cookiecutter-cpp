#!/usr/bin/env bash
# @author: Mario Costa
# @date: 20/11/2018

#------------------------------------------------------------------------------
# Get Current Script Source Dir. This Macro Needs to Duplicated ...
#------------------------------------------------------------------------------

# get this script source folder. Make sure remaining scripts are in the same
# source folder.

# source: https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within

SOURCE_="${BASH_SOURCE[0]}"

# resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE_" ]; do
  DIR_="$( cd -P "$( dirname "$SOURCE_" )" >/dev/null && pwd )"
  SOURCE_="$(readlink "$SOURCE_")"

  # if $SOURCE was a relative symlink, we need to resolve it relative to the 
  # path where the symlink file was located
  [[ $SOURCE_ != /* ]] && SOURCE="$DIR_/$SOURCE_"
done
DIR_="$( cd -P "$( dirname "$SOURCE_" )" >/dev/null && pwd )"

#------------------------------------------------------------------------------
# Execute Specific Linux Distro Provisioning Here.
#------------------------------------------------------------------------------

# get current linux distro
DISTRO_="$($DIR_/distro.sh)"

# execute distro specific provisioning scripts.
$DIR_/packages/$DISTRO_.sh

#------------------------------------------------------------------------------
# Execute Generic Linux Provisioning Here
#------------------------------------------------------------------------------

# if using snap, and other alike linux distro independent tools add here

# install conda
$DIR_/linux.sh

