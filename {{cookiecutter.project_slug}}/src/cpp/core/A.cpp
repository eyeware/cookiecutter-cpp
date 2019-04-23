/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#include <string>

#include "{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}/core/A.h"

namespace {{ cookiecutter.project_namespace }} {
namespace {{ cookiecutter.project_slug }} {
namespace core {

// constructors
A::A() {}

A::A(std::string name) : m_name(name) {}

// copy constructor
A::A(const A &other) : m_name(other.m_name) {}

// copy assignment operator
A &A::operator=(const A &other) {
    if (this != &other) {
        m_name = other.m_name;
    }

    return *this;
}

// destructor
A::~A() {}

// getter
const std::string A::get_name() const { return m_name; }

// functions that use another class B
void A::pass_by_value(B b) {}

void A::pass_by_reference(const B &b) {}

void A::pass_by_pointer(B *b) {}

B A::return_value() { return B(); }

B &A::return_reference(B &b) { return b; }

B *A::return_raw_pointer() {
    B *raw_pointer_to_b = new B(); // allocate storage on the heap
    return raw_pointer_to_b;
}

std::shared_ptr<B> A::return_shared_pointer() { return std::make_shared<B>(); }

// non-member function to get the name of an A object
const std::string get_name_of_other(const A &other) { return other.get_name(); }

} // namespace core
} // namespace {{cookiecutter.project_slug}}
} // namespace {{cookiecutter.project_namespace}}
