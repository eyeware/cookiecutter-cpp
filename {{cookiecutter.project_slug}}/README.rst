{{ '=' * cookiecutter.project_name | length }}
{{ cookiecutter.project_name }}
{{ '=' * cookiecutter.project_name | length }}

{{ cookiecutter.description }}


Summary
=======

{{ cookiecutter.long_description }}

This project is a template from ``gh:practicalci/cookiecutter-cpp`` cookiecutter.
For improvements and changes, please contact the coockiecuter author.

.. sectnum::
.. contents:: Table of Contents


Setup Project Environment
=========================

Boot Native Environments
------------------------

To boostrap the native development environment execute the script ``scripts\provision.sh -c <conda user>``.
For native machines, use ``scripts\provision.sh -c root``.
For vagrant vms, use ``scripts\provision.sh -c vagrant``


- <conda user> : Miniconda user, that will have permissions to add remove packages of the root environment.


Boot Virtualized Environments (Vagrant)
---------------------------------------

This project, is prepared to bootstrap a contained linux environment using
Vagrant_ and `Multi Machine Vagrant File`_, and different flavours meant for
interactive development. To initialize one of such environments, choose your
linux flavour and execute one of the commands below.

+------------------+-----------------------------+--------------------------+
| Operating System | Vagrant Command             | Description              |
+==================+=============================+==========================+
| ubuntu-16.04     | ``vagrant up ubuntu-16.04`` | ubuntu server ~450M      |
+------------------+-----------------------------+--------------------------+
| alpine64         | ``vagrant up alpine64``     | low footprint image ~50M |
+------------------+-----------------------------+--------------------------+

Add Operating System Dependencies
---------------------------------

To add packages to the development environment, edit the respective
(``ubuntu.sh``, ``alpine.sh``, ...) script under the folder ``scripts`` folder.


Linux:
~~~~~~
TODO:

Windows:
~~~~~~~~

TODO:

Cross Platform Environment and Dependencies (Miniconda_)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Add to ``conda_env.yaml`` conda packages that are required for the build
environment or library dependencies. You need to have conda installed in your
development environment. (see TODO: add link here)

code::

 make install_env
 conda activate {{ cookiecutter.project_slug }}


Cross Platform C/C++ Environment and Dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



Project Structure
=================

.. comment
   dir tree generated with `tree -v --dirsfirst \{\{cookiecutter.project_slug\}\}/` and modified.

::

    {{cookiecutter.project_slug}}/                      # Project root.
    ├── attributions                                    # author attribution for derived work, and 3rd party licenses.
    ├── cmake
    ├── conda                                           # conda related TODO:
    │   ├── recipe-dev                                  # C++ dev (docs, static libs, includes, cmake targets) package
    │   ├── recipe-lib                                  # C++ lib (shared) package
    │   ├── recipe-python                               # python bindings package depends on libs TODO:?
    │   └── condaenv.yaml                               # dependencies for development environment
    ├── doc                                             # docs folder, used to generate code documentation - dev package
    ├── include
    │   └── {{cookiecutter.project_namespace}}
    │       └── {{cookiecutter.project_slug}}           # project public API, (other projects will include from here.)
    │           ├── core                                # example module, public module includes
    │           │   ├── A.h
    │           │  ...
    │           │   └── D.h
    │           └── README.rst
    ├── src                                             # sources go here, using maven like structure src/<lang>/...
    │   ├── cpp                                         # C++ source code folder
    │   │   └── core
    │   │       ├── CMakeLists.txt
    │   │       ├── A.cpp
    │   │      ...
    │   │       ├── E.cpp
    │   │       ├── E.h
    │   │       └── core_python_bindings.cpp            # ${MODULE_NAME}_python_bindings.cpp, pybind11 bindings
    │   └── python
    │       └── {{cookiecutter.project_namespace}}
    │           └── {{cookiecutter.project_slug}}
    ├── tests                                           # unit and integration tests to test the project functionality.
    │   ├── cpp                                         # C++ tests
    │   │   ├── core
    │   │   │   ├── CMakeLists.txt
    │   │   │   └── test_core.cpp                       # Catch2 unit tests for module
    │   │   └── test_{{cookiecutter.project_slug}}.cpp  # project main test suite, catch2 main class
    │   └── python                                      # Python tests
    │       ├── core
    │       │   ├── __init__.py
    │       │   └── test_core.py                        # Python unit tests for module
    │       ├── __init__.py
    │       └── test_{{cookiecutter.project_slug}}.py
    ├── CMakeLists.txt                                  # CMake defining project configurations and targets
    ├── LICENSE
    ├── Makefile
    ├── README.rst
    ├── pre-commit                                      # git hook, performs checks before to commit. (TODO: needs to be fixed.)
    └── setup.py                                        # python setup file, uses scikit-build integration with CMakeFiles.txt.

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
| BUILD_PYTHON_SWIG                               | project | enable build of swig python bindings                | OFF      |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| BUILD_DOC                                       | project | enable build of html docs                           | OFF      |
|                                                 |         | active if(NOT INSTALL_FOR_PYPI)                     |          |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| BUILD_TESTS                                     | project | enable build of project tests                       | ON       |
|                                                 |         | active if(NOT INSTALL_FOR_PYPI)                     |          |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| ENABLE_TEST_COVERAGE                            | project | enable coverage reports when executing tests        | ON(TODO:)|
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| ENABLE_${MODULE_NAME}_PYTHON_MODULE_STATIC_LINK | module  | enable linking the python bindings with the static  | OFF      |
|                                                 |         | lib of the module. For this option to work properly,|          |
|                                                 |         | the module must me self contained, in some cases    |          |
|                                                 |         | this might break functionality, such as static      |          |
|                                                 |         | funtions on other modules...                        |          |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| INSTALL_FOR_PYPI                                | project | Install libraries and python bindings inside the    | OFF      |
|                                                 |         | python package.                                     |          |
|                                                 |         | NOTE: this option changes install structure and     |          |
|                                                 |         | disables some project targets, (docs, tests, ...).  |          |
|                                                 |         | It is used to build standalone python wheels with   |          |
|                                                 |         | setup.py                                            |          |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| CMAKE_INSTALL_PREFIX                            | project | project instalation prefix                          |          |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+



