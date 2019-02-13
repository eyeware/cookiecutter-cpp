/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#ifndef {{cookiecutter.project_slug | upper }}_D_H
#define {{cookiecutter.project_slug | upper }}_D_H

#include "{{cookiecutter.project_slug}}/A.h"

namespace {{cookiecutter.project_slug}} {

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

} // namespace {{cookiecutter.project_slug}}

#endif // {{cookiecutter.project_slug | upper }}_D_H
