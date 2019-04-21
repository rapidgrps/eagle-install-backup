This script is based on the install script from André Schenkels (https://github.com/aschenkels-ictstudio/openerp-install-scripts)
but goes a bit further. This script will also give you the ability to define an xmlrpc_port in the .conf file that is generated under /etc/
This script can be safely used in a multi-odoo code base server because the default Odoo port is changed BEFORE the Odoo is started.


<h2>Dependency Pandas </h2>

<h3>Installation procedure 11</h3>

1. Download the script: 8069 eagle1169

sudo wget https://raw.githubusercontent.com/ShaheenHossain/eagle-install-backup/1169/eagle-1169-install.sh

2. Make the script executable:
sudo chmod +x eagle-1169-install.sh

3. Execute the script:
sudo ./eagle-1169-install.sh
```


===============================================================================================

sudo apt update && sudo apt upgrade


sudo apt install git python3-pip build-essential wget python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools node-less

sudo useradd -m -d /eagle1169 -U -r -s /bin/bash eagle1169


sudo apt install postgresql


sudo su - postgres -c "createuser -s eagle1169"

wget https://builds.wkhtmltopdf.org/0.12.1.3/wkhtmltox_0.12.1.3-1~bionic_amd64.deb

sudo apt install /wkhtmltox_0.12.1.3-1~bionic_amd64.deb

sudo su - eagle1169

whoami

sudo git clone --depth 1 --branch 11.0 https://github.com/ShaheenHossain/eagle11 /eagle1169/eagle1169

cd /eagle1169
python3 -m venv eagle1169-venv

source eagle1169-venv/bin/activate

pip3 install wheel

pip3 install -r eagle1169/requirements.txt

deactivate

exit

sudo mkdir /eagle1169/eagle1169-custom-addons

sudo chown odoo: /eagle1169/eagle1169-custom-addons

sudo cp /eagle1169/eagle1169/debian/odoo.conf /etc/eagle1169.conf

sudo nano /etc/systemd/system/eagle1169.service
-------------------------------
[Unit]
Description=eagle1169
Requires=postgresql.service
After=network.target postgresql.service

[Service]
Type=simple
SyslogIdentifier=eagle1169
PermissionsStartOnly=true
User=eagle1169
Group=eagle1169
ExecStart=/opt/eagle1169/eagle1169-venv/bin/python3 /opt/eagle1169/eagle1169/odoo-bin -c /etc/eagle1169.conf
StandardOutput=journal+console

[Install]
WantedBy=multi-user.target

----------------------------------------------

sudo systemctl start eagle1169

