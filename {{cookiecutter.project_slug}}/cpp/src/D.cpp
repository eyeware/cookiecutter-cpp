/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#include "{{cookiecutter.project_slug}}/D.h"

// private include
#include "E.h"

namespace {{cookiecutter.project_slug}} {

// constructors
D::D() {
}

D::D(std::string name) : m_name(name) {
}

bool D::is_derived() {
    return true;
}

// getter
const std::string D::get_name() const
{
    return m_name;
}

const std::string D::process_private_class() const
{
  detail::E e("project_private_class");
  return e.get_class_name();
}

const std::string D::get_class_name() const
{
    return "class(D)";
}

} // namespace {{cookiecutter.project_slug}}
