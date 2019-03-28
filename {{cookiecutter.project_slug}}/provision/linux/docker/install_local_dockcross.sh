#!/bin/bash
DOCKERBASEIMAGE="{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}"

docker run --rm `docker images -q $DOCKERBASEIMAGE` > dockcross
chmod +x dockcross
