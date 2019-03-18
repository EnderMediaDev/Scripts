bold=`tput bold`
normal=`tput sgr0`

setup() {

echo "================================================================================"
echo "##### Welcome to the EnderMedia Server Deployment Script"
echo "##### PLEASE ENSURE YOU ARE RUNNING THIS AS ROOT"
echo "================================================================================"
yum -y install epel-release yum-utils -y
yum -y install wget
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
#rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
yum -y install perl perl-Net-SSLeay openssl perl-IO-Tty perl-Encode-Detect
echo "================================================================================"
echo "##### Running YUM update..."
echo "================================================================================"
sudo yum -y update
echo "================================================================================"
echo "##### Installing Fish Shell..."
echo "================================================================================"
cd /etc/yum.repos.d/
wget https://download.opensuse.org/repositories/shells:fish:release:3/RHEL_7/shells:fish:release:3.repo
yum -y install fish
echo "================================================================================"
echo "##### Starting Webmin Installation..."
echo "================================================================================"
#wget -nv wget http://prdownloads.sourceforge.net/webadmin/webmin-1.900-1.noarch.rpm
yum -y install yum-plugin-replace
#rpm -U webmin-1.900-1.noarch.rpm
echo "[Webmin]
name=Webmin Distribution Neutral
#baseurl=https://download.webmin.com/download/yum
mirrorlist=https://download.webmin.com/download/yum/mirrorlist
enabled=1" > /etc/yum.repos.d/webmin.repo
wget http://www.webmin.com/jcameron-key.asc
rpm --import jcameron-key.asc
yum -y install webmin
echo "================================================================================"
echo "##### Installing NGINX, PHP and MYSQL"
echo "================================================================================"
yum -y install nginx
systemctl start nginx
systemctl enable nginx
mkdir /etc/nginx/sites-enabled
mkdir /etc/nginx/sites-available
yum -y install --enablerepo=remi-php70 php-fpm php-common php-cli php-gd php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-mcrypt php-mssql php-snmp php-soap php-tidy php-php-gettext apr-util-ldap mailcap
systemctl start php-fpm
systemctl enable php-fpm
systemctl restart php-fpm
sed -i.bakuser 's|user = apache|user = nginx|' /etc/php-fpm.d/*.conf
sed -i.bakgroup 's|group = apache|group = nginx|' /etc/php-fpm.d/*.conf
sed -i.baktmp 's|/var/lib/php/session|/tmp|' /etc/php-fpm.d/*.conf
#rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
yum -y replace --enablerepo=remi mysql-libs --replace-with mysql-libs
yum -y install --enablerepo=remi mysql-server
yum -y install --enablerepo=remi-php70 php-mysqlnd
systemctl start mysqld
systemctl enable mysqld
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
systemctl restart nginx 
systemctl restart php-fpm
systemctl restart mysqld
echo "================================================================================"
echo "##### Installing phpMyAdmin Custom for PHP 7..."
echo "================================================================================"
#cd /usr/share/
#wget -nv https://files.phpmyadmin.net/phpMyAdmin/4.4.14/phpMyAdmin-4.4.14-all-languages.tar.bz2
#tar -xf phpMyAdmin-*
#mv phpMyAdmin-*-all-languages phpMyAdmin
#cd phpMyAdmin
#cp config.sample.inc.php config.inc.php
yum -y install --enablerepo=remi-php70 phpmyadmin
echo "================================================================================"
echo "Please use this blowfish: 3g9RaV09VE4oi9p1vvaYPhWgDRUuyrU99jit0sN0, matching this."
echo "### $cfg['blowfish_secret'] = '3g9RaV09VE4oi9p1vvaYPhWgDRUuyrU99jit0sN0'; ###"
echo "================================================================================"
echo "##### Adding port 80, 8080 and 10000 to firewall."
echo "================================================================================"
echo "CONFIGURE MANUALLY: iptables -I INPUT 5 -m state --state NEW -p tcp --dport 10000 -j ACCEPT"
echo "CONFIGURE MANUALLY: iptables -I INPUT 5 -m state --state NEW -p tcp --dport 8080 -j ACCEPT"
echo "CONFIGURE MANUALLY: iptables -I INPUT 5 -m state --state NEW -p tcp --dport 80 -j ACCEPT"
#/sbin/service iptables save
#service iptables restart
echo "================================================================================"
echo "##### INSTALLATION COMPLETE"
echo "##### THANK YOU FOR USING CIAK2009 LEMP SCRIPT"
echo "##### GOODBYE MY DEAR FRIEND, I WILL MISS YOU."
echo "================================================================================"
}

setup 2>&1 | tee install-log.txt
