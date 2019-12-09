FROM centos
RUN yum install wget gcc make bzip2 -y
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-5.0.7.tar.gz
ENV JEMALLOC_DOWNLOAD_URL https://github.com/jemalloc/jemalloc/releases/download/4.2.1/jemalloc-4.2.1.tar.bz2
WORKDIR /usr/local/
RUN set -eux; \
    wget "$JEMALLOC_DOWNLOAD_URL"; \
    tar xvf jemalloc-4.2.1.tar.bz2; \
    cd /usr/local/jemalloc-4.2.1; \
    ./configure && make;\
    cd /usr/local; \
    wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL";\
    tar -xzf redis.tar.gz; \
    cd /usr/local/redis-5.0.7; \
    make MALLOC=/usr/local/jemalloc-4.2.1/lib && make install; \
    rm -rf /usr/local/redis-5.0.7; \
COPY redis.conf /data/redis.conf
RUN mkdir /data
VOLUME /data
WORKDIR /data
EXPOSE 6379
CMD ["redis-server", "/data/redis.conf"]
#CMD ["/bin/bash"]
