FROM mcr.microsoft.com/devcontainers/base:debian

# Install python/pip to use pre-commit 
ENV PYTHONUNBUFFERED=1
RUN \
    apt-get update \
    && apt-get install -y \
    ca-certificates \
    curl python3-pip \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && pip install --no-cache --upgrade --break-system-packages pip setuptools pre-commit

# Install volta to manage node environments and install semantic-release
#USER vscode 
# bash will load volta() function via .bashrc 
# using $VOLTA_HOME/load.sh
# since we're starting non-interactive shell, 
# we wil need to tell bash to load .bashrc manually
#ENV BASH_ENV=~/.bashrc
# needed by volta() function
#ENV VOLTA_HOME=/home/vscode/.volta
# make sure packages managed by volta will be in PATH
#ENV PATH=$VOLTA_HOME/bin:$PATH

ENV BASH_ENV=~/.bashrc
ENV VOLTA_HOME=/root/.volta
ENV PATH=$VOLTA_HOME/bin:$PATH

RUN curl https://get.volta.sh | bash \
    && volta install node 
    # \
    # && npm install --save-dev semantic-release
    
RUN echo "hola"