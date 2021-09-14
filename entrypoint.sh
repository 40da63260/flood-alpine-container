#!/bin/sh
cd /home/flood/
chown -R flood /rundir
doas -u flood /home/flood/node_modules/.bin/flood --rthost rtorrent --rtport 5000  --host 0.0.0.0 --allowedpath /downloads --allowedpath /rundir -d /rundir