CMake Project Components
------------------------

1. libs - install shared libraries only
2. dev  - install includes, cmake targets and docs
3. python - install python bindings


To install the components separetly we need to first build the project and then
invoke cmake in the following way:


Note: please check this `install cmake components (1)`_, `install cmake components (2)`_

.. _`install cmake components (1)`: https://stackoverflow.com/questions/9190098/for-cmakes-install-command-what-can-the-component-argument-do
.. _`install cmake components (2)`: https://stackoverflow.com/questions/21852817/cmake-how-to-create-alias-for-installing-different-targets/21853784#21853784


::

    add_custom_target(install-<component>
        DEPENDS <list of targes>
        COMMAND 
        "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=<component>
        -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
    )

In the command line, e.g.

::

    cmake .. -DCOMPONENT=dev -DCMAKE_INSTALL_PREFIX=`pwd`/install -P ./cmake_install.cmake


Output - CMake Project Install
------------------------------

This project can be broken and installed in several ways:

Linux (system install) packages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    1. C++ Library only (shared libs)
    2. C++ Development (includes, cmake targets, and docs)
    3. Python (python bindings)

Conda Packages
~~~~~~~~~~~~~~

    1. C++ Library only (shared libs) - {{cookiecutter.project_namespace + '-' + cookiecutter.project_slug}}-lib
    2. C++ Development (includes, cmake targets, and docs) - {{cookiecutter.project_namespace + '-' + cookiecutter.project_slug}}-dev
    3. Python (python bindings + python source files) - {{cookiecutter.project_namespace + '-' + cookiecutter.project_slug}}-python


