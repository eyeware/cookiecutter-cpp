

A test-driven C++ project template built on CMake, Catch2 and conan.


A test-driven multimodule C++ project template build with CMake with support 
for python bindings, using pybind11_ and/or swig_ and crafted for TDD 
development cycle using Catch2_ for C++ and `Python unittest`_.

This project template, uses a by convention aproach, which modules are defined
by just replicating a folder structured, and named by the forlder name. Those 
convensions will apply and be reflected in python package structure and C++ 
include and library structure.



Usage
======

::

    pip install cookiecutter>=1.6.0
    cookiecutter gh:practicalci/cookiecutter-cpp


.. _Catch2 : https://github.com/catchorg/Catch2
.. _`Python unittest` : https://docs.python.org/3.6/library/unittest.html
.. _swig: http://www.swig.org/
.. _pybind11: https://pybind11.readthedocs.io/en/stable/



Cookiecutter options
====================

+---------------+---------------------+------------------------------------------------+----------------------------------------------------+
| context       | parameter           | Description                                    | defaults                                           |
+===============+=====================+================================================+====================================================+
|               | organization        | name of the organization that owns the project | "practicalci"                                      |
+               +---------------------+------------------------------------------------+----------------------------------------------------+
| **author**    | author              | author of the project                          | "First Last"                                       |
+               +---------------------+------------------------------------------------+----------------------------------------------------+
|               | email               | email of the author                            | "<author>|replace(' ','.')|lower }}@gmail.com"     |
+---------------+---------------------+------------------------------------------------+----------------------------------------------------+
|               |                     | license type under wh                          | one of {"MIT", "BSD-2-Clause", "BSD-3-Clause",     |
| **licensing** | license             | the software is licensed                       | "LGPL-2.1-only", "Apache-2.0", "GPL-2.0-only",     |
|               |                     |                                                | "GPL-3.0-only", "LGPL-3.0-only", "Not licensed"}   |
+               +---------------------+------------------------------------------------+----------------------------------------------------+
|               | year                | year of the license                            | 2019                                               |
+---------------+---------------------+------------------------------------------------+----------------------------------------------------+
|               | project_name        | name of the project                            | "rock"                                             |
+               +---------------------+------------------------------------------------+----------------------------------------------------+
|               | description         | one phrase describing the project,             | "A rock solid project"                             |
|               |                     | used in packaging description                  |                                                    |
+               +---------------------+------------------------------------------------+----------------------------------------------------+
|               | long_description    | a more detailed description of the project     | "A rock solid project with enforced style,         |
|               |                     | added to the README.rst of the project         | testing and static analysis"                       |
+               +---------------------+------------------------------------------------+----------------------------------------------------+
| **project**   | project_slug        | name used in the project folder and part       | "<project_name>|lower|replace(' ', '_')"           |
|               |                     | of the python package structure                |                                                    |
+               +---------------------+------------------------------------------------+----------------------------------------------------+
|               | project_namespace   | name used as a project namespace,              | "<organization>|first|lower"                       |
|               |                     | namely C++ namespace, and python root package  |                                                    |
+               +---------------------+------------------------------------------------+----------------------------------------------------+
|               | version             | project version                                | "0.0.0"                                            |
+               +---------------------+------------------------------------------------+----------------------------------------------------+
|               | cpp_standard        | C++ language standard                          | one of {"11","14","98"}                            |
+               +---------------------+------------------------------------------------+----------------------------------------------------+
|               | check_style         | enable code check style?                       | true                                               |
+---------------+---------------------+------------------------------------------------+----------------------------------------------------+
|               | git_server          | git server url                                 | one of {"bitbucket.org", "github.com"}             |
+               +---------------------+------------------------------------------------+----------------------------------------------------+
| **git**       | username            | git user name, part of the git url             | "<author>|first|lower<author>.split()|last|lower"  |
+               +---------------------+------------------------------------------------+----------------------------------------------------+
|               | branch              | git active branch                              | "master"                                           |
+               +---------------------+------------------------------------------------+----------------------------------------------------+
|               | remote              | git remote                                     | "origin"                                           |
+---------------+---------------------+------------------------------------------------+----------------------------------------------------+


References
==========

* Catch2_
* `Python unittest`_
* swig_
* pybind11_


