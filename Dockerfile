FROM xhofe/alist:latest
WORKDIR /opt/alist
USER root
EXPOSE 5244

CMD sh -c "\
    ./alist server --to-config-env & PID=\$!; \
    sleep 3; \
    if [ -n \"\$ALIST_ADMIN_PASSWORD\" ]; then \
        echo '🔑 检测到密码环境变量，正在设置初始密码...'; \
        ./alist admin set \"\$ALIST_ADMIN_PASSWORD\"; \
    fi; \
    echo '✅ AList 启动成功并已注入云端数据库！'; \
    wait \$PID"
