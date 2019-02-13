/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#ifndef {{cookiecutter.project_slug | upper }}_C_H
#define {{cookiecutter.project_slug | upper }}_C_H

#include <string>
#include "{{cookiecutter.project_slug}}/A.h"
#include "{{cookiecutter.project_slug}}/B.h"

namespace {{cookiecutter.project_slug}} {

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

} // namespace {{cookiecutter.project_slug}}

#endif // {{cookiecutter.project_slug | upper }}_C_H
