/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#include "{{cookiecutter.project_slug}}/core/B.h"

namespace {{cookiecutter.project_slug}} {
namespace core {

// constructors
B::B() {
}

B::B(int number) : m_number(number) {
}

// copy constructor
B::B(const B& other) : m_number(other.m_number) {
}

// copy assignment operator
B& B::operator=(const B& other) {
    if(this != &other)
    {
        m_number = other.m_number;
    }

    return *this;
}

// destructor
B::~B() {
}

// getter
const int B::get_number() const
{
    return m_number;
}

} // namespace core
} // namespace {{cookiecutter.project_slug}}
