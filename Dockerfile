FROM xhofe/alist:latest
WORKDIR /opt/alist
USER root
EXPOSE 5244

CMD sh -c "\
    ./alist server & PID=\$!; \
    sleep 5; \
    echo '⏳ 正在启动 AList 服务...'; \
    i=0; while ! wget -q --spider http://127.0.0.1:5244/api/public/settings; do \
        sleep 2; i=\$((i+1)); \
        [ \$i -ge 15 ] && echo '❌ 服务启动超时' && kill \$PID && exit 1; \
    done; \
    \
    [ -z \"\$ALIST_ADMIN_PASSWORD\" ] && echo '❌ 未设置管理员初始密码环境变量' && exit 1; \
    \
    echo '🔑 正在尝试登录...'; \
    TOKEN=\$(wget -qO- --post-data=\"{\\\"username\\\":\\\"admin\\\",\\\"password\\\":\\\"\$ALIST_ADMIN_PASSWORD\\\"}\" \
          --header='Content-Type: application/json' http://127.0.0.1:5244/api/auth/login 2>/dev/null | grep -o '\"token\":\"[^\"]*\"' | cut -d'\"' -f4); \
    \
    if [ \${#TOKEN} -gt 20 ]; then \
        echo '🚀 AList 登录成功'; \
        for n in 1 2 3 4 5 6 7 8 9 10; do \
            BODY=\$(printenv STORAGE_JSON_\$n); \
            [ -n \"\$BODY\" ] || continue; \
            \
            echo \"\$BODY\" > /tmp/p.json; \
            if grep -q '\"mount_path\"' /tmp/p.json; then \
                printf \"📦 正在导入 AList 存储配置 \$n: \"; \
                wget -qO- --post-file=/tmp/p.json \
                     --header=\"Content-Type: application/json\" \
                     --header=\"Authorization: \$TOKEN\" \
                     http://127.0.0.1:5244/api/admin/storage/create 2>/dev/null | grep -o '\"message\":\"[^\"]*\"' || echo '完成'; \
            fi; \
            rm -f /tmp/p.json; \
        done; \
        echo '✅ AList 所有初始化自动挂载任务已完成！'; \
    else \
        echo '❌ 认证失败，请检查密码是否正确'; kill \$PID; exit 1; \
    fi; \
    wait \$PID"
