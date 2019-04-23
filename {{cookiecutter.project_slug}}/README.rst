{{ '=' * cookiecutter.project_name | length }}
{{ cookiecutter.project_name }}
{{ '=' * cookiecutter.project_name | length }}

{{ cookiecutter.description }}


Summary
=======

{{ cookiecutter.long_description }}

This project is a template from ``gh:practicalci/cookiecutter-cpp`` cookiecutter.
For improvements and changes, please contact the cookiecutter author.

.. sectnum::
.. contents:: Table of Contents


Setup Project Environment
=========================

.. _conda : https://conda.io/en/latest/
.. _conda-forge : https://conda-forge.org/

To setup the project you will require conda_ package manager, and other native 
tools that are not available in _conda-forge packages.


Local Docker Development
========================

::

    ./provision/linux/docker/build_docker.sh
    ./dockcross bash

Linux
-----

For ubuntu 16.04, please use the script in the `provision` directory. To add
additional tools to the project, check the scripts in `provision/linux/packages`
you will find files in the format `<distro>-<release>.sh` (ubuntu-16.04.sh)
add there specific `apt-get install commands`.

If you consider using another linux distro/release, please create a script
following the convention `<distro>-<release>.sh` to add specific native
packages.

::

    sudo ./provision/linux/provision.sh



Windows
-------

.. _chocolatey : https://chocolatey.org/docs/installation

For windows, please install chocolatey_ and use the command below.

TODO: many of the check tools might not be available for windows.

::

    choco install miniconda3 --params="'/AddToPath:1'"


Cross Platform Environment and Dependencies (miniconda_)
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
|                                                 |         | the module must be self contained, in some cases    |          |
|                                                 |         | this might break functionality, such as static      |          |
|                                                 |         | functions on other modules...                       |          |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| INSTALL_FOR_PYPI                                | project | Install libraries and python bindings inside the    | OFF      |
|                                                 |         | python package.                                     |          |
|                                                 |         | NOTE: this option changes install structure and     |          |
|                                                 |         | disables some project targets, (docs, tests, ...).  |          |
|                                                 |         | It is used to build standalone python wheels with   |          |
|                                                 |         | setup.py                                            |          |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| CMAKE_INSTALL_PREFIX                            | project | project installation prefix                         |          |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| ENABLE_CXX_COVERAGE_GCOVR_HTML_REPORTS          | project | Generate gcovr_ html reports for test coverage      | ON       |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| ENABLE_CXX_COVERAGE_GCOVR_COBERTURA_XML_REPORTS | project | Generate gcovr_ cobertura xml reports for test      | OFF      |
|                                                 |         | coverage.                                           |          |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| ENABLE_CXX_COVERAGE_LCOV_HTML_REPORTS           | project | Generate lcov_ html reports for test coverage       | (TODO)   |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+
| ENABLE_CXX_COVERAGE_LCOV_COBERTURA_XML_REPORTS  | project | Generate lcov_ cobertura xml reports for test       | (TODO)   |
|                                                 |         | coverage.                                           |          |
+-------------------------------------------------+---------+-----------------------------------------------------+----------+




CMake Project Components
------------------------

1. libs - install shared libraries only
2. dev  - install includes, cmake targets and docs
3. python - install python bindings


To install the components separately we need to first build the project and then
invoke cmake in the following way:


Note: please check this `install cmake components (1)`_, `install cmake components (2)`_

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

This project can be separated logically into several components and installed in several ways:

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

The project uses two build systems one for C++ (CMake_) and another for python a
C++ python integration scikit-build_, based on python distutils_, which
integrates with CMake_.


C++ - Build
-----------

To build the C++ with only project with CMake follow the following steps.

Use cmake option `-DCMAKE_BUILD_TYPE=Debug` when in development to enable test
coverage target.

Use cmake option `-DCMAKE_BUILD_TYPE=Release` when in prodution mode or to get
maximum acurrate performance results.

::

    # go to a directory in the same level of the project root "{{cookiecutter.project_slug}}/"

    mkdir build
    cd build
    cmake ../{{cookiecutter.project_slug}}/ -G Ninja -DCMAKE_BUILD_TYPE=Debug

    # build the project
    cmake --build . --target all


