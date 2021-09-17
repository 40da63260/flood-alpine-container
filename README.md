# flood-alpine-container

[Flood](https://github.com/jesec/flood) in an Alpine OCI Container

# What it is:

This a minimal image, to be deployed with podman

# How to run

`podman run --rm -p 3000:3000/tcp --name=flood -v $(pwd)/downloads:/downloads -v $(pwd)/config:/rundir --tz=local ghcr.io/40da63260/flood-alpine-container`

# Dockerfile vs. buildah

I made the Dockerfile as a kind of check, functionally should be equivalent to the buildah script.

# Docker support

I don't care if this runs on `docker`
