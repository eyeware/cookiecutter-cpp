#!/bin/bash
DOCKERBASEIMAGE="{{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}"
docker build -t $DOCKERBASEIMAGE -f Dockerfile --no-cache .
