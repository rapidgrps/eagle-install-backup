This script is based on the install script from André Schenkels (https://github.com/aschenkels-ictstudio/openerp-install-scripts)
but goes a bit further. This script will also give you the ability to define an xmlrpc_port in the .conf file that is generated under /etc/
This script can be safely used in a multi-odoo code base server because the default Odoo port is changed BEFORE the Odoo is started.

<h3>Installation procedure</h3>
1. Download the script:


<p> sudo wget https://raw.githubusercontent.com/ShaheenHossain/eagle-install-backup/9.0/eagle9_install.sh </p>


<p> sudo chmod +x eagle9_install.sh </p>


<p> sudo ./eagle9_install.sh </p>
