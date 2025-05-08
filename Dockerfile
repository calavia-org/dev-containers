FROM mcr.microsoft.com/devcontainers/base:alpine

# Install python/pip to use pre-commit 
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache py3-pip nodejs npm \
    && pip install --root-user-action ignore --no-cache --upgrade --break-system-packages pip setuptools pre-commit \
    && npm install -g semantic-release
