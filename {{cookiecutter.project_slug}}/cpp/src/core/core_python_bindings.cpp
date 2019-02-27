/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#include <pybind11/operators.h>
#include <pybind11/pybind11.h>
namespace py = pybind11;

#include "{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}/core/A.h"
#include "{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}/core/B.h"
#include "{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}/core/C.h"
#include "{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}/core/D.h"

// add submodules: https://github.com/pybind/python_example/issues/26
PYBIND11_MODULE(core, module)
{
    module.doc() = "C++ python bindings generated with pybind11";
    module.attr("__name__") = "mymodule.foo";

    using namespace {{cookiecutter.project_namespace}}::{{cookiecutter.project_slug}}::core;

    py::class_<A>(module, "A")
        // constructors
        .def(py::init<>())
        .def(py::init<std::string>())
        // copy constructor
        .def(py::init<A const&>())
        // copy assignment operator
//        .def(py::self = py::self)
        // destructor?
        // getter
        .def("get_name", &A::get_name)
        // functions that use another class B
        .def("passByValue", &A::passByValue)
        .def("passByReference", &A::passByReference)
        .def("passByPointer", &A::passByPointer)
        .def("returnValue", &A::returnValue)
        .def("returnReference", &A::returnReference)
        .def("returnRawPointer", &A::returnRawPointer)
        .def("returnSharedPointer", &A::returnSharedPointer);

    // non-member functions
    module.def("get_name_of_other", &get_name_of_other);

    py::class_<B>(module, "B")
        // constructors
        .def(py::init<>())
        .def(py::init<int>())
        // copy constructor
        .def(py::init<B const &>())
        // copy assignment operator
//        .def(py::self = py::self)
        // destructor?
        // getter
        .def("get_private", &B::get_private)
        // for private data members with getters and setters, we can use:
        // .def_property("m_private", &B::set_private, &B::get_private)
        // public data member
        .def_readwrite("m_public", &B::m_public);

    py::class_<C>(module, "C")
        // constructors
        .def(py::init<>())
        .def(py::init<bool>())
        // copy constructor
        .def(py::init<C const&>())
        // copy assignment operator
//        .def(py::self = py::self)
        // destructor?
        // getter
        .def("get_booly", &C::get_booly)
        // overloaded functions
        // Note:
        // The syntax below is for C++11.
        // In C++14, the second argument can be written in a simpler way:
        // py::overload_cast<arg>(&C::overloadMethod)
        // Examples:
        // py::overload_cast<A>(&C::overloadMethod)
        // py::overload_cast<B>(&C::overloadMethod)
        // py::overload_cast<A,B>(&C::overloadMethod)
        // py::overload_cast<A,C>(&C::overloadMethod)
        .def("overloadMethod", (std::string (C::*)(A)) &C::overloadMethod)
        .def("overloadMethod", (std::string (C::*)(B)) &C::overloadMethod)
        .def("overloadMethod", (std::string (C::*)(A,B)) &C::overloadMethod)
        .def("overloadMethod", (std::string (C::*)(A,C)) &C::overloadMethod);

    py::class_<D>(module, "D")
        // constructors
        .def(py::init<>())
        .def(py::init<std::string>())
        .def("get_name", &D::get_name)
        .def("is_derived", &D::is_derived);
}

