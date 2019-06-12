/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#include <pybind11/operators.h>
#include <pybind11/pybind11.h>
namespace py = pybind11;

#include <{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}/common.h>

/** 
 * Defining root package for the project.
 * 
 * Submodules should use the pattern:
 * 
 * namespace py = pybind11;
 * extern py::module <parent_module>;
 * 
 * py::module core_module =
 *   {{cookiecutter.project_slug}}_module.def_submodule("config_devices");
 *   core_module.doc() = "Python bindings of config_devices";
 * 
 * All other modules will be added via #include, eacho module definitions will be 
 * defined in their specific folder/module.
 */ 
PYBIND11_MODULE({{cookiecutter.project_slug}}, {{cookiecutter.project_slug}}_module) {
    module.doc() = "C++ python bindings generated with pybind11";

    using namespace {{cookiecutter.project_namespace}}::{{cookiecutter.project_slug}};

    py::class_<CommonType>({{cookiecutter.project_slug}}_module, "CommonType")
        // constructors
        .def(py::init<>())
        // copy constructor
        .def(py::init<CommonType const &>())
        // public data member
        .def_readwrite("value", &CommonType::value)
        .def_readwrite("precise_value", &CommonType::precise_value);

    // non-member functions
    {{cookiecutter.project_slug}}_module.def("create_common_type", &create_common_type);

    PYBIND11_SUBMODULE({{cookiecutter.project_slug}}_module, submodule_name) {
        #include "core/core_python_bindings.h"
    }

}
