#!/bin/sh
build0=$(buildah from alpine:3)
build1=$(buildah from alpine:3)
mounter0=$(buildah mount "$build0")
mounter1=$(buildah mount "$build1")
buildah run "$build0" sh -c 'apk add --no-cache -q --update mediainfo \
   npm \
   doas&&\
  adduser -S -u 87 flood &&\
  echo "permit nopass root" >> /etc/doas.conf &&\
  cd /home/flood/ && \
  doas -u flood npm install flood --silent --production &&\
  rm -vrf /home/flood/*.json'
buildah run "$build1" sh -c 'apk add --no-cache -q --update mediainfo \
  nodejs &&\
  mkdir -p /rundir \
  /downloads &&\
  adduser -S -u 87 flood &&\
  chown -R flood /rundir &&
  cd /home/flood/ &&\
  apk del apk-tools -q --no-cache'
cp -r "$mounter0"/home/flood/node_modules "$mounter1"/home/flood/node_modules
buildah config --entrypoint '["/home/flood/node_modules/.bin/flood", "--rthost", "rtorrent", "--rtport", "5000", "--host", "0.0.0.0", "--allowedpath" ,"/downloads", "--allowedpath", "/rundir", "-d", "/rundir"]' \
  --workingdir /home/food \
  --user flood \
  --port 3000 \
  --volume /downloads \
  --volume /rundir "$build1"
buildah unmount "$mounter0"
buildah unmount "$mounter1"
buildah rm "$build0"
buildah commit  --rm "$build1" flood-alpine-container