Python & C++ Build
------------------

To build the python project follow the following steps.

::

    # go to a directory in the same level of the project root "{{cookiecutter.project_slug}}/"

    python setup.py build


Python & C++ passing arguments to cmake
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For some specific reason, you may want to build the cmake extensions with
some specific options that are not set in the `setup.py` script. To do that
please use: `python setup.py build -- -DSOME_FEATURE:BOOL=OFF`


For more details, see `scikit-build command line`_.


Python & C++ develop mode
~~~~~~~~~~~~~~~~~~~~~~~~~

Python packaging tools (distutils_, setuptools_) have a *special* installation
mode, provinding means for python scripts to import the package, but it does
not copy the python files into the installation directory, instead creates a
link, allowing the developer to edit the source code in its original location.
This feature is usefull for TDD, while editing code and testing, allowing for
the test tools and scripts for import the code under development in a seamless
way.

See also `Python & C++ - install`_.

To *install* in develop mode use the following command:

::

    # go to project root directory
    cd {{cookiecutter.project_slug}}
    python setup.py develop

Test
====

C++ Test
--------

C++ tests are implemented using the Catch2_ header only library. Catch2 provides
some features for testing, namely tests are defined with labels in order to
provide means to execute only specific tests. The tests are compiled into an
executable that is executed with command line options to provide more control
regarding which tests to execute, and which format the test result sould be
outputed in order to integrate with reporting tools. For more details refer to
`Catch2 command line`_.

Catch2 provides some CMake_ modules to integrate with ctest_ (see also 
`ctest (1)`_), the cmake test tool. ctest executes as a frontend, running the
Catch2 executables. ctest has means to filter tests to excute, selecting their
label from a given regex.

TODO: https://github.com/practicalci/cookiecutter-cpp/issues/8


First build the project. See `C++ - Build`_.

Move to project ``build`` directory and issue the following commands depending on your use case.

Follows a useful set of commands for the develop->test cycle.

1. List all tests
2. List all lables
3. List tests and labels
4. Execute all tests
5. Execute specific tests
6. Execute only failed tests.
7. Execute tests with code coverage


C++ - List all tests
~~~~~~~~~~~~~~~~~~~~

::

    cd build
    ctest -N

C++ - List all lables
~~~~~~~~~~~~~~~~~~~~~

::

    cd build
    ctest --print-labels


C++ - List tests and labels
~~~~~~~~~~~~~~~~~~~~~~~~~~~


::

    cd build
    cmake --build . --target list_tests


C++ - Execute all tests
~~~~~~~~~~~~~~~~~~~~~~~

Using ctest_:


::

    cd build
    ctest

Using cmake build target:

::

    cd build
    cmake --build . --target test

C++ - Execute specific tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For more details please check ctest_ options (-L, -LE, -R, -RE), and others.

