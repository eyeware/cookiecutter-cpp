#include <catch2/catch.hpp>

// Another test, with two tags.
TEST_CASE("Some other test", "[types][performance]") { REQUIRE(1 == 1); }
