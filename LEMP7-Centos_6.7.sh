bold=`tput bold`
normal=`tput sgr0`

setup() {

echo "================================================================================"
echo "##### Welcome to the EnderMedia Server Deployment Script"
echo "##### PLEASE ENSURE YOU ARE RUNNING THIS AS ROOT"
echo "================================================================================"
yum -y install epel-release
rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
yum -y install perl perl-Net-SSLeay openssl perl-IO-Tty wget
echo "================================================================================"
echo "##### Starting Webmin Installation..."
echo "================================================================================"
wget -nv http://prdownloads.sourceforge.net/webadmin/webmin-1.760-1.noarch.rpm
yum -y install yum-plugin-replace
rpm -U webmin-1.760-1.noarch.rpm
echo "================================================================================"
echo "##### Installing NGINX, PHP and MYSQL"
echo "================================================================================"
yum -y install nginx
service nginx start
chkconfig nginx on
mkdir /etc/nginx/sites-enabled
mkdir /etc/nginx/sites-available
yum -y install --enablerepo=webtatic-testing php70w-fpm php70w-mysql php70w-mysqli php70w-common php70w-cli php70w-gd php70w-imap php70w-ldap php70w-odbc php70w-pear php70w-xml php70w-xmlrpc php70w-mbstring php70w-mcrypt php70w-mssql php70w-snmp php70w-soap php70w-tidy php-php-gettext apr-util-ldap mailcap
service php-fpm start
chkconfig php-fpm on
service php-fpm restart
sed -i.bakuser 's|user = apache|user = nginx|' /etc/php-fpm.d/*.conf
sed -i.bakgroup 's|group = apache|group = nginx|' /etc/php-fpm.d/*.conf
sed -i.baktmp 's|/var/lib/php/session|/tmp|' /etc/php-fpm.d/*.conf
yum -y replace mysql-libs --replace-with mysql70w-libs
yum -y install mysql55w-server
yum -y install php70w-mysqlnd
service mysqld start
chkconfig mysqld on
echo "================================================================================"
echo "Getting ready to start MySQL setup process."
echo "Please use this password:"
echo "================================================================================"
echo ""
sudo < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c10
echo ""
echo ""
echo "================================================================================"
echo "Starting installation..."
echo "================================================================================"
/usr/bin/mysql_secure_installation
echo "================================================================================"
echo "##### Restarting services..."
echo "================================================================================"
service nginx restart
service php-fpm restart
service mysqld restart
echo "================================================================================"
echo "##### Installing phpMyAdmin Custom for PHP 7..."
echo "================================================================================"
cd /usr/share/
wget -nv https://files.phpmyadmin.net/phpMyAdmin/4.4.14/phpMyAdmin-4.4.14-all-languages.tar.bz2
tar -xf phpMyAdmin-*
mv phpMyAdmin-*-all-languages phpMyAdmin
cd phpMyAdmin
cp config.sample.inc.php config.inc.php
echo "================================================================================"
echo "Please use this blowfish: D{F3}s+TJodRbMKo2|v}D|8LL]R]@RLfEu#vZ"
echo "### $cfg['blowfish_secret'] = 'D{F3}s+TJodRbMKo2|v}D|8LL]R]@RLfEu#vZ'; ###"
echo "================================================================================"
echo "##### Adding port 80, 8080 and 10000 to firewall."
echo "================================================================================"
iptables -I INPUT 5 -m state --state NEW -p tcp --dport 10000 -j ACCEPT
iptables -I INPUT 5 -m state --state NEW -p tcp --dport 8080 -j ACCEPT
iptables -I INPUT 5 -m state --state NEW -p tcp --dport 80 -j ACCEPT
/sbin/service iptables save
service iptables restart
echo "================================================================================"
echo "##### INSTALLATION COMPLETE"
echo "##### THANK YOU FOR USING CIAK2009 LEMP SCRIPT"
echo "##### GOODBYE MY DEAR FRIEND, I WILL MISS YOU."
echo "================================================================================"
}

setup 2>&1 | tee install-log.txt
