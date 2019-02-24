

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
    │   ├── conanfile.txt                              # conan file, C++ library dependencies (TODO: use conda only)
    │   ├── conda                                      # conda dependencies
    │   │   ├── condabuild.yaml                        # conda build dependencies
    │   │   ├── condadev.yaml                          # conda development dependencies
    │   │   ├── recipe-lib                             # TODO: lib package recipe (dynamic libs only)
    │   │   ├── recipe-dev                             # TODO: dev package recipe (includes, static libs, dependes on lib package)
    │   │   └── recipe-python                          # TODO: python bindings recipe (dependes on lib package)
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
    │   └── test                                       # unit and integration tests to test the project functionality.
    │       ├── CMakeLists.txt
    │       ├── core                                   # core module unit tests go here.
    │       │   ├── CMakeLists.txt
    │       │   └── test_core.cpp                      # Catch2 unit tests for module
    │       └── test_{{cookiecutter.project_slug}}.cpp # project main test suite, catch2 main class
    ├── LICENSE
    ├── pre-commit                                     # git hook, performs required checks to commit. (TODO: needs to be fixed.)
    ├── python                                         # python project
    │   ├── {{cookiecutter.project_slug}}              # python source code goes here.
    │   ├── setup.py                                   # python package setup file, using scikit-build with the project CMakeFiles.txt.
    │   └── tests                                      # python tests go here. (TODO: TBD if it is module based ...)
    │       └── test_{{cookiecutter.project_slug}}.py  # python unit test.
    └── README.rst
    

CMake Project
=============

Project Options
---------------

+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| cmake project option                            | scope   | description                                         | defaults |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| BUILD_STATIC                                    | project | enable build of static libs for all project modules | OFF      |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| BUILD_PYTHON_PYBIND11                           | project | enable build of pybind11 python bindings            | OFF      |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| BUILD_PYTHON_SWIG                               | project | enable build of pybind11 python bindings            | OFF      |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| BUILD_DOC                                       | project | enable build of html docs                           | OFF      |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| BUILD_TESTS                                     | project | enable build of project tests                       | ON       |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| ENABLE_TEST_COVERAGE                            | project | enable coverage reports when executing tests        | ON       |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| ENABLE_${MODULE_NAME}_PYTHON_MODULE_STATIC_LINK | module  | enable linking the python bindings with the static  | ON       |
|                                                 |         | lib of the module. For this option to work properly,|          |
|                                                 |         | the module must me self contained, in some cases    |          |
|                                                 |         | this might break functionality, such as static      |          |
|                                                 |         | funtions on other modules...                        |          |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+

1.
2. 

Module Options
--------------

Output
------

There are some instalation requirements that need to be addressed, namely locating libraries for linking.

There are several possible instalation use-cases:

1. c++ only development (?)
2. linux system (using cmake GNUInstallDirs)
3. windows system (?)
4. conda cross
5. python bdist
6. python development mode (``python setup.py install development``)


Conda Packages
~~~~~~~~~~~~~~

Conda packages produced by the project.

