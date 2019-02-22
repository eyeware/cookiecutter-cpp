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

# for build options refer to https://scikit-build.readthedocs.io/en/latest/usage.html

setup(
    name='{{ cookiecutter.project_slug }}',
    version='{{ cookiecutter.version }}',
    description='{{ cookiecutter.description }}',
    long_description=readme,
    author='{{ cookiecutter.author }}',
    author_email='{{ cookiecutter.email }}'
    license='{{ cookiecutter.open_source_license }}',
    packages=find_packages(exclude=['*.tests', '*.tests.*', 'tests.*', 'tests']),
    install_requires=requirements,
    tests_require=['pytest'],
    setup_requires=setup_requires,
    test_suite='tests',
    cmake_source_dir=os.path.join('..','cpp'),
    cmake_args=[

        '-DBUILD_PYTHON_PYBIND11=ON', 
#        '-DBUILD_PYTHON_SWIG=ON',
#        '-DBUILD_TESTS=ON',
# to build for a conda environment please check the environment variables
# https://docs.conda.io/projects/conda-build/en/latest/source/environment-variables.html?highlight=environment
#        '-DCMAKE_INSTALL_PREFIX={}'.format(os.environ['PREFIX']),
#        '-DPYTHON_SITE_PACKAGES={}'.format(os.environ['SP_DIR']),


    ]
)
