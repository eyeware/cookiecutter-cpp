/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#ifndef {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_D_H
#define {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_D_H

#include "{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}/core/A.h"

namespace {
{ cookiecutter.project_namespace }
}
{
  namespace {
  { cookiecutter.project_slug }
  }
  {
    namespace core {

    class D : public A {
      std::string m_name;

    public:
      // constructors
      D();
      D(std::string name);

      // getter, extended from base class
      const std::string get_name() const;

      bool is_derived();

      const std::string get_class_name() const;

      const std::string process_private_class() const;
    };

    } // namespace core
  }   // namespace {{cookiecutter.project_slug}}
} // namespace {{cookiecutter.project_namespace}}

#endif // {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_D_H
