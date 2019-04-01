set -exuo pipefail

# goto to project root
cd .. 

docker run --rm practicalci/linux-anvil:cpp-python-dev > dockcross
chmod +x dockcross

BUILD_DIR=build

mkdir -p $BUILD_DIR

cat << EOF > $BUILD_DIR/build_script.sh
#!/bin/bash
set -exuo pipefail

cd build

# extend conda base environment
conda install --yes --quiet --file ../conda/requirements_dev.txt

cmake .. -G Ninja -DBUILD_PYTHON_PYBIND11=OFF -DCMAKE_BUILD_TYPE=Debug

cmake --build . --target all
cmake --build . --target test_junit_report
cmake --build . --target coverage_gcovr_cobertura_xml
cmake --build . --target coverage_gcovr_html

# leave this one for last
cmake --build . --target format-check-all
cmake --build . --target clang-tidy-junit-report 

EOF

chmod +x $BUILD_DIR/build_script.sh

# ls -la ..

./dockcross $BUILD_DIR/build_script.sh
