A build container with docker and docker-compose, built on Alpine 3.9 with Google Cloud SDK

Can be used for docker-in-docker in GitLab like this:

```
  image: sbrendtro/docker-and-compose-gcloud:latest
  services:
    - docker:dind
```

