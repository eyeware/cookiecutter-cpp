#!/usr/bin/env bash
# @author: Mario Costa
# @date: 15/11/2018


source_dir() {
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

  echo $DIR_
}
