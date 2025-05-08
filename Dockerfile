FROM mcr.microsoft.com/devcontainers/base:alpine

# Install python/pip to use pre-commit 
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 py3-pip \
    && pip install --no-cache --upgrade --break-system-packages pip setuptools pre-commit
