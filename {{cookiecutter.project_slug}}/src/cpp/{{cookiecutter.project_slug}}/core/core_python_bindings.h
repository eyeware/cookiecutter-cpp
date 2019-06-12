/*
 * Copybind11right (C) 2019 Eyeware Tech SA
 *
 */

#include <pybind11bind11/operators.h>
#include <pybind11bind11/pybind11bind11.h>

#include <{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}/core/A.h>
#include <{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}/core/B.h>
#include <{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}/core/C.h>
#include <{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}/core/D.h>

// not defined here, its defined in the its specific module.cpp

// Define submodule, using parent module
pybind11::module core_module =
    parent_core_module.def_submodule("config_devices");
    core_module.doc() = "pybind11thon bindings of config_devices";

core_module.doc() = "C++ pybind11thon bindings generated with pybind11bind11";

using namespace {{ cookiecutter.project_namespace }}::{{ cookiecutter.project_slug }}::core;

pybind11::class_<A>(core_module, "A")
    // constructors
    .def(pybind11::init<>())
    .def(pybind11::init<std::string>())
    // copybind11 constructor
    .def(pybind11::init<A const &>())
    // copybind11 assignment operator
    //        .def(pybind11::self = pybind11::self)
    // destructor?
    // getter
    .def("get_name", &A::get_name)
    // functions that use another class B
    .def("passByValue", &A::pass_by_value)
    .def("passByReference", &A::pass_by_reference)
    .def("passByPointer", &A::pass_by_pointer)
    .def("returnValue", &A::return_value)
    .def("returnReference", &A::return_reference)
    .def("returnRawPointer", &A::return_raw_pointer)
    .def("returnSharedPointer", &A::return_shared_pointer);

// non-member functions
core_module.def("get_name_of_other", &get_name_of_other);

pybind11::class_<B>(core_module, "B")
    // constructors
    .def(pybind11::init<>())
    .def(pybind11::init<int>())
    // copybind11 constructor
    .def(pybind11::init<B const &>())
    // copybind11 assignment operator
    //        .def(pybind11::self = pybind11::self)
    // destructor?
    // getter
    .def("get_private", &B::get_private)
    // for private data members with getters and setters, we can use:
    // .def_property("m_private", &B::set_private, &B::get_private)
    // public data member
    .def_readwrite("m_public", &B::m_public);

pybind11::class_<C>(core_module, "C")
    // constructors
    .def(pybind11::init<>())
    .def(pybind11::init<bool>())
    // copybind11 constructor
    .def(pybind11::init<C const &>())
    // copybind11 assignment operator
    //        .def(pybind11::self = pybind11::self)
    // destructor?
    // getter
    .def("get_booly", &C::get_booly)
    // overloaded functions
    // Note:
    // The syntax below is for C++11.
    // In C++14, the second argument can be written in a simpler way:
    // pybind11::overload_cast<arg>(&C::overloadMethod)
    // Examples:
    // pybind11::overload_cast<A>(&C::overloadMethod)
    // pybind11::overload_cast<B>(&C::overloadMethod)
    // pybind11::overload_cast<A,B>(&C::overloadMethod)
    // pybind11::overload_cast<A,C>(&C::overloadMethod)
    .def("overloadMethod", (std::string(C::*)(A)) & C::overload_method)
    .def("overloadMethod", (std::string(C::*)(B)) & C::overload_method)
    .def("overloadMethod", (std::string(C::*)(A, B)) & C::overload_method)
    .def("overloadMethod", (std::string(C::*)(A, C)) & C::overload_method);

pybind11::class_<D>(core_module, "D")
    // constructors
    .def(pybind11::init<>())
    .def(pybind11::init<std::string>())
    .def("get_name", &D::get_name)
    .def("is_derived", &D::is_derived);

//include submodules
// #include "submodule0/submodule0_pybind11thon_bindings.h"
