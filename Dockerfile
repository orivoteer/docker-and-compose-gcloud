# Docker
FROM docker:latest AS docker
LABEL image=docker

# Docker Compose
FROM docker/compose:1.24.0 AS compose
LABEL image=compose

# Final image, with docker entrypoint
FROM compose AS final
COPY --from=docker   /usr/local/bin/docker-entrypoint.sh     /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]


