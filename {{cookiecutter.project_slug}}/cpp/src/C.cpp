/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#include "{{cookiecutter.project_slug}}/C.h"

using namespace {{cookiecutter.project_slug}};

// constructors
C::C() {
}

C::C(bool booly) : m_booly(booly) {
}

// copy constructor
C::C(const C& other) : m_booly(other.m_booly) {
}

// copy assignment operator
C& C::operator=(const C& other) {
    if(this != &other)
    {
        m_booly = other.m_booly;
    }

    return *this;
}

// destructor
C::~C() {
}

// getter
const bool C::get_booly() const
{
    return m_booly;
}

// overloaded functions
std::string C::overloadMethod(A a) {
    return "A";
}

std::string C::overloadMethod(B b) {
    return "B";
}

std::string C::overloadMethod(A a, B b) {
    return "A_B";
}

std::string C::overloadMethod(A a, C c) {
    return "A_C";
}
