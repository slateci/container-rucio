#!/bin/bash -e

cp /tmp/rucio-host-pems/hostcert.pem /etc/grid-security/
chmod 644 /etc/grid-security/hostcert.pem
chown root:root /etc/grid-security/hostcert.pem
cp /tmp/rucio-host-pems/hostkey.pem /etc/grid-security/
chmod 400 /etc/grid-security/hostkey.pem
chown root:root /etc/grid-security/hostkey.pem
cp /tmp/rucio-configs/ca.crt /etc/grid-security/certificates/docker-entrypoint_ca.crt
cp /tmp/rucio-configs/rucio.cfg /opt/rucio/etc/rucio.cfg
rm /etc/httpd/conf.d/*
cp /tmp/rucio-configs/rucio.conf /etc/httpd/conf.d/rucio.conf
if [[ ! -z "${SETUP_DATA}" ]]; then
   curl -o /opt/rucio/etc/alembic.ini -l "https://raw.githubusercontent.com/rucio/rucio/master/etc/docker/demo/alembic.ini"
   curl -o setup_data.py -l "https://raw.githubusercontent.com/rucio/rucio/master/etc/docker/demo/setup_data.py"
   python setup_data.py
fi
supervisord -c /etc/supervisord.d/rucio.ini 
httpd