Package Files
`````````````

::

    package name             description      files                                                       package dependencies

    {{cookiecutter.project_namespace + '-' + cookiecutter.project_slug}}-lib shared libs
    └── lib
        └── {{cookiecutter.project_namespace}}
            └── {{cookiecutter.project_slug}}
                ├── libcore.so.{{cookiecutter.version}}
                ├── ...
                └── lib<module k>.so?

    {{cookiecutter.project_namespace + '-' + cookiecutter.project_slug}}-dev development package
    ├── lib
    │   ├── {{cookiecutter.project_namespace}}
    │   │   └── {{cookiecutter.project_slug}}
    │   │       ├── libcore.a
    │   │       ├── ...
    │   │       └── lib<module k>.a?
    │   └── cmake
    │       └── {{cookiecutter.project_namespace}}
    │           └── {{cookiecutter.project_slug}}
    │               ├──{{cookiecutter.project_slug}}Targets.cmake
    │               └──{{cookiecutter.project_slug}}Config.cmake
    └── include
        └── {{cookiecutter.project_namespace}}
            └── {{cookiecutter.project_slug}}

    {{cookiecutter.project_namespace + '-' + cookiecutter.project_slug}}-python Python package + C++ python bindings
    └── python<ver>
        └── (dist|site)-packages
            └── {{cookiecutter.project_namespace}}
                └── {{cookiecutter.project_slug}}
                    ├── core.<python-sufix>.so          TODO: check nuitka subpackages for multipackage extension modules
                    ├── ...
                    ├── <module k>.<python-sufix>.so
                    └── pyinstaller
                        ├── pyinstaller.spec (TODO)
                        └── hooks (TODO)


Python packages
~~~~~~~~~~~~~~~

    1. Python wheel package, check `Wheel vs Egg`_ and `scikit-build` cmake integration.


Some examples of packages with native libs from pipy.

`opencv from pypi`_


* cv2/.lib/ - .so files
* cv2/data/ - data files
* cv2/cv2.cpython-36m-x86_64-linux-gnu.so # single so file. (might require multi package)

`torch from pypi`_


* torch/lib - .so files
* torch/lib/include - c and cuda header files (.cuh)
* torch/_C.cpython-36m-x86_64-linux-gnu.so - C++ bindings, link with packaged libs


TDD Development Cycle
=====================


TDD Flow Diagram::

              +------------------------------------------+
              |                                          |
  +-----------v-----------+                              |
  |                       |                              |
  | 1. New Feature        |                              |
  |                       |                              |
  +-----------+-----------+                              |
              |                                          |
  +-----------v-----------+                              |
  |                       |                              |
  | 2. Write Failing Test |                              |
  |                       |                              |
  +-----------+-----------+                              |
              |                                          |
  +-----------v-----------+                              |
  |                       |                              |
  |   3. Implement Code   +---------------+              |
  |                       |               |              |
  +-----------------------+    +----------v-----------+  |
                               |                      |  |
              +---------------->   4. Execute Test    |  |
              |                |                      |  |
  +-----------+-----------+    +----------+-----------+  |
  |                       |               |              |
  |     5. Fix Code/      |               |              |
  |       Refactor        |               |              |
  |                       |               |              |
  +-----------^-----------+               |              |
              |                 No        v       Yes    |
              +--------------------+ Test Passed? +------+


Build
=====

The project uses two build systems one for C++ (CMake_) and another for python a C++ python integration scikit-build_, based on python distutils_, which integrates with CMake_.


.. _scikit-build : https://scikit-build.readthedocs.io/en/latest/
.. _distutils : https://docs.python.org/3.6/distutils/setupscript.html
.. _CMake : https://cmake.org/documentation/


C++ Build
---------

To build the C++ with only project with CMake follow the following steps.

::

    # go to a directory in the same level of the project root "{{cookiecutter.project_slug}}/"
    
    mkdir build
    cd build
    cmake ../{{cookiecutter.project_slug}}/ -G Ninja -DCMAKE_BUILD_TYPE=Debug
    
    # build the project
    cmake --build . --target all


Python Build
------------


Test
====


C++ Test
--------



.. _`Catch2 command line` : https://github.com/catchorg/Catch2/blob/master/docs/command-line.md
.. _ctest : https://cmake.org/cmake/help/latest/manual/ctest.1.html
.. _`ctest (1)`: https://gitlab.kitware.com/cmake/community/wikis/doc/ctest/Testing-With-CTest

C++ tests are implemented using the Catch2_ header only library. Catch2 provides
some features for testing, namely tests are defined with labels in order to
provide means to execute only specific tests. The tests are compiled into an
executable that is executed with command line options to provide more controll
regarding which tests to execute, and which format the test result sould be
outputed in order to integrate with reporting tools. For more details refer to
`Catch2 command line`_.

Catch2 provides some CMake_ modules to integrate with ctest_ (see also 
`ctest (1)`_), the cmake test tool. ctest executes as a frontend, running the
Catch2 executables. ctest has means to filter tests to excute, selecting their
label from a given regex.

TODO: https://github.com/practicalci/cookiecutter-cpp/issues/8


First build the project. See `C++ Build`_.

Move to project ``build`` directory and issue the following commands depending on your use case.

Follows a usefull set of commands for the develop->test cycle.

1. List all tests
2. List all lables
3. List tests and labels
4. Execute all tests
5. Execute specific tests
6. Execute only failed tests.


C++ List all tests
~~~~~~~~~~~~~~~~~~

::

    cd build
    ctest -N

C++ List all lables
~~~~~~~~~~~~~~~~~~~

::

    cd build
    ctest --print-labels


C++ List tests and labels
~~~~~~~~~~~~~~~~~~~~~~~~~


::

    cd build
    cmake --build . --target list_tests


C++ Execute all tests
~~~~~~~~~~~~~~~~~~~~~~

Using ctest_:


::

    cd build
    ctest

Using cmake build target:

::

    cd build
    cmake --build . --target test

C++ Execute specific tests
~~~~~~~~~~~~~~~~~~~~~~~~~~

For more details please check ctest_ options (-L, -LE, -R, -RE), and others.

C++ Filter test by name
```````````````````````

::

    cd build
    ctest -R <regex>

C++ Filter test by label
````````````````````````

::

    cd build
    ctest -L <regex>

C++ Execute only failed tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    cd build
    ctest --rerun-failed


Python + C++
------------


Python
------

::

    python setup.py test # execute the project test suite




Build Checks
============



General checks for the build.

