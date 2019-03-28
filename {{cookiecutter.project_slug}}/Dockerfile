FROM practicalci/linux-anvil:cpp-python-dev

# this is required for dockcross script.
ARG IMAGE={{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}
ARG VERSION=latest
ENV DEFAULT_DOCKCROSS_IMAGE ${IMAGE}:${VERSION}

COPY conda/condaenv_dev.yaml /tmp/condaenv_dev.yaml

RUN /opt/docker/bin/run_conda.sh env create --quiet --file /tmp/condaenv_dev.yaml && \ 
  rm -rf /tmp/condaenv_dev.yaml
