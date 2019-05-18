FROM jonaskello/docker-and-compose:1.12.1-1.8.0

# For Docker builds disable host key checking. Be aware that by adding that
# you are suspectible to man-in-the-middle attacks.

# WARNING: Use this only with the Docker executor, if you use it with shell
# you will overwrite your user's SSH config.

RUN mkdir -p ~/.ssh && \
     [[ -f /.dockerenv ]] && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config

# Download and install Google Cloud SDK
RUN apk add --update make ca-certificates openssl python && \
     update-ca-certificates && \
     wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz && \
     tar zxvf google-cloud-sdk.tar.gz && ./google-cloud-sdk/install.sh --usage-reporting=false --path-update=true && \
     google-cloud-sdk/bin/gcloud --quiet components update

