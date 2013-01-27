#!/bin/sh

url=$1
diskname=$2
format=$3
container_format=$4

. /root/openrc

wget -c ${url} -O /var/spool/stackimages/${diskname}
glance add name=${diskname} disk_format=${format} container_format=${container_format} < /var/spool/stackimages/${diskname}


