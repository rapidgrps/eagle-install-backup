OE_USER="eagle1169"
OE_HOME="/$OE_USER"
OE_HOME_EXT="/$OE_USER/${OE_USER}-server"
INSTALL_WKHTMLTOPDF="True"
OE_PORT="8069"
OE_VERSION="11.0"
OE_SUPERADMIN="admin"
OE_CONFIG="${OE_USER}-server"
DIR_PATH=$(pwd)

wk64="https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.$(lsb_release -cs)_amd64.deb"
wk32="https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.$(lsb_release -cs)_i386.deb"


echo -e "\n---- Create Eagle ERP system user ----"
sudo adduser --system --quiet --shell=/bin/bash --home=$OE_HOME --gecos 'EAGLE1169' --group $OE_USER
#The user should also be added to the sudo'ers group.
sudo adduser $OE_USER sudo

#--------------------------------------------------
# Update Eagle ERP Server
#--------------------------------------------------

sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install -y git

#--------------------------------------------------
# Install PostgreSQL for Eagle ERP Server
#--------------------------------------------------

#sudo apt-get install postgresql -y
sudo apt-get install postgresql libpq-dev -y


echo -e "\n---- Creating the EAGLE ERP PostgreSQL User  ----"

sudo su - postgres -c "createuser -s $OE_USER" 2> /dev/null || true

echo -e "\n---- Create custom module directory ----"
sudo su $OE_USER -c "mkdir $OE_HOME/custom"
sudo su $OE_USER -c "mkdir $OE_HOME/custom/addons"


echo -e "\n---- Setting permissions on home folder ----"
sudo chown -R $OE_USER:$OE_USER $OE_HOME/*

#--------------------------------------------------
# Install Eagle
#--------------------------------------------------
echo -e "\n==== Installing Eagle Server ===="
sudo git clone --depth 1 --branch $OE_VERSION https://github.com/ShaheenHossain/eagle11 $OE_HOME_EXT/


#--------------------------------------------------
# Install Dependencies
#--------------------------------------------------

cd $OE_HOME

sudo apt-get -y install gcc python3-dev libxml2-dev libxslt1-dev \
 libevent-dev libsasl2-dev libldap2-dev libpq-dev \
 libpng-dev libjpeg-dev

sudo apt-get -y install python3 python3-pip python-pip
sudo pip3 install libsass vobject qrcode num2words setuptools

sudo apt-get -y install libxrender1

sudo apt-get install -y npm node-less
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g less

#--------------------------------------------------
# Install Wkhtmltopdf if needed
#--------------------------------------------------

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

echo -e "\n---- Install Eagle ERP requirement packages ----"

sudo pip3 install -r $OE_HOME/${OE_USER}-server/requirements.txt
sudo apt-get -f -y install

cd $DIR_PATH

echo -e "\n---- Create Log directory ----"
sudo mkdir /var/log/$OE_USER
sudo chown $OE_USER:$OE_USER /var/log/$OE_USER

echo -e "* Create server config file"

sudo touch /etc/${OE_CONFIG}.conf
echo -e "* Creating server config file"
sudo su root -c "printf '[options] \n; This is the password that allows database operations:\n' >> /etc/${OE_CONFIG}.conf"
sudo su root -c "printf 'admin_passwd = ${OE_SUPERADMIN}\n' >> /etc/${OE_CONFIG}.conf"
sudo su root -c "printf 'xmlrpc_port = ${OE_PORT}\n' >> /etc/${OE_CONFIG}.conf"
sudo su root -c "printf 'logfile = /var/log/${OE_USER}/${OE_CONFIG}.log\n' >> /etc/${OE_CONFIG}.conf"
sudo su root -c "printf 'addons_path=${OE_HOME_EXT}/addons,${OE_HOME}/custom/addons\n' >> /etc/${OE_CONFIG}.conf"
sudo chown $OE_USER:$OE_USER /etc/${OE_CONFIG}.conf
sudo chmod 640 /etc/${OE_CONFIG}.conf

echo -e "* Create startup file"
sudo su root -c "echo '#!/bin/sh' >> $OE_HOME_EXT/start.sh"
sudo su root -c "echo 'sudo -u $OE_USER $OE_HOME_EXT/openerp-server --config=/etc/${OE_CONFIG}.conf' >> $OE_HOME_EXT/start.sh"
sudo chmod 755 $OE_HOME_EXT/start.sh

#--------------------------------------------------
# Adding Eagle ERP as a deamon (initscript)
#--------------------------------------------------

echo -e "* Create init file"
cat <<EOF > ~/$OE_CONFIG
PATH=/bin:/sbin:/usr/bin
DAEMON=$OE_HOME_EXT/odoo-bin
NAME=$OE_CONFIG
DESC=$OE_CONFIG
USER=$OE_USER
CONFIGFILE="/etc/${OE_CONFIG}.conf"
PIDFILE=/var/run/\${NAME}.pid
DAEMON_OPTS="-c \$CONFIGFILE"
[ -x \$DAEMON ] || exit 0
[ -f \$CONFIGFILE ] || exit 0
checkpid() {
[ -f \$PIDFILE ] || return 1
pid=\`cat \$PIDFILE\`
[ -d /proc/\$pid ] && return 0
return 1
}
case "\${1}" in
start)
echo -n "Starting \${DESC}: "
start-stop-daemon --start --quiet --pidfile \$PIDFILE \
--chuid \$USER --background --make-pidfile \
--exec \$DAEMON -- \$DAEMON_OPTS
echo "\${NAME}."
;;
stop)
echo -n "Stopping \${DESC}: "
start-stop-daemon --stop --quiet --pidfile \$PIDFILE \
--oknodo
echo "\${NAME}."
;;
restart|force-reload)
echo -n "Restarting \${DESC}: "
start-stop-daemon --stop --quiet --pidfile \$PIDFILE \
--oknodo
sleep 1
start-stop-daemon --start --quiet --pidfile \$PIDFILE \
--chuid \$USER --background --make-pidfile \
--exec \$DAEMON -- \$DAEMON_OPTS
echo "\${NAME}."
;;
*)
N=/etc/init.d/\$NAME
echo "Usage: \$NAME {start|stop|restart|force-reload}" >&2
exit 1
;;
esac
exit 0
EOF

echo -e "* Security Init File"
sudo mv ~/$OE_CONFIG /etc/init.d/$OE_CONFIG
sudo chmod 755 /etc/init.d/$OE_CONFIG
sudo chown root: /etc/init.d/$OE_CONFIG

echo -e "* Start Eagle ERP on Startup"
sudo update-rc.d $OE_CONFIG defaults

echo -e "* Starting Eagle ERP Service"
sudo su root -c "/etc/init.d/$OE_CONFIG start"
echo "-----------------------------------------------------------"
echo "Done! The Eagle server is up and running. Specifications:"
echo "Port: $OE_PORT"
echo "User service: $OE_USER"
echo "User PostgreSQL: $OE_USER"
echo "Code location: $OE_USER"
echo "Addons folder: $OE_USER/$OE_CONFIG/addons/"
echo "Start Eagle ERP service: sudo service $OE_CONFIG start"
echo "Stop Eagle ERP service: sudo service $OE_CONFIG stop"
echo "Restart Eagle ERP service: sudo service $OE_CONFIG restart"
echo "-----------------------------------------------------------"
