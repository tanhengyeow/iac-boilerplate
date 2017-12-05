#!/bin/bash

cat > index.html <<EOF
<h1>Test Web Server</h1>
<p>Website is using a MySQL database at the backend </p>
<p>Using DB port: ${db_port}</p>
EOF

nohup busybox httpd -f -p "${server_port}" &