#!/bin/bash

tmpfile=$(mktemp /tmp/XXXXXX-cookiecutter-config.yaml)

cat <<EOF >$tmpfile
replay_dir: "$(pwd)/{{cookiecutter.project_slug}}/.cookiecutter_replay/"
EOF

mkdir cookiecutter_updated_template

cd cookiecutter_updated_template

cookiecutter --config-file $tmpfile --replay gh:practicalci/cookiecutter-cpp

rm $tmpfile
