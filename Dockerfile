# Docker
FROM docker:latest AS docker
LABEL image=docker

# Docker Compose is our base
FROM docker/compose:1.24.0 AS compose
ARG CLOUD_SDK_VERSION=246.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION

# Install docker-compose (extra complicated since the base image uses alpine as base)
RUN apk update && apk add --no-cache \
       curl openssl ca-certificates \
    && apk del libc6-compat \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk \
    && apk add --no-cache glibc-2.28-r0.apk && rm glibc-2.28-r0.apk 
#    && ln -s /lib/libz.so.1 /usr/glibc-compat/lib/ \
#    && ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib

ENV PATH /google-cloud-sdk/bin:$PATH

RUN apk --no-cache add \
        curl \
        python \
        py-crcmod \
        bash \
        openssh-client \
        git \
        gnupg \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version

VOLUME ["/root/.config"]
COPY --from=docker   /usr/local/bin/docker-entrypoint.sh     /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]


