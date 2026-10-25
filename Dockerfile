# Author: Satish Gaikwad <satish@satishweb.com>
# Node with bower and gulp, for the work on the front end.
FROM ubuntu:24.04
LABEL maintainer="Satish Gaikwad <satish@satishweb.com>"

ARG NODE_MAJOR=26
ARG BOWER_VERSION=1.8.14
ARG GULP_VERSION=5.0.1

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    NPM_CONFIG_PREFIX=/home/ubuntu/.npm-global \
    PATH=/home/ubuntu/.npm-global/bin:$PATH

# The packages of the image and the node from the repository of the project
# node. The versions of the programs are fixed, the image is the same with
# every build.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg \
    locales \
    && locale-gen en_US.UTF-8 \
    && curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install -g "bower@${BOWER_VERSION}" "gulp@${GULP_VERSION}" \
    && rm -rf /var/lib/apt/lists/*

# The programs of node are installed in the home of the user, so the user can
# add more of them.
RUN mkdir -p /home/ubuntu/.npm-global \
    && chown -R ubuntu:ubuntu /home/ubuntu

# The container runs with the user of the base image.
USER ubuntu
WORKDIR /home/ubuntu

COPY --chmod=0755 entrypoint.sh /opt/entrypoint.sh

# The entrypoint runs the command that is given to the container.
ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["/bin/bash"]
