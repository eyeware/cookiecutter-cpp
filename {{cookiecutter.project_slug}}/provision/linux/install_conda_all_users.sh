#!/usr/bin/env bash

# TODO: this required to edit the script when the version changed due to md5 check.
CONDA_VER="4.5.11"

CONDA_HOME=/opt/conda

# Get Miniconda3 and make it the main Python interpreter
if [ ! -d $CONDA_HOME ]; then
    echo "Downloading and Installing Miniconda3"
    curl -s -L https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VER}-Linux-x86_64.sh > miniconda.sh && \
    echo e1045ee415162f944b6aebfe560b8fee miniconda.sh | md5sum -c && \
    bash miniconda.sh -b -p $CONDA_HOME && \
    rm miniconda.sh && \
    touch $CONDA_HOME/conda-meta/pinned && \
    ln -s $CONDA_HOME/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    export PATH=$CONDA_HOME/bin:$PATH && \
    conda config --set show_channel_urls True && \
    conda config --append channels conda-forge && \
    conda config --append channels defaults && \
    conda update --all --yes && \
    conda clean -tipy
else
    echo "Miniconda is already installed in $CONDA_HOME"
fi

