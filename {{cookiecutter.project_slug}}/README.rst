{{ '=' * cookiecutter.project_name | length }}
{{ cookiecutter.project_name }}
{{ '=' * cookiecutter.project_name | length }}

{{ cookiecutter.description }}

-------
Summary
-------

{{ cookiecutter.long_description }}

This project is a template from ``gh:practicalci/cookiecutter-cpp`` cookiecutter.
For improvements and changes, please contact the coockiecuter author.

.. sectnum::
.. contents:: Table of Contents

-------------------------
Setup Project Environment
-------------------------

Boot Native Environments
========================

To boostrap the native development environment execute the script ``scripts\provision.sh -c <conda user>``.
For native machines, use ``scripts\provision.sh -c root``. 
For vagrant vms, use ``scripts\provision.sh -c vagrant``


- <conda user> : Miniconda user, that will have permissions to add remove packages of the root environment.


Boot Virtualized Environments (Vagrant)
=======================================

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
=================================

To add packages to the development environment, edit the respective
(``ubuntu.sh``, ``alpine.sh``, ...) script under the folder ``scripts`` folder.



Linux:
------
TODO:

Windows:
--------

TODO:

Cross Platform Environment and Dependencies (Miniconda_)
--------------------------------------------------------

Add to ``conda_env.yaml`` conda packages that are required for the build
environment or library dependencies. You need to have conda installed in your
development environment. (see TODO: add link here)

code::

 make install_env
 conda activate {{ cookiecutter.project_slug }}


Cross Platform C/C++ Environment and Dependencies (Conan_)
----------------------------------------------------------

Add to ``conanfile.txt`` project dependencies, external or internal libraries
packaged with conan.

---------------------
TDD Development Cycle
---------------------

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



Publish Code
============

Before publishing code you should check the formatting and make sure all tests are passing.
There are pre-commit hooks for git installed in the git repository to enforce these topics locally.

Code Checks
-----------

- **formating** - `LLVM Code Style`_
- **lint** - TODO: clang linter or cpplint
- **test code coverage** - TODO: underway lcov gcov
- **test reports** - TODO: 


.. _`LLVM Code Style`: https://llvm.org/docs/CodingStandards.html


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


------------
Attributions
------------


This work is derived from the work of:


+-------------------------------------------------+---------------------------------------------------+--------------------------------------------+-----------------------------------------------------+
| Author                                          | Work Source                                       | Files                                      | License                                             |
+=================================================+===================================================+============================================+=====================================================+
| `Hilton Bristow <https://github.com/hbristow>`_ | `<https://github.com/hbristow/cookiecutter-cpp>`_ | the base work of this template             | `<attributions/hbristow-bsd-3-clause-license.txt>`_ |
+-------------------------------------------------+---------------------------------------------------+--------------------------------------------+-----------------------------------------------------+
| `Lars Bilke <https://github.com/bilke>`_        | `<https://github.com/bilke/cmake-modules>`_       | `<cmake-modules/CodeCoverage.cmake>`_      | `<attributions/bilke-bsl-1.0-license.txt>`_         |
+-------------------------------------------------+---------------------------------------------------+--------------------------------------------+-----------------------------------------------------+


----------
References
----------

.. _Miniconda: https://conda.io/miniconda.html
.. _`Anaconda Package Repository`: https://anaconda.org/anaconda/repo
.. _Conan: https://conan.io/
.. _`Conan Package Repository`: https://bintray.com/conan/conan-center
.. _Vagrant: https://www.vagrantup.com
.. _`Multi Machine Vagrant File`: https://www.vagrantup.com/docs/multi-machine/

1. Miniconda_
2. `Anaconda Package Repository`_
3. Conan_
4. `Conan Package Repository`_
5. Vagrant_
6. `Multi Machine Vagrant File`_
