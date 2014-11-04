#!/bin/bash
sudo -u odoo /opt/odoo/openerp-server \
 --config=/etc/openerp-server.conf \
 --database=$DB_NAME \
 --db_user=$DB_USER \
 --db_password=$DB_PASSWORD \
 --db_host=127.0.0.1 \
 --db_port=5432
 	