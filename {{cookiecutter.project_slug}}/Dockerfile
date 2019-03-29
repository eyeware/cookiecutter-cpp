FROM practicalci/linux-anvil:cpp-python-dev

# this is required for dockcross script.
ARG IMAGE={{cookiecutter.project_namespace}}/{{cookiecutter.project_slug}}
ARG VERSION=latest
ENV DEFAULT_DOCKCROSS_IMAGE ${IMAGE}:${VERSION}

COPY conda/requirements_dev.txt /tmp/requirements_dev.txt

RUN /opt/docker/bin/run_conda.sh install --quiet --file /tmp/requirements_dev.txt && \ 
  rm -rf /tmp/requirements_dev.txt
