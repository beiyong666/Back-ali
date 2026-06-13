FROM xhofe/alist:latest

WORKDIR /opt/alist

EXPOSE 5244

CMD sh -c '\
./alist server \
--db-type="${ALIST_DB_TYPE:-postgres}" \
--db-host="${ALIST_DB_HOST}" \
--db-port="${ALIST_DB_PORT:-5432}" \
--db-user="${ALIST_DB_USER}" \
--db-pass="${ALIST_DB_PASS}" \
--db-name="${ALIST_DB_NAME}"'
