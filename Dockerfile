FROM centos:latest
COPY aliases-py27.conf /opt/rucio/etc/web/aliases-py27.conf
COPY daemon_supervisor.ini /etc/supervisord.d/rucio.ini
COPY docker-entrypoint.sh tmp/docker-entrypoint.sh
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install python-devel m2crypto pycrypto MySQL-python httpd mod_ssl mod_wsgi gridsite 
RUN rm -f /etc/httpd/conf.d/*
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python2.7 get-pip.py
RUN pip2.7 install --upgrade setuptools
RUN pip2.7 install rucio 
EXPOSE 443/tcp
LABEL version="0.1"
LABEL description="This Docker image from the Enrico Fermi Institute contains resources for a Rucio service."
ENTRYPOINT sh tmp/docker-entrypoint.sh
