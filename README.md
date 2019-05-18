Adds docker-compose to the [offcial docker image](https://hub.docker.com/_/docker/). 

This extends jonaskello/docker-and-compose by adding Google Cloud SDK on top, making it possible to interact with Google Cloud APIs from within the build container.

Can be used for docker-in-docker in GitLab like this:

```
  image: sbrendtro/docker-and-compose-gcloud:1.12.1-1.8.0
  services:
    - docker:1.12.1-dind
```

Each branch in this repo corresponds to a docker image in the format [docker-version]-[docker-compose-version].
