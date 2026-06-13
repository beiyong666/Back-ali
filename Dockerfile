FROM xhofe/alist:latest
WORKDIR /opt/alist
USER root
EXPOSE 5244

CMD sh -c "\
    ./alist server & PID=\$!; \
    sleep 3; \
    if [ -n \"\$ALIST_ADMIN_PASSWORD\" ]; then \
        echo '🔑 检测到密码环境变量，正在设置初始密码...'; \
        ./alist admin set \"\$ALIST_ADMIN_PASSWORD\"; \
    fi; \
    echo '✅ AList 启动成功！'; \
    wait \$PID"
