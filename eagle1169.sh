OE_USER="eagle1169"
DIR_PATH=$(pwd)
OE_VERSION=11.0
OE_HOME_EXT="/$OE_USER/${OE_USER}-server"
PORT=8069
OE_HOME="/$OE_USER"
PATH_LOG=/$OE_USER/log
CUSTOM=/$OE_USER/custom
CUSTOM_ADDONS=/$OE_USER/custom/addons
#OE_CONFIG="${OE_USER}-server"

wk64="https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.$(lsb_release -cs)_amd64.deb"
wk32="https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.$(lsb_release -cs)_i386.deb"

sudo adduser --system --quiet --shell=/bin/bash --home=$OE_HOME --gecos 'EAGLE1169' --group $OE_USER
sudo adduser $OE_USER sudo

sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install -y git
sudo apt-get install postgresql -y
sudo su - postgres -c "createuser -s $OE_USER"

sudo mkdir $OE_HOME
sudo mkdir $PATH_LOG
sudo mkdir $CUSTOM
sudo mkdir $CUSTOM_ADDONS
cd $OE_HOME

sudo git clone --depth 1 --branch $OE_VERSION https://github.com/ShaheenHossain/eagle11 $OE_HOME_EXT/

sudo apt-get -y install gcc python3-dev libxml2-dev libxslt1-dev \
 libevent-dev libsasl2-dev libldap2-dev libpq-dev \
 libpng-dev libjpeg-dev

sudo apt-get -y install python3 python3-pip python-pip
sudo pip3 install libsass vobject qrcode num2words setuptools

sudo apt-get -y install libxrender1

sudo apt-get install -y npm node-less
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g less

sudo rm $OE_HOME/wkhtmltox_0.12.5-1*.deb
sudo rm wkhtmltox_0.12.5-1*.deb
if [[ "`getconf LONG_BIT`" == "32" ]];

then
	sudo wget $wk32
	wkhtmltox_0.12.5-1.bionic_amd64.deb
else
	sudo wget $wk64
fi

sudo dpkg -i --force-depends wkhtmltox_0.12.5-1*.deb
sudo ln -s /usr/local/bin/wkhtml* /usr/bin


sudo pip3 install -r $OE_HOME/$OE_VERSION/$OE_USER/requirements.txt
sudo apt-get -f -y install

cd $DIR_PATH

sudo mkdir /config
sudo rm /config/$OE_USER.conf
sudo touch /config/$OE_USER.conf

echo "
[options]
; This is the password that allows database operations:
;admin_passwd =
db_host = False
db_port = False
;db_user =
;db_password =
data_dir = $OE_HOME/data
logfile= $OE_HOME/log/$OE_USER-server.log
############# addons path ######################################
addons_path = $PATHREPOS,$OE_HOME/$OE_VERSION/$OE_USER/addons
#################################################################
xmlrpc_port = $PORT
;dbfilter = $OE_USER
logrotate = True
limit_time_real = 1000
limit_time_cpu = 1000
" | sudo tee --append /config/$OE_USER.conf

sudo rm /etc/systemd/system/$OE_USER.service
sudo touch /etc/systemd/system/$OE_USER.service
sudo chmod +x /etc/systemd/system/$OE_USER.service
echo "
[Unit]
Description=$OE_USER11
After=postgresql.service
[Service]
Type=simple
User=$OE_USER
ExecStart=$OE_HOME/$OE_VERSION/$OE_USER/odoo-bin --config /config/$OE_USER.conf
[Install]
WantedBy=multi-user.target
" | sudo tee --append /etc/systemd/system/$OE_USER.service
sudo systemctl daemon-reload
sudo systemctl enable $OE_USER.service
sudo systemctl start $OE_USER

sudo chown -R $OE_USER: $OE_HOME
sudo chown -R $OE_USER: /config


echo "Eagle ERP $OE_VERSION Installation has finished!! ;) by eagle-erp.com"
