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

# create conda environment for python build and c++ build
conda env create --file ../conda/condaenv_dev.yaml

conda activate ${PROJECT_CONDA_ENV}

python setup.py bdist_wheel

EOF

chmod +x $BUILD_DIR/build_script.sh

# ls -la ..

./dockcross $BUILD_DIR/build_script.sh
