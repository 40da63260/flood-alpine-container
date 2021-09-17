FROM alpine:3 as builder

RUN apk add --no-cache -q --update mediainfo \
  npm
RUN adduser -S -u 87 flood
USER flood
WORKDIR /home/flood
RUN npm install flood --silent --production


FROM alpine:3
RUN apk add --no-cache -q --update mediainfo \
  nodejs &&\
  apk del -q --no-cache apk-tools
RUN adduser -S -u 87 flood
RUN mkdir /rundir /downloads
RUN chown flood -R /rundir
USER flood
WORKDIR /home/flood
VOLUME /rundir, /downloads
COPY --from=builder /home/flood/node_modules /home/flood/node_modules
EXPOSE 3000/tcp
ENTRYPOINT ["/home/flood/node_modules/.bin/flood","--rthost","rtorrent","--rtport","5000","--host","0.0.0.0","--allowedpath","/downloads","--allowedpath","/rundir","-d","/rundir"]
