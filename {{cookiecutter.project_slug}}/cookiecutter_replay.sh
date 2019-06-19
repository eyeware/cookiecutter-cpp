#!/bin/bash

tmpfile=$(mktemp /tmp/XXXXXX-cookiecutter-config.yaml)

cat <<EOF >$tmpfile
replay_dir: "$(pwd)/rock/.cookiecutter_replay/"
EOF

rm -rf cookiecutter_updated_template
mkdir cookiecutter_updated_template

cd cookiecutter_updated_template

cookiecutter --config-file $tmpfile --replay gh:practicalci/cookiecutter-cpp

rm $tmpfile
