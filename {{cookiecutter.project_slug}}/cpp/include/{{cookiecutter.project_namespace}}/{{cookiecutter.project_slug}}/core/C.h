/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#ifndef {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_C_H
#define {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_C_H

#include <string>
#include "{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}/core/A.h"
#include "{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}/core/B.h"

namespace {{cookiecutter.project_namespace}} {
namespace {{cookiecutter.project_slug}} {
namespace core {

    class C {
        bool m_booly;

    public:
        // constructors
        C();
        C(bool booly);

        // copy constructor
        C(const C& other);

        // copy assignment operator
        C& operator=(const C& other);

        // destructor
        ~C();

        // getter
        const bool get_booly() const;

        // overloaded functions
        std::string overloadMethod(A a);
        std::string overloadMethod(B b);
        std::string overloadMethod(A a, B b);
        std::string overloadMethod(A a, C c);
    };

} // namespace core
} // namespace {{cookiecutter.project_slug}}
} // namespace {{cookiecutter.project_namespace}}

#endif // {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_C_H
