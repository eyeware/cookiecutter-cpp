#!/usr/bin/env bash
# @author: Mario Costa
# @date: 2018/11/06
 
# Ubuntu development environment bootstrap script

#------------------------------------------------------------------------------
#            NOTE: DO NOT ADD LIBRARY DEPENDENCIES TO THIS FILE
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# Add here ubuntu specific tools that are not available via anaconda cloud 
# packages.
#------------------------------------------------------------------------------

apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        vim \
        g++ \
        gcc \
        g++-7 \
        gcc-7 \
        clang-tools-6.0 \
        clang-tidy-6.0 \
        clang-format-6.0 \
        valgrind \
        iwyu && \
    apt-get clean -y && \
    apt-get autoremove --purge -y

