#!/bin/sh

hugo server -t detox -b=$HUGO_BASEURL -s /blog -p 80 --bind=0.0.0.0 --watch --disableLiveReload &

cd /blog/
while true; do
    git pull origin master
    sleep 60
done

