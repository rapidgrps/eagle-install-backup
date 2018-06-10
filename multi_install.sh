sudo apt-get update && apt-get -y upgrade
sudo apt-get install git wkhtmltopdf python-pip python-dev \
    python-virtualenv libevent-dev gcc libjpeg-dev libxml2-dev \
    libssl-dev libsasl2-dev node-less libldap2-dev libxslt-dev
apt install postgresql-9.5 postgresql-server-dev-9.5
systemctl enable postgresql.service
systemctl start postgresql.service
sudo adduser --system --group eagle70 --home /opt/eagle70
sudo adduser --system --group eagle71 --home /opt/eagle71
sudo adduser --system --group eagle72 --home /opt/eagle72
sudo adduser --system --group eagle73 --home /opt/eagle73

su - postgres -c "createuser --createdb --username postgres --no-createrole --no-superuser --no-password eagle70"
su - postgres -c "createuser --createdb --username postgres --no-createrole --no-superuser --no-password eagle71"
su - postgres -c "createuser --createdb --username postgres --no-createrole --no-superuser --no-password eagle72"
su - postgres -c "createuser --createdb --username postgres --no-createrole --no-superuser --no-password eagle73"

sudo su - eagle70 -s /bin/bash
# git clone https://www.github.com/odoo/odoo --depth 1 --branch 10.0 --single-branch /opt/odoo10
git clone https://github.com/ShaheenHossain/eagle-backup --depth 1 --branch 10.0 --single-branch /opt/eagle70
cd /opt/eagle70
virtualenv ./venv
source ./venv/bin/activate
pip install -r requirements.txt

exit

sudo su - eagle71 -s /bin/bash

git clone https://github.com/ShaheenHossain/eagle-backup --depth 1 --branch 10.0 --single-branch /opt/eagle71

cd /opt/eagle71
virtualenv ./venv
source ./venv/bin/activate
pip install -r requirements.txt

exit


sudo su - eagle72 -s /bin/bash

git clone https://github.com/ShaheenHossain/eagle-backup --depth 1 --branch 10.0 --single-branch /opt/eagle72

cd /opt/eagle72
virtualenv ./venv
source ./venv/bin/activate
pip install -r requirements.txt

exit


sudo su - eagle73 -s /bin/bash

git clone https://github.com/ShaheenHossain/eagle-backup --depth 1 --branch 10.0 --single-branch /opt/eagle73

cd /opt/eagle73
virtualenv ./venv
source ./venv/bin/activate
pip install -r requirements.txt

exit

sudo nano /etc/eagle70.conf

[options]
admin_passwd = ShaheeN1179
db_host = False
db_port = False
db_user = eagle70
db_password = False
addons_path = /opt/eagle70/addons
logfile = /var/log/eagle70.log
xmlrpc_port = 8070


sudo nano /etc/eagle71.conf

[options]
admin_passwd = ShaheeN1179
db_host = False
db_port = False
db_user = eagle71
db_password = False
addons_path = /opt/eagle71/addons
logfile = /var/log/eagle71.log
xmlrpc_port = 8071


sudo nano /etc/eagle72.conf

[options]
admin_passwd = ShaheeN1179
db_host = False
db_port = False
db_user = eagle72
db_password = False
addons_path = /opt/eagle72/addons
logfile = /var/log/eagle72.log
xmlrpc_port = 8072


sudo nano /etc/eagle73.conf

[options]
admin_passwd = ShaheeN1179
db_host = False
db_port = False
db_user = eagle73
db_password = False
addons_path = /opt/eagle73/addons
logfile = /var/log/eagle73.log
xmlrpc_port = 8073

sudo nano /lib/systemd/system/eagle70.service

[Unit]
Description=Eagle 70
Requires=postgresql.service
After=postgresql.service

[Service]
Type=simple
PermissionsStartOnly=true
User=eagle70
Group=eagle70
SyslogIdentifier=eagle70
ExecStart=/opt/eagle70/venv/bin/python2 /opt/eagle70/odoo-bin -c /etc/eagle70.conf

[Install]
WantedBy=multi-user.target

sudo nano /lib/systemd/system/eagle71.service

[Unit]
Description=Eagle 71
Requires=postgresql.service
After=postgresql.service

[Service]
Type=simple
PermissionsStartOnly=true
User=eagle71
Group=eagle71
SyslogIdentifier=eagle71
ExecStart=/opt/eagle71/venv/bin/python2 /opt/eagle71/odoo-bin -c /etc/eagle71.conf

[Install]
WantedBy=multi-user.target


sudo nano /lib/systemd/system/eagle72.service

[Unit]
Description=Eagle 72
Requires=postgresql.service
After=postgresql.service

[Service]
Type=simple
PermissionsStartOnly=true
User=eagle72
Group=eagle72
SyslogIdentifier=eagle72
ExecStart=/opt/eagle72/venv/bin/python2 /opt/eagle72/odoo-bin -c /etc/eagle72.conf

[Install]
WantedBy=multi-user.target


sudo nano /lib/systemd/system/eagle73.service

[Unit]
Description=Eagle 73
Requires=postgresql.service
After=postgresql.service

[Service]
Type=simple
PermissionsStartOnly=true
User=eagle73
Group=eagle73
SyslogIdentifier=eagle73
ExecStart=/opt/eagle73/venv/bin/python2 /opt/eagle73/odoo-bin -c /etc/eagle73.conf

[Install]
WantedBy=multi-user.target

sudo systemctl enable eagle70.service
sudo systemctl enable eagle71.service
sudo systemctl enable eagle72.service
sudo systemctl enable eagle73.service

sudo systemctl start eagle70.service
sudo systemctl start eagle71.service
sudo systemctl start eagle72.service
sudo systemctl start eagle73.service
