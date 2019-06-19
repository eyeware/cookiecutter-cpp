/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#ifndef {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_A_H
#define {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_A_H

#include <memory>
#include <string>

#include <{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}/core/B.h>

namespace {{ cookiecutter.project_namespace }} {
namespace {{ cookiecutter.project_slug }} {
namespace core {

/**
 * @brief A class with private members and public functions.
 *
 * This class is written in C++11. Some of the functions of this class use
 * objects of type B.
 *
 * Optionally, Python bindings can be generated for this class, by using
 * tools like pybind11 or SWIG.
 *
 */
class A {
    std::string m_name; /**< name of the object */

  public:
    A();                 /**< default constructor with no arguments */
    A(std::string name); /**< constructor with name argument */

    A(const A &other); /**< copy constructor */

    A &operator=(const A &other); /**< copy assignment operator */

    virtual ~A(); /**< destructor */

    virtual const std::string get_name() const; /**< function to get the name of this object */

    void pass_by_value(B b);            /**< function that passes an object by value */
    void pass_by_reference(const B &b); /**< function that passes an object by reference-to-const */
    void pass_by_pointer(B *b);         /**< function that passes an object by pointer */
    B return_value();                   /**< function that returns an object */
    B &return_reference(B &b);          /**< function that returns the reference to an object */
    B *return_raw_pointer();            /**< function that returns a raw pointer to an object */
    std::shared_ptr<B>
    return_shared_pointer(); /**< function that returns a shared pointer to an object */
};

const std::string
get_name_of_other(const A &other); /**< non-member function to get the name of an A object */

} // namespace core
} // namespace {{cookiecutter.project_slug}}
} // namespace {{cookiecutter.project_namespace}}

#endif // {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_A_H
