FROM xhofe/alist:latest
WORKDIR /opt/alist
USER root

EXPOSE 5244

# 彻底还原为官方纯净启动
CMD ["./alist", "server"]
