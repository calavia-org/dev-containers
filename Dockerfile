FROM mcr.microsoft.com/devcontainers/base:alpine

# Install python/pip to use pre-commit 
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 py3-pip \
    && pip install --no-cache --upgrade --break-system-packages pip setuptools pre-commit

# Install volta to manage node environments and install semantic-release 
# bash will load volta() function via .bashrc 
# using $VOLTA_HOME/load.sh
SHELL ["/bin/bash", "-c"]
# since we're starting non-interactive shell, 
# we wil need to tell bash to load .bashrc manually
ENV BASH_ENV=~/.bashrc
# needed by volta() function
ENV VOLTA_HOME=/root/.volta
# make sure packages managed by volta will be in PATH
ENV PATH=$VOLTA_HOME/bin:$PATH

RUN curl https://get.volta.sh | bash \
    && volta install node \
    && npm install --save-dev semantic-release
    
RUN echo "hola"