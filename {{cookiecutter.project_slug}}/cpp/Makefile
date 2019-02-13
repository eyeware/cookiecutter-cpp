all: configure ## Build all targets
	@ cmake --build build --target all

doc: configure ## Build the documentation (Doxygen)
	@ make doc -C build

test: configure ## Build all targets and run the test suite
	@ cmake --build build --target {{ cookiecutter.project_slug }}_test
	@ cmake --build build --target test 

install: all ## Build and install all targets
	@ cmake --build build --target install

configure: build ## Configure the targets (CMake)
	@ cd build && cmake -DCMAKE_BUILD_TYPE=Debug ..

install_env: ## Install conda development environment
	conda env create -f condadev.yaml

build: ## Create build directory
	@ mkdir -p $@

clean: ## Clean the build directory
	@ rm -rf build && mkdir build

format: ## Format all h,hpp,c,cpp,cxx files under version control inplace
	@ { git diff --name-only --diff-filter=ACMRT; \
	    git diff --name-only --diff-filter=ACRMT --cached; } | \
	  grep -E "\.(c|h|cpp|hpp|cxx)$$" | \
	  xargs -n1 clang-format -i

check-format: ## Check for formatting violations without fixing
	@ ! { git diff --name-only --diff-filter=ACMRT; \
	      git diff --name-only --diff-filter=ACMRT --cached; } | \
	    grep -E "\.(c|h|cpp|hpp|cxx)$$" | \
	    xargs -n1 clang-format -output-replacements-xml | \
	    grep "<replacement " > /dev/null

bump: ## Bump version
	@ bumpversion 


.PHONY: help

help: ## List all targets in the Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
