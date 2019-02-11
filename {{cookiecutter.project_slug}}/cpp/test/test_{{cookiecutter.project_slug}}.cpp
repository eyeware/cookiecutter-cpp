#define CATCH_CONFIG_MAIN
#include "catch.hpp" 

TEST_CASE("{{ cookiecutter.project_slug | capitalize }}Test", "[all]") {
    REQUIRE( 1 == 1 );
}