C++ - Filter test by name
`````````````````````````

::

    cd build
    ctest -R <regex>

C++ - Filter test by label
``````````````````````````

::

    cd build
    ctest -L <regex>

C++ - Execute only failed tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    cd build
    ctest --rerun-failed


C++ - Execute tests with code coverage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to execute tests under test coverage, the project must be build in
`Debug` mode, see `C++ - Build`_.

::

    cd build
    cmake --build . --target coverage

Open the file `./coverage/index.html` with your browser to see the coverage
report. The report is generated inside the `build` directory.


Python & C++
------------

Python tests are implemented using `Python unittest`_ test framework, also take
a look at `Python unittest mock`_, for integration tests. This project suggests
using pytest_ for executing tasks related to the TDD cycle.

Check `pytest command line`_ for more usage details.

To check test coverage we use pytest-cov_.

TODO: check pytest-xdist_ for parallel test execution and other extensions to pytest.

Unit tests, are organized by unittest.TestCase, that group fixtures (test
functions), test cases can also be grouped into unittest.TestSuite classes, to
know a bit more about test structures follow the links above.

Refer to `Python & C++ Build`_, and if developing use `Python & C++ develop mode`_.

Move to the project root directory where the `setup.py` is located.

Follows a useful set of commands for the develop->test cycle.

1. List all test fixtures
2. Execute all tests
3. Execute specific tests
4. Execute only failed tests
5. Execute tests with code coverage
6. Execute tests for CI


Python - List all tests
~~~~~~~~~~~~~~~~~~~~~~~

A list of test fixtures_ (functions) will be printed.


Using pytest
````````````
::

    pytest --setup-plan

Command output:

::

    collected 2 items

    tests/python/test_rock.py
          SETUP    C _UnitTestCase__pytest_class_setup
            tests/python/test_rock.py::TestRock::test_000_something (fixtures used: _UnitTestCase__pytest_class_setup)
          TEARDOWN C _UnitTestCase__pytest_class_setup
    tests/python/core/test_core.py
          SETUP    C _UnitTestCase__pytest_class_setup
            tests/python/core/test_core.py::TestCore::test_000_something (fixtures used: _UnitTestCase__pytest_class_setup)
          TEARDOWN C _UnitTestCase__pytest_class_setup

Python - Execute all tests
~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    pytest


Python - Execute specific tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

All fixtures in a test case:

::

    pytest tests/python/core/test_core.py::TestCore

A specific fixture:

::

    pytest tests/python/test_rock.py::TestRock::test_000_something


Python - Execute only failed tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    pytest --lf


Python - Execute tests with code coverage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    pytest --cov


Python - Execute tests for CI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Executing tests with junit output. There are other available options to be set in
the setup.cfg file, please refer to pytest_ and `pytest junit`_.

::

    pytest --junit-xml=<report output path>

Install
=======

C++ - install
-------------

TODO:

Python & C++ - install
----------------------

TODO:


C++ - Static Code Checks
========================

General checks for the build.

TODO: https://blog.kitware.com/static-checks-with-cmake-cdash-iwyu-clang-tidy-lwyu-cpplint-and-cppcheck/


1. prevent **in source build tree**, allow for the execution of tests and checks.

Linux
-----

Code Style
~~~~~~~~~~

clang-format

* target *check-format*     - checks the formating of C++ modified source files before commit.
* target *check-all-format* - checks the formating of C++ all source files.
* target *format*           - reformat C++ modified source files before commit.
* target *format-all*       - reformat C++ all source files.

clang-tidy

TODO: add target.

.. _readability-identifier-naming : https://clang.llvm.org/extra/clang-tidy/checks/readability-identifier-naming.html

* naming checks
https://clang.llvm.org/extra/clang-tidy/checks/readability-identifier-naming.html

The naming conventions used by the project for C++. To modify refer to
.clang-tidy in the project root and to readability-identifier-naming_.

.. code-block:: cpp

.. include:: format_example.cpp


::

    cd build
    cmake --build . --target <target-name>


Windows
-------


C++ - Dynamic Code Checks
=========================


Code Coverage
-------------

cobertura xml format is the "standard" way to report code coverage.

.. _gcovr : https://gcovr.com/
.. _lcov : http://ltp.sourceforge.net/coverage/lcov.php

* gcovr_ - supports cobertura xml reports.
* lcov_ - older than gcovr, with different features. (does not support cobertura xml reports) TODO:
* lcov-to-cobertura-xml - https://github.com/eriwen/lcov-to-cobertura-xml - https://pypi.org/project/lcov_cobertura/


Linux
-----

Windows
-------


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

TODO: pre-commit, currently broken

These checks are available under one target, and are to be executed in
pre-commit conditions or in the CI, not necessary in TDD fast development cycle.

1. Memory checks - valgrind
2. clang-tidy
3. clang-format


Code Checks
-----------

- **formating** - clang-format - `LLVM Code Style`_
- **lint** - TODO: clang linter or cpplint
- **test code coverage** - TODO: underway lcov gcov
- **test reports** - TODO:


CMake File Checks
-----------------

cmakelint - pypi https://github.com/richq/cmake-lint - https://pypi.org/project/cmakelint/
clang-format - https://github.com/cheshirekow/cmake_format - https://pypi.org/project/cmake_format/

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

Known Issues
============

.. _`scikit-build gihub issue #363` : https://github.com/scikit-build/scikit-build/issues/363
.. _`cmake export targets issue #18935` : https://gitlab.kitware.com/cmake/cmake/issues/18935

