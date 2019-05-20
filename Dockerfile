# Our base image will be Alpine 3.9 as provided by the cloud-sdk image
FROM google/cloud-sdk:alpine AS base

# Docker
FROM docker:latest AS docker
LABEL image=docker

# Docker Compose
FROM docker/compose:1.24.0 AS compose
LABEL image=compose

FROM base AS final
COPY --from=docker   /usr/local/bin/docker-entrypoint.sh     /usr/local/bin/docker-entrypoint.sh
COPY --from=docker   /usr/local/bin/docker           /usr/local/bin/docker
COPY --from=compose  /usr/local/bin/docker-compose   /usr/local/bin/docker-compose
ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]