+-----------------------+-------------------------------+------------------------------------------------------------+--------------------------------+
| package name          | description                   | files                                                      | package dependencies           |
+=======================+===============================+============================================================+================================+
| <project_name>-lib    | shared libraries              | lib/<project_name>/lib<module1>.so.<major>.<minor>.<patch> | 3rd party libs                 |
+                       +                               +------------------------------------------------------------+                                +
|                       |                               | lib/<project_name>/lib<module1>.so.<major>.<minor>.<patch> |                                |
+                       +                               +------------------------------------------------------------+                                +
|                       |                               | lib/<project_name>/lib<module2>.so.<major>.<minor>.<patch> | from conda forge               |
+                       +                               +------------------------------------------------------------+                                +
|                       |                               | ...                                                        |                                |
+-----------------------+-------------------------------+------------------------------------------------------------+--------------------------------+
| <project_name>-dev    | development, cmake targets,   | lib/<project_name>/lib<module1>.a                          | <project_name>-lib             |
+                       +                               +------------------------------------------------------------+                                +
|                       | include files and static libs | lib/<project_name>/lib<module2>.a                          |                                |
+                       +                               +------------------------------------------------------------+                                +
|                       |                               | ...                                                        |                                |
+                       +                               +------------------------------------------------------------+                                +
|                       |                               | lib/cmake/<project_name>/<project_name>Targets.cmake       |                                |
+                       +                               +------------------------------------------------------------+                                +
|                       |                               | lib/cmake/<project_name>/<project_name>Config.cmake        |                                |
+                       +                               +------------------------------------------------------------+                                +
|                       |                               | include/<project_name>/                                    |                                |
+-----------------------+-------------------------------+------------------------------------------------------------+--------------------------------+
| <project_name>-python | C++ python bindings           | <project_name>/<module1>.<python-sufix>.so                 | <project_name>-lib             |
+                       +                               +------------------------------------------------------------+                                +
|                       | (pybind11 or/and swig)        | <project_name>/<module2>.<python-sufix>.so                 | or none, if static compiled    |
+                       +                               +------------------------------------------------------------+                                +
|                       |                               | ...                                                        | TODO: check nuitka subpackages |
+                       +                               +------------------------------------------------------------+                                +
|                       |                               | swig generated python files ...                            |                                |
+                       +                               +------------------------------------------------------------+                                +
|                       |                               | <project_name>/pyinstaller/<project_name>.spec (TODO:)     |                                |
+                       +                               +------------------------------------------------------------+                                +
|                       |                               | <project_name>/pyinstaller/hooks (TODO:)                   |                                |
+-----------------------+-------------------------------+------------------------------------------------------------+--------------------------------+

Development
~~~~~~~~~~~

TODO: Need to define a structure for build in linux dues to the RPATH, in windows dunno yet.


opencv from pypi has the following structure:

https://files.pythonhosted.org/packages/37/49/874d119948a5a084a7ebe98308214098ef3471d76ab74200f9800efeef15/opencv_python-4.0.0.21-cp36-cp36m-manylinux1_x86_64.whl

* cv2/.lib/ - .so files
* cv2/data/ - data files
* cv2/cv2.cpython-36m-x86_64-linux-gnu.so # single so file. (might require multi package)

torch from pypi
https://files.pythonhosted.org/packages/31/ca/dd2c64f8ab5e7985c4af6e62da933849293906edcdb70dac679c93477733/torch-1.0.1.post2-cp36-cp36m-manylinux1_x86_64.whl

* torch/lib - .so files
* torch/lib/include - c and cuda header files (.cuh)
* torch/_C.cpython-36m-x86_64-linux-gnu.so - C++ bindings, link with packaged libs


General checks for the build.

1. prevent **in source build tree**, allow for the execution of tests and checks.

Requirements
````````````

Set of requirements to support TDD development cycle.


1. C++ tests

  1.1. execute all tests, exporting gcov (coverage) results.

  1.2. execute and filter tests based on tags, such:

    1.2.1. ``[perf]``  - performance related tests ?
    
    1.2.2. ``[mem]``   - memory memory related tests ?
    
    1.2.3. ``[func1]`` - functionality 1 ...

  1.3. execute tests under valgrind, to check for memory issues.

2. test python integration

  2.1 execute tests under valgrind, to check for memory issues.
  
  2.1 execute performance tests, with time outputs.
  


Additional Checks
`````````````````

These checks, are available unde one target, and are to be executed in pre commit conditions or in the CI,
not necessary in TDD fast development cycle.

1. Memory checks - valgrind
2. clang-tidy
3. clang-format


References
==========

* swig_
* pybind11_
* `pyinstaller specs`_

.. _`pyinstaller specs`: https://pythonhosted.org/PyInstaller/spec-files.html