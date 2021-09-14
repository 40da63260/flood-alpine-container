#!/bin/bash
build0=$(buildah from alpine:3)
build1=$(buildah from alpine:3)
mounter0=$(buildah mount $build0)
mounter1=$(buildah mount $build1)
buildah run "$build0" sh -c 'apk add --no-cache -q --update mediainfo npm doas&&\
  adduser -S -u 87 flood &&\
  echo "permit nopass root" >> /etc/doas.conf &&\
  cd /home/flood/ && \
  doas -u flood npm install flood --silent --production &&\
  rm -vrf /home/flood/*.json'
buildah run "$build1" sh -c 'apk add --no-cache -q --update mediainfo nodejs doas &&\
  mkdir -p /rundir &&\
  adduser -S -u 87 flood &&\
  echo "permit nopass root" >> /etc/doas.conf &&\
  cd /home/flood/ &&\
  apk del apk-tools -q --no-cache'
cp -r "$mounter0"/home/flood/* "$mounter1"/home/flood/
buildah copy "$build1" entrypoint.sh /entrypoint.sh
buildah config --entrypoint "/entrypoint.sh" "$build1"
buildah unmount "$mounter0"
buildah unmount "$mounter1"
buildah rm "$build0"
buildah commit  --rm "$build1" floodalpinecontainer