1. prevent **in source build tree**, allow for the execution of tests and checks.

Requirements
------------

TODO: Ongoing

Set of requirements to support TDD development cycle.


1. C++ tests

  1. execute all tests, exporting gcov (coverage) results.
  2. execute and filter tests based on tags, such:

    1. ``[perf]``  - performance related tests ?
    2. ``[mem]``   - memory memory related tests ?
    3. ``[func1]`` - functionality 1 ...

  3. execute tests under valgrind, to check for memory issues.

2. test python integration

  1. execute tests under valgrind, to check for memory issues.
  2. execute performance tests, with time outputs.


Additional Checks
-----------------

TODO: Ongoing


These checks, are available unde one target, and are to be executed in pre commit conditions or in the CI,
not necessary in TDD fast development cycle.

1. Memory checks - valgrind
2. clang-tidy
3. clang-format

.. _Catch2 : https://github.com/catchorg/Catch2
.. _`Python unittest` : https://docs.python.org/3.6/library/unittest.html
.. _swig: http://www.swig.org/
.. _pybind11: https://pybind11.readthedocs.io/en/stable/


Code Checks
-----------

- **formating** - `LLVM Code Style`_
- **lint** - TODO: clang linter or cpplint
- **test code coverage** - TODO: underway lcov gcov
- **test reports** - TODO: 


.. _`LLVM Code Style`: https://llvm.org/docs/CodingStandards.html


Publish Code
============

Before publishing code you should check the formatting and make sure all tests are passing.
There are pre-commit hooks for git installed in the git repository to enforce these topics locally.

Versioning
----------


This project uses the following versioning scheme ``<major>.<minor>.<patch>[-<release>]``. 
The release part identifies the development stage. Release part is one of {prod, alpha, beta}, being prod optional.

Example:

- ``1.0,0`` - Production
- ``1.0.0-alpha`` - Development, Ready for Quality Assurance Tests (QA). TODO: To Be Decided...


To increase the release version perform::

  bumpversion minor
  bumpversion major
  bumpversion patch
  bumpversion release

to reset the release, bump the patch part ??



Attributions
============


This work is derived from the work of:


+-------------------------------------------------+---------------------------------------------------+--------------------------------------------+-----------------------------------------------------+
| Author                                          | Work Source                                       | Files                                      | License                                             |
+=================================================+===================================================+============================================+=====================================================+
| `Hilton Bristow <https://github.com/hbristow>`_ | `<https://github.com/hbristow/cookiecutter-cpp>`_ | the base work of this template             | `<attributions/hbristow-bsd-3-clause-license.txt>`_ |
+-------------------------------------------------+---------------------------------------------------+--------------------------------------------+-----------------------------------------------------+
| `Lars Bilke <https://github.com/bilke>`_        | `<https://github.com/bilke/cmake-modules>`_       | `<cmake-modules/CodeCoverage.cmake>`_      | `<attributions/bilke-bsl-1.0-license.txt>`_         |
+-------------------------------------------------+---------------------------------------------------+--------------------------------------------+-----------------------------------------------------+


References
==========

.. _Miniconda: https://conda.io/miniconda.html
.. _`Anaconda Package Repository`: https://anaconda.org/anaconda/repo
.. _Conan: https://conan.io/
.. _`Conan Package Repository`: https://bintray.com/conan/conan-center
.. _Vagrant: https://www.vagrantup.com
.. _`Multi Machine Vagrant File`: https://www.vagrantup.com/docs/multi-machine/



* Catch2_
* `Python unittest`_
* swig_
* pybind11_
* `pyinstaller specs`_



.. _Catch2 : https://github.com/catchorg/Catch2
.. _`Python unittest` : https://docs.python.org/3.6/library/unittest.html
.. _`pyinstaller specs` : https://pythonhosted.org/PyInstaller/spec-files.html

.. _`Wheel vs Egg` : https://packaging.python.org/discussions/wheel-vs-egg/
.. _`scikit-build` : https://scikit-build.readthedocs.io/en/latest/

.. _`opencv from pypi` : https://files.pythonhosted.org/packages/37/49/874d119948a5a084a7ebe98308214098ef3471d76ab74200f9800efeef15/opencv_python-4.0.0.21-cp36-cp36m-manylinux1_x86_64.whl
.. _`torch from pypi` : https://files.pythonhosted.org/packages/31/ca/dd2c64f8ab5e7985c4af6e62da933849293906edcdb70dac679c93477733/torch-1.0.1.post2-cp36-cp36m-manylinux1_x86_64.whl
.. _swig: http://www.swig.org/
.. _pybind11: https://pybind11.readthedocs.io/en/stable/


1. Miniconda_
2. `Anaconda Package Repository`_
3. Conan_
4. `Conan Package Repository`_
5. Vagrant_
6. `Multi Machine Vagrant File`_
