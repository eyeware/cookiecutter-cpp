/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#ifndef {{cookiecutter.project_slug | upper }}_A_H
#define {{cookiecutter.project_slug | upper }}_A_H

#include <memory>
#include <string>
#include "{{cookiecutter.project_slug}}/core/B.h"

namespace {{cookiecutter.project_slug}} {
namespace core {

    class A {
        std::string m_name;

    public:
        // constructors
        A();
        A(std::string name);

        // copy constructor
        A(const A& other);

        // copy assignment operator
        A& operator=(const A& other);

        // destructor
        virtual ~A();

        // getter
        virtual const std::string get_name() const;

        // functions that use another class B
        void passByValue(B b);
        void passByReference(const B& b);
        void passByPointer(B* b);
        B returnValue();
        B& returnReference(B& b);
        B* returnRawPointer();
        std::shared_ptr<B> returnSharedPointer();
    };

} // namespace core
} // namespace {{cookiecutter.project_slug}}

#endif // {{cookiecutter.project_slug | upper }}_A_H
