#include "catch2/catch.hpp"

#include "{{cookiecutter.project_namespace}}/{{ cookiecutter.project_slug }}/core/A.h"
#include "{{cookiecutter.project_namespace}}/{{ cookiecutter.project_slug }}/core/B.h"
#include "{{cookiecutter.project_namespace}}/{{ cookiecutter.project_slug }}/core/C.h"
#include "{{cookiecutter.project_namespace}}/{{ cookiecutter.project_slug }}/core/D.h"

  using namespace {{ cookiecutter.project_namespace }}::{{ cookiecutter.project_slug }}::core;

TEST_CASE("Hierarchy test", "[hierarchy]") {
  A a("I am son of A.");
  A d = D("I am son of D.");
  B b(12);

  REQUIRE(a.get_name() == "I am son of A.");
  REQUIRE(d.get_name() == "");
  REQUIRE(b.get_private() == 12);
}

// Another test, with two tags.
TEST_CASE("Some other test", "[types][performance]") { REQUIRE(1 == 1); }
