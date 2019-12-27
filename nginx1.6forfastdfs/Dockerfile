FROM mycentos:7

MAINTAINER lilong <497180156@qq.com>

ENV SRC_HOME /usr/local/src
ENV FASTDFS_DATA /data/fastdfs

ADD * ${SRC_HOME}/

# #安装准备
# RUN yum -y update \
#     && yum -y install git gcc gcc-c++ make automake autoconf libtool pcre pcre-devel zlib zlib-devel openssl openssl-devel wget vim

# #下载nginx1.16,fastdfs-nginx-module插件源码
# RUN cd ${SRC_HOME} \
#     && wget http://nginx.org/download/nginx-1.16.1.tar.gz \
#     && git clone https://github.com/happyfish100/fastdfs-nginx-module.git --depth 1
#     && git clone https://github.com/happyfish100/libfastcommon.git --depth 1 \
#     && git clone https://github.com/happyfish100/fastdfs.git --depth 1 \

RUN cd ${SRC_HOME} \
    && cd libfastcommon/ \
    && ./make.sh && ./make.sh install

RUN cd ${SRC_HOME} \
    && cd fastdfs/ \
    && ./make.sh && ./make.sh install \
    && cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf \
    && cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf \
    && cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf \
    && cp ${SRC_HOME}/fastdfs/conf/http.conf /etc/fdfs/ \
    && cp ${SRC_HOME}/fastdfs/conf/mime.types /etc/fdfs/ \
    && sed -i "s|/home/yuqing/fastdfs|${FASTDFS_DATA}/tracker|g" /etc/fdfs/tracker.conf \
    && sed -i "s|/home/yuqing/fastdfs|${FASTDFS_DATA}/storage|g" /etc/fdfs/storage.conf \
    && sed -i "s|/home/yuqing/fastdfs|${FASTDFS_DATA}/storage|g" /etc/fdfs/client.conf \
    && mkdir -p ${FASTDFS_DATA}/tracker ${FASTDFS_DATA}/storage

# 获取nginx源码
# /usr/local/nginx/html  --with-openssl=/usr/lib64/openssl\
# --with-http_ssl_module --with-openssl=/usr/lib 
RUN cd ${SRC_HOME} \
    && cd nginx-1.16.1/ \
    && ./configure --add-module=${SRC_HOME}/fastdfs-nginx-module/src/ --with-http_ssl_module --with-pcre --with-stream --with-stream_ssl_module --with-http_ssl_module --with-http_v2_module --with-threads \
    && make && make install \
    && ln -sf /usr/local/nginx/sbin/nginx /usr/bin/nginx \
    && chmod 755 ${SRC_HOME}/start.sh \
    && cp ${SRC_HOME}/start.sh /usr/local/nginx/sbin/

# 设置nginx和fastdfs联合环境，并配置nginx
# -v /etc/fdfs/mod_fastdfs.conf
RUN cp ${SRC_HOME}/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs \
    && sed -i "s|^store_path0.*$|store_path0=${FASTDFS_DATA}/storage|g" /etc/fdfs/mod_fastdfs.conf \
    && sed -i "s|^url_have_group_name =.*$|url_have_group_name = true|g" /etc/fdfs/mod_fastdfs.conf \
    && echo -e "\
    worker root;\n\
    events {\n\
    worker_connections  1024;\n\
    }\n\
    http {\n\
    include       mime.types;\n\
    default_type  application/octet-stream;\n\
    server {\n\
    listen 8888;\n\
    server_name localhost;\n\
    location ~ /group[0-9]/M00 {\n\
    ngx_fastdfs_module;\n\
    }\n\
    }\n\
    }">/usr/local/nginx/conf/nginx.conf

# 清理文件
RUN rm -rf ${SRC_HOME}/* \
    && yum remove -y gcc gcc-c++ make openssl-devel git wget vim

# 暴露端口。改为采用host网络，不需要单独暴露端口
EXPOSE 80 8888 22122 23000

CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT ["/bin/bash","-c","/usr/local/nginx/sbin/start.sh"]
