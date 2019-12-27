1. docker build:

cd BuildDockerImage
docker build -t do1fastdfs .

2. docker run:

先准备好用到的各个配置文件，配置文件例子见fdfs_conf文件夹
mod_fastdfs.conf
tracker.conf
storage.conf
client.conf
nginx.conf


准备文件夹：
mkdir -p /data/fastdfs/storage /data/fastdfs/tracker `pwd`/html

然后按照下面运行镜像：

docker run -d \
  --network host \
  -v `pwd`/mod_fastdfs.conf:/etc/fdfs/mod_fastdfs.conf \
  -v `pwd`/nginx.conf:/usr/local/nginx/conf/nginx.conf \
  -v `pwd`/storage.conf:/etc/fdfs/storage.conf \
  -v `pwd`/tracker.conf:/etc/fdfs/tracker.conf \
  -v `pwd`/client.conf:/etc/fdfs/client.conf \
  -v `pwd`/html:/usr/local/nginx/html \
  -v /data/fastdfs/storage:/data/fastdfs/storage \
  -v /data/fastdfs/tracker:/data/fastdfs/tracker \
  --name do1fastdfs \
  do1fastdfs

删除镜像：
docker rm -f do1fastdfs
