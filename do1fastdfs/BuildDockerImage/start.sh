#!/bin/sh
FASTDFS_DATA=/data/fastdfs

# mkdir -p ${FASTDFS_DATA}/storage/data ${FASTDFS_DATA}/tracker;
# ln -s ${FASTDFS_DATA}/storage/data/ ${FASTDFS_DATA}/storage/data/M00;

# 启动fastdfs：
/etc/init.d/fdfs_trackerd start;
/etc/init.d/fdfs_storaged start;
nginx -g "daemon off;"

# /usr/local/nginx/sbin/nginx;
# tail -f /usr/local/nginx/logs/access.log