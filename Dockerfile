FROM xhofe/alist:latest
WORKDIR /opt/alist
USER root

# 设置容器启动时默认的数据目录
VOLUME /opt/alist/data

EXPOSE 5244

# 用最简单、最纯粹的方式启动，绝对不抢拍子
CMD ["./alist", "server"]
