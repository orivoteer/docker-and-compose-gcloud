# Our base image will be Alpine 3.9 as provided by the cloud-sdk image
FROM google/cloud-sdk:alpine AS base

# Docker
FROM docker:latest AS docker
LABEL image=docker

# Docker Compose
#FROM docker/compose:1.24.0 AS compose
#LABEL image=compose
#FROM docker AS compose
#LABEL image=compose
#ARG compose_version=1.24.0

FROM base AS final
COPY --from=docker   /usr/local/bin/docker-entrypoint.sh     /usr/local/bin/docker-entrypoint.sh
COPY --from=docker   /usr/local/bin/docker           /usr/local/bin/docker
# COPY --from=compose  /usr/local/bin/docker-compose   /usr/local/bin/docker-compose

ARG compose_version=1.24.0

# Install docker-compose (extra complicated since the base image uses alpine as base)
RUN apk update && apk add --no-cache \
       curl openssl ca-certificates \
    && apk del libc6-compat \
    && curl -L https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk \
    && apk add --no-cache glibc-2.23-r3.apk && rm glibc-2.23-r3.apk \
    && ln -s /lib/libz.so.1 /usr/glibc-compat/lib/ \
    && ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib


ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]


