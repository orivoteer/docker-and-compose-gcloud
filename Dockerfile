# Docker
FROM docker:latest AS docker
LABEL image=docker

# Docker Compose
FROM docker/compose:1.24.0 AS compose
LABEL image=compose

# Final image, with docker entrypoint
FROM compose AS final
RUN apk add --update bash git curl openssl ca-certificates

ENV PATH $PATH:/google-cloud-sdk/bin

RUN apk add --update bash git curl openssl make ca-certificates python \
    && update-ca-certificates \
    && wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz \
    && tar zxvf google-cloud-sdk.tar.gz && ./google-cloud-sdk/install.sh --usage-reporting=false --path-update=true \
    && google-cloud-sdk/bin/gcloud --quiet components update

COPY --from=docker   /usr/local/bin/docker-entrypoint.sh     /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]


