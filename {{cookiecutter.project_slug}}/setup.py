#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys


from skbuild import setup
from setuptools import find_packages

with open('README.rst') as readme_file:
    readme = readme_file.read()

requirements = [] # TODO: load from conda file.

setup_requirements = [ ]

test_requirements = [ ]

# Require pytest-runner only when running tests
pytest_runner = (['pytest-runner>=2.0,<3dev']
                 if any(arg in sys.argv for arg in ('pytest', 'test'))
                 else [])

setup_requires = pytest_runner


# 1.
# if environment CONDA_BUILD=1, then we are building inside conda, so we need to
# set proper library locations and options. see https://conda.io/projects/conda-build/en/latest/source/environment-variables.html

# 2.
# if under an active conda environment, check for one of the following env 
# variables
# CONDA_PREFIX=/home/.../.conda/envs/rock
# CONDA_DEFAULT_ENV=rock # default environment name

# 3.
# ???? pure python bdist, put the libs inside python package under 
# <package_name>/lib/... fix the rpath acordingly, dunno about windows.

# for build options refer to https://scikit-build.readthedocs.io/en/latest/usage.html


cmake_args = [
    '-DBUILD_PYTHON_PYBIND11=ON',
#    '-DBUILD_PYTHON_SWIG=ON',
    '-DINSTALL_FOR_PYPI=ON',
]

if os.environ.get('CONDA_BUILD') == '1': # if under conda build
    cmake_args += [
        '-DCMAKE_INSTALL_PREFIX={}'.format(os.environ['PREFIX']),
    ]


# see namespace packages https://packaging.python.org/guides/packaging-namespace-packages/#native-namespace-packages
setup(
    name='{{ cookiecutter.project_namespace }}-{{ cookiecutter.project_slug }}',
    version='{{ cookiecutter.version }}',
    description='{{ cookiecutter.description }}',
    long_description=readme,
    author='{{ cookiecutter.author }}',
    author_email='{{ cookiecutter.email }}',
    license='{{ cookiecutter.license }}',
    package_dir = {'': os.path.join('src','python')},
    packages=['{{ cookiecutter.project_namespace }}.{{ cookiecutter.project_slug }}'],
    install_requires=requirements,
    tests_require=['pytest'],
    setup_requires=setup_requires,
    test_suite='tests.python',
    cmake_args=cmake_args,
    cmake_minimum_required_version='3.12',

#[
#
#        '-DBUILD_PYTHON_PYBIND11=ON',
#        '-DBUILD_PYTHON_SWIG=ON',
#        '-DBUILD_TESTS=ON',
# to build for a conda environment please check the environment variables
# https://docs.conda.io/projects/conda-build/en/latest/source/environment-variables.html?highlight=environment
#        '-DCMAKE_INSTALL_PREFIX={}'.format(os.environ['PREFIX']),
#        '-DPYTHON_SITE_PACKAGES={}'.format(os.environ['SP_DIR']),
#    ]
)
