/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#ifndef {{cookiecutter.project_slug | upper }}_B_H
#define {{cookiecutter.project_slug | upper }}_B_H

namespace {{cookiecutter.project_slug}} {
namespace core {

    class B {
          int m_number;

      public:
          // constructors
          B();
          B(int number);

          // copy constructor
          B(const B& other);

          // copy assignment operator
          B& operator=(const B& other);

          // destructor
          ~B();

          // getter
          const int get_number() const;
    };

} // namespace core
} // namespace {{cookiecutter.project_slug}}

#endif // {{cookiecutter.project_slug | upper }}_B_H

