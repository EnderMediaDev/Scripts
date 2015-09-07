bold=`tput bold`
normal=`tput sgr0`

setup() {

echo "Welcome to the EnderMedia Server Deployment Script"
echo "PLEASE ENSURE YOU ARE RUNNING THIS AS ROOT"

yum -y install epel-release
rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
wget http://prdownloads.sourceforge.net/webadmin/webmin-1.760-1.noarch.rpm
yum -y install perl perl-Net-SSLeay openssl perl-IO-Tty
rpm -U webmin-1.760-1.noarch.rpm
yum -y install nginx
service nginx start
chkconfig nginx on
yum -y install php56w-fpm php56w-common php56w-cli php56w-gd php56w-imap php56w-ldap php56w-odbc php56w-pear php56w-xml php56w-xmlrpc php56w-mbstring php56w-mcrypt php56w-mssql php56w-snmp php56w-soap php56w-tidy php-php-gettext apr-util-ldap mailcap
service php-fpm start
chkconfig php-fpm on
service php-fpm restart
sed -i.bakuser 's|user = apache|user = nginx|' /etc/php-fpm.d/*.conf
sed -i.baktmp 's|/var/lib/php/session/|/tmp|' /etc/php-fpm.d/*.conf
yum -y install mysql55w-server
yum -y install php56w-mysqlnd
service mysqld start
chkconfig mysqld on
echo "Getting ready to start MySQL setup process."
randompass=cat /dev/urandom | tr -cd 'a-f0-9' | head -c 10
echo "Please use ${bold}$randompass"
/usr/bin/mysql_secure_installation
service nginx restart
service php-fpm restart
service mysqld restart
}

setup 2>&1 | tee /install-log.txt
