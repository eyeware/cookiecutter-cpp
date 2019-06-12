/*
 * Copyright (C) 2019 Eyeware Tech SA
 *
 */

#ifndef {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_COMMOM_H
#define {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_COMMOM_H

namespace {{ cookiecutter.project_namespace }} {
namespace {{ cookiecutter.project_slug }} {

    struct CommonType {
      int value;
      float precise_value;
    };

    CommonType create_common_type(int value, float precise_value);

} // namespace {{cookiecutter.project_slug}}
} // namespace {{cookiecutter.project_namespace}}

#endif // {{cookiecutter.project_namespace | upper }}_{{cookiecutter.project_slug | upper }}_COMMON_H
