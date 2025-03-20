#!/bin/sh

mkdir -p /etc/v10-mvp-api/
SAMPLE_VERSION=$(curl -s https://api.github.com/repos/drival-ai/v10-mvp-api/releases/latest | jq -r ".tag_name")
cd /tmp/ && wget https://github.com/drival-ai/v10-mvp-api/releases/download/$SAMPLE_VERSION/v10-mvp-api-$SAMPLE_VERSION-x86_64-linux.tar.gz
tar xvzf v10-mvp-api-$SAMPLE_VERSION-x86_64-linux.tar.gz
cp -v bin/v10-mvp-api /usr/local/bin/v10-mvp-api
chown root:root /usr/local/bin/v10-mvp-api
cp -v bin/setup-systemd.sh /etc/v10-mvp-api/
cp -v bin/update-systemd.sh /etc/v10-mvp-api/
chmod +x /etc/v10-mvp-api/update-systemd.sh

cat >/usr/lib/systemd/system/v10mvpapi.service <<EOL
[Unit]
Description=V10 MVP API

[Service]
Type=simple
Restart=always
RestartSec=10
ExecStart=/usr/local/bin/v10-mvp-api -logtostderr

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl enable v10mvpapi
systemctl start v10mvpapi
systemctl status v10mvpapi

rm -rfv bin/
rm v10-mvp-api-$SAMPLE_VERSION-x86_64-linux.tar.gz
