This script is based on the install script from André Schenkels (https://github.com/aschenkels-ictstudio/openerp-install-scripts)
but goes a bit further. This script will also give you the ability to define an xmlrpc_port in the .conf file that is generated under /etc/
This script can be safely used in a multi-odoo code base server because the default Odoo port is changed BEFORE the Odoo is started.

<h3>Installation procedure</h3>
1. Download the script:
```
sudo wget https://raw.githubusercontent.com/Yenthe666/InstallScript/10.0/
...
sudo wget https://raw.githubusercontent.com/ShaheenHossain/eagle-install-backup/10.0/eagle_install.sh

```
2. Make the script executable:
```
sudo chmod +x eagle_install.sh
```
3. Execute the script:
```
sudo ./eagle_install.sh
```

git clone https://github.com/it-projects-llc/misc-addons.git		
git clone https://github.com/it-projects-llc/access-addons.git		
git clone https://github.com/it-projects-llc/mail-addons.git		
git clone https://github.com/Openworx/backend_theme.git		
git clone https://github.com/OCA/web.git		
git clone https://github.com/it-projects-llc/website-addons.git		

eagle/custom/addons,/eagle/custom/addons/misc-addons,/eagle/custom/addons/access-addons,/eagle/custom/addons/mail-addons,/eagle/custom/addons/backend_theme,/eagle/custom/addons/web,/eagle/custom/addons/website-addons,/eagle/custom/addons/theme_shoppers_shop,


sudo apt-get dist-upgrade 
letsencrypt certonly

https://www.youtube.com/watch?v=r8uownYJ7cI

contabo 

su  - postgres

psql

update pg_database set datistemplate=false where datname='template1';
drop database Template1;
create database template1 with owner=postgres encoding='UTF-8'
lc_collate='en_US.utf8' lc_ctype='en_US.utf8' template template0;

update pg_database set datistemplate=true where datname='template1';