* `python setup.py develop` does not work with subpackages (same as `pip install -e .`) - `scikit-build gihub issue #363`_
* Exporting shared library that depends on object library fails - `cmake export targets issue #18935`_

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

* `Anaconda Package Repository`_
* `Catch2 command line`_
* Catch2_
* CMake_
* `ctest (1)`_
* ctest_
* distutils_
* fixtures_
* `install cmake components (1)`_
* `install cmake components (2)`_
* `LLVM Code Style`_
* miniconda_
* `opencv from pypi`_
* pybind11_
* `pyinstaller specs`_
* `pytest command line`_
* pytest-cov_
* pytest_
* `pytest junit`_
* pytest-xdist_
* `Python unittest`_
* `Python unittest mock`_
* `scikit-build command line`_
* scikit-build_
* setuptools_
* swig_
* `torch from pypi`_
* `Wheel vs Egg`_

.. _`Anaconda Package Repository`: https://anaconda.org/anaconda/repo
.. _`Catch2 command line` : https://github.com/catchorg/Catch2/blob/master/docs/command-line.md
.. _Catch2 : https://github.com/catchorg/Catch2
.. _CMake : https://cmake.org/documentation/
.. _`ctest (1)`: https://gitlab.kitware.com/cmake/community/wikis/doc/ctest/Testing-With-CTest
.. _ctest : https://cmake.org/cmake/help/latest/manual/ctest.1.html
.. _distutils : https://docs.python.org/3.6/distutils/setupscript.html
.. _fixtures : http://pythontesting.net/framework/unittest/unittest-fixtures/
.. _`install cmake components (1)`: https://stackoverflow.com/a/9192877
.. _`install cmake components (2)`: https://stackoverflow.com/a/21853784
.. _`LLVM Code Style`: https://llvm.org/docs/CodingStandards.html
.. _miniconda: https://conda.io/miniconda.html
.. _`Multi Machine Vagrant File`: https://www.vagrantup.com/docs/multi-machine/
.. _`opencv from pypi` : https://files.pythonhosted.org/packages/37/49/874d119948a5a084a7ebe98308214098ef3471d76ab74200f9800efeef15/opencv_python-4.0.0.21-cp36-cp36m-manylinux1_x86_64.whl
.. _pybind11: https://pybind11.readthedocs.io/en/stable/
.. _`pyinstaller specs` : https://pythonhosted.org/PyInstaller/spec-files.html
.. _`pytest command line` : https://docs.pytest.org/en/latest/usage.html
.. _pytest-cov : https://pytest-cov.readthedocs.io/en/latest/
.. _pytest : https://docs.pytest.org/en/latest/contents.html
.. _`pytest junit` : https://docs.pytest.org/en/latest/usage.html#creating-junitxml-format-files
.. _pytest-xdist : https://pypi.org/project/pytest-xdist/
.. _`Python unittest` : https://docs.python.org/3.6/library/unittest.html
.. _`Python unittest mock` : https://docs.python.org/3.6/library/unittest.mock.html
.. _`scikit-build command line` : https://scikit-build.readthedocs.io/en/latest/usage.html#command-line-options
.. _scikit-build : https://scikit-build.readthedocs.io/en/latest/
.. _setuptools : https://setuptools.readthedocs.io/en/latest/
.. _swig: http://www.swig.org/
.. _`torch from pypi` : https://files.pythonhosted.org/packages/31/ca/dd2c64f8ab5e7985c4af6e62da933849293906edcdb70dac679c93477733/torch-1.0.1.post2-cp36-cp36m-manylinux1_x86_64.whl
.. _Vagrant: https://www.vagrantup.com
.. _`Wheel vs Egg` : https://packaging.python.org/discussions/wheel-vs-egg/
