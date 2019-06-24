#!/bin/bash -e

cp /tmp/fts3-host-pems/hostcert.pem /etc/grid-security/
chmod 644 /etc/grid-security/hostcert.pem
chown root:root /etc/grid-security/hostcert.pem
cp /tmp/fts3-host-pems/hostkey.pem /etc/grid-security/
chmod 400 /etc/grid-security/hostkey.pem
chown root:root /etc/grid-security/hostkey.pem
cp /tmp/fts3-configs/ca.crt /etc/grid-security/certificates/docker-entrypoint_ca.crt
cp /tmp/fts3-configs/fts3config /etc/fts3/fts3config
cp /tmp/fts3-configs/fts-msg-monitoring.conf /etc/fts3/fts-msg-monitoring.conf
mkdir -p /var/lib/mysql/
mkdir -p /var/log/fts3rest/ && touch /var/log/fts3rest/fts3rest.log
chown fts3:fts3 /var/log/
chown fts3:fts3 /var/log/fts3rest/fts3rest.log
touch /var/lib/mysql/mysql.sock
if [[ ! -z "${SETUP_DATA}" ]]; then
   curl -o /opt/rucio/etc/alembic.ini -l "https://raw.githubusercontent.com/rucio/rucio/master/etc/docker/demo/alembic.ini"
   curl -o setup_data.py -l "https://raw.githubusercontent.com/rucio/rucio/master/etc/docker/demo/setup_data.py"
   python setup_data.py
fi
if [[ -z "${WEB_INTERFACE}" ]]; then
   rm /etc/httpd/conf.d/ftsmon.conf
fi
fetch-crl
fts_server
fts_bringonline
httpd
supervisord -c etc/supervisord.conf

