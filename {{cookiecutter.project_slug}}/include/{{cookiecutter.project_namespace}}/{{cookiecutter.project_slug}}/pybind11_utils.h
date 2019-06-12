/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#ifndef {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_PYBIND11_UTILS_H
#define {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_PYBIND11_UTILS_H

#include <pybind11/pybind11.h>
/** 
 * This macro is defined to be used with this project and cmake template.
 * 
 * The convention is that one module that defines submodules will have the 
 * submodule in a subfolder, so it will perform a relative include.
 * 
 * Also the module and and the folder name are the same.
 * 
 * 
 */ 


// org_rock_rock_core_pybind11_init(pybind11::module& module);

#define PYBIND11_SUBMODULE(module, submodule)
    static void _{{cookiecutter.project_namespace | lower }}_{{cookiecutter.project_slug | lower }_#module)_pybind11_init()
    pybind11::module& PYBIND11_CONCAT(parent_, submodule) = module;

#define PYBIND11_SUBMODULE_INIT(module, submodule)
    static void {{cookiecutter.project_namespace | lower }}_{{cookiecutter.project_slug | lower }_pybind11_init()

#endif // {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_PYBIND11_UTILS_H

// org_rock_rock_core_pybind11_init(org_module);
