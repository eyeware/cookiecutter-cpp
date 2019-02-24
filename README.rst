

Multimodule C++ project template with support for python bindings, using pybind11_ and/or swig_ and crafted with TDD development cycle using Catch2 for C++.

.. _swig: http://www.swig.org/
.. _pybind11: https://pybind11.readthedocs.io/en/stable/


Project Structure
=================


::

    {{cookiecutter.project_slug}}/
    ├── attributions                                   # Add here author attribution for derived work.
    ├── cpp
    │   ├── CMakeLists.txt                             # CMake defining project configurations and targets
    │   ├── cmake                                      # cmake modules used by the project
    │   ├── conanfile.txt                              # conan file with C++ library dependencies (TODO: to be removed and swiched to anaconda only)
    │   ├── conda                                      # conda dependencies
    │   │   ├── condabuild.yaml                        # conda build dependencies
    │   │   ├── condadev.yaml                          # conda development dependencies
    │   │   ├── recipe-lib                             # TODO: lib package recipe (dynamic libs only)
    │   │   └── recipe-dev                             # TODO: dev package recipe (includes and static libs,and dependes on recipe-lib package)
    │   ├── doc                                        # docs folder, used to generate code documentation - dev package
    │   │   ├── CMakeLists.txt
    │   │   └── Doxyfile.in
    │   ├── include
    │   │   └── {{cookiecutter.project_slug}}          # project public API, (other project will use #include "project_name/...")
    │   │       ├── core                               # example module, public module includes
    │   │       │   ├── A.h
    │   │       │   ...
    │   │       │   └── D.h
    │   │       └── README.rst
    │   ├── Makefile
    │   ├── src                                        # source code folder, for now its empty.
    │   │   ├── core                                   # example module, source code and private includes go here.
    │   │   │   ├── CMakeLists.txt
    │   │   │   ├── core_python_bindings.cpp           # {{module_name}}_python_bindings.cpp, pybind11 bindings
    │   │   │   ├── A.cpp
    │   │   │   ...
    │   │   │   ├── E.cpp
    │   │   │   └── E.h
    │   │   └── module1
    │   └── test                                       # folder contains unit and integration tests to test the project functionality.
    │       ├── CMakeLists.txt
    │       ├── core                                   # core module unit tests go here.
    │       │   ├── CMakeLists.txt
    │       │   └── test_core.cpp                      # Catch2 unit tests for module 
    │       └── test_{{cookiecutter.project_slug}}.cpp # project main test suite, catch2 main class
    ├── LICENSE
    ├── pre-commit                                     # pre-commit git hook, performs checks that validate that the developer can commit the code. (TODO: needs to be fixed.)
    ├── python                                         # python project, add here tests for python, that might include testing interoperability between python code and C++.
    │   ├── {{cookiecutter.project_slug}}              # python source code goes here.
    │   ├── setup.py                                   # python package setup file, using scikit-build to integrate with the C++ library and extensions.
    │   └── tests                                      # python tests go here. (TODO: TBD if it is module based ...)
    │       └── test_{{cookiecutter.project_slug}}.py  # python unit test.
    └── README.rst
    

CMake Project
=============

Options
-------

1. 
2. 

Output
------

There are some instalation requirements that need to be addressed, namely locating libraries for linking.

There are several possible instalation use-cases:

1. c++ only development (?)
2. linux system (using cmake GNUInstallDirs)
3. windows system (?)
4. conda cross platform
5. python bdist
6. python development mode (``python setup.py install development``)


Conda Packages
~~~~~~~~~~~~~~

Conda packages produced by the project.

+-----------------------+----------------------------------------------------------+--------------------------------------------------------+--------------------------------+
| package name          | description                                              | files                                                  | package dependencies           |
+=======================+==========================================================+========================================================+================================+
| <project_name>-lib    | shared libraries                                         | lib/<project_name>/lib<module1>.so                     | 3rd party libs                 |
+                       +                                                          +--------------------------------------------------------+--------------------------------+
|                       |                                                          | lib/<project_name>/lib<module1>.so                     |                                |
+                       +                                                          +--------------------------------------------------------+--------------------------------+
|                       |                                                          | lib/<project_name>/lib<module2>.so                     | from conda forge               |
+                       +                                                          +--------------------------------------------------------+--------------------------------+
|                       |                                                          | ...                                                    |                                |
+-----------------------+----------------------------------------------------------+--------------------------------------------------------+--------------------------------+
| <project_name>-dev    | developmen, cmake targets, include files and static libs | lib/<project_name>/lib<module1>.a                      | <project_name>-lib             |
+                       +                                                          +--------------------------------------------------------+--------------------------------+
|                       |                                                          | lib/<project_name>/lib<module2>.a                      |                                |
+                       +                                                          +--------------------------------------------------------+--------------------------------+
|                       |                                                          | ...                                                    |                                |
+                       +                                                          +--------------------------------------------------------+--------------------------------+
|                       |                                                          | lib/cmake/<project_name>/<project_name>Targets.cmake   |                                |
+                       +                                                          +--------------------------------------------------------+--------------------------------+
|                       |                                                          | lib/cmake/<project_name>/<project_name>Config.cmake    |                                |
+                       +                                                          +--------------------------------------------------------+--------------------------------+
|                       |                                                          | include/<project_name>/                                |                                |
+-----------------------+----------------------------------------------------------+--------------------------------------------------------+--------------------------------+
| <project_name>-python | C++ python bindings (pybind11 or/and swig)               | <project_name>/<module1>.<python-sufix>.so             | <project_name>-lib             |
+                       +                                                          +--------------------------------------------------------+--------------------------------+
|                       |                                                          | <project_name>/<module2>.<python-sufix>.so             | or none, if static compiled    |
+                       +                                                          +--------------------------------------------------------+--------------------------------+
|                       |                                                          | ...                                                    | TODO: check nuitka subpackages |
+                       +                                                          +--------------------------------------------------------+--------------------------------+
|                       |                                                          | swig generated python files ...                        |                                |
+                       +                                                          +--------------------------------------------------------+--------------------------------+
|                       |                                                          | <project_name>/pyinstaller/<project_name>.spec (TODO:) |                                |
+                       +                                                          +--------------------------------------------------------+--------------------------------+
|                       |                                                          | <project_name>/pyinstaller/hooks (TODO:)               |                                |
+-----------------------+----------------------------------------------------------+--------------------------------------------------------+--------------------------------+

Development
~~~~~~~~~~~












    
References
==========

_swig
_pybind11