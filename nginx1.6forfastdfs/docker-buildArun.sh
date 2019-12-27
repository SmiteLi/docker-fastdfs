docker build -t do1fastdfs .

docker run -d \
  -v `pwd`/mod_fastdfs.conf:/etc/fdfs/mod_fastdfs.conf \
  -v `pwd`/nginx.conf:/usr/local/nginx/conf/nginx.conf \
  -v `pwd`/storage.conf:/etc/fdfs/storage.conf \
  -v `pwd`/tracker.conf:/etc/fdfs/tracker.conf \
  -v `pwd`/client.conf:/etc/fdfs/client.conf \
  -v `pwd`/html:/usr/local/nginx/html \
  -v /data/fastdfs/logs:/data/fastdfs/logs \
  -v /data/fastdfs:/data/fastdfs \
  --name do1nginx:1.16 \
  do1fastdfs