FROM mriedmann/baseimage:0.0.1
MAINTAINER Michael Riedmann <michael_riedmann@live.com>

# Phusion-Baseimage Startup
ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]

# Basic Ubuntu-Env
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8

# Update APT
RUN apt-get update

# Install Basics
RUN apt-get install wget -y

# Install dependencies
RUN apt-get install -y --no-install-recommends \
    python-geoip python-gevent \
    python-ldap python-lxml python-markupsafe python-pil python-pip \
    python-psutil python-psycopg2 python-pychart python-pydot \
    python-reportlab python-simplejson python-yaml wkhtmltopdf

# Add User
RUN adduser --system --group --home /var/lib/odoo --shell /bin/bash odoo
 
# Install Odoo
RUN wget -nv -O- https://github.com/odoo/odoo/archive/8.0.0.tar.gz \
  | tar xz --xform s,^odoo-8.0.0,odoo, -C /opt \
 && cd /opt/odoo \
 && pip install -e .

# Add Config
ADD openerp-server.conf /etc/openerp-server.conf
 
# Add service script
RUN mkdir /etc/service/odoo
ADD odoo-run.sh /etc/service/odoo/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Declare volumes
VOLUME ["/var/lib/odoo"]

# Expose HTTP port, and longpolling port
EXPOSE 8069 8072