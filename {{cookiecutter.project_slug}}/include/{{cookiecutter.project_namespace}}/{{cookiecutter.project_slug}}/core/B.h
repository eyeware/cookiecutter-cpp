/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#ifndef {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_B_H
#define {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_B_H

namespace {
{ cookiecutter.project_namespace }
}
{
  namespace {
  { cookiecutter.project_slug }
  }
  {
    namespace core {

    class B {
      int m_private;

    public:
      // constructors
      B();
      B(int number);

      // copy constructor
      B(const B &other);

      // copy assignment operator
      B &operator=(const B &other);

      // destructor
      ~B();

      // getter
      const int get_private() const;

      // public data member
      int m_public;
    };

    } // namespace core
  }   // namespace {{cookiecutter.project_slug}}
} // namespace {{cookiecutter.project_namespace}}

#endif // {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_B_H
