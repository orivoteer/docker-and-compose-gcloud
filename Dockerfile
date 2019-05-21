# A Python 3.7 / Alpine 3.9 base compiled against glibc
FROM frolvlad/alpine-miniconda3 AS base
LABEL image=base

# Docker
FROM docker:latest AS docker
LABEL image=docker

# Docker Compose is our base
FROM docker/compose:1.24.0 AS compose
LABEL image=compose


FROM base AS final
# Install Google Cloud SDK
ARG CLOUD_SDK_VERSION=246.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
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
COPY --from=docker   /usr/local/bin/docker                   /usr/local/bin/docker
COPY --from=compose  /usr/local/bin/docker-compose           /usr/local/bin/docker-compose

ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]


