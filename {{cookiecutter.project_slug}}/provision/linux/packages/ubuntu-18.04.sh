#!/usr/bin/env bash
# @author: Mario Costa
# @date: 06/11/2018
 
# Ubunto development environment bootstrap script

#------------------------------------------------------------------------------
#            NOTE: DO NOT ADD LIBRARY DEPENDENCIES TO THIS FILE
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# Add here ubuntu specific tools that are not available via anaconda cloud 
# packages.
#------------------------------------------------------------------------------

apt-get install -y lcov
apt-get install -y gcc-7
apt-get install -y clang-format-6.0 clang-tidy-6.0
#iwyu
