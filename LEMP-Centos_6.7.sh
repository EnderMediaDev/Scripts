bold=`tput bold`
normal=`tput sgr0`

setup() {

echo "Welcome to the EnderMedia Server Deployment Script"
echo "PLEASE ENSURE YOU ARE RUNNING THIS AS ROOT"

yum -y install epel-release
rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
yum -y install perl perl-Net-SSLeay openssl perl-IO-Tty wget
wget -nv http://prdownloads.sourceforge.net/webadmin/webmin-1.760-1.noarch.rpm
yum -y install yum-plugin-replace
rpm -U webmin-1.760-1.noarch.rpm
yum -y install nginx
service nginx start
chkconfig nginx on
yum -y install php56w-fpm php56w-common php56w-cli php56w-gd php56w-imap php56w-ldap php56w-odbc php56w-pear php56w-xml php56w-xmlrpc php56w-mbstring php56w-mcrypt php56w-mssql php56w-snmp php56w-soap php56w-tidy php-php-gettext apr-util-ldap mailcap
service php-fpm start
chkconfig php-fpm on
service php-fpm restart
sed -i.bakuser 's|user = apache|user = nginx|' /etc/php-fpm.d/*.conf
sed -i.bakgroup 's|group = apache|group = nginx|' /etc/php-fpm.d/*.conf
sed -i.baktmp 's|/var/lib/php/session|/tmp|' /etc/php-fpm.d/*.conf
yum -y replace mysql-libs --replace-with mysql55w-libs
yum -y install mysql55w-server
yum -y install php56w-mysqlnd
service mysqld start
chkconfig mysqld on
echo "Getting ready to start MySQL setup process."
echo "Please use this password:"
echo ""
sudo < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c10
echo "Starting installation..."
/usr/bin/mysql_secure_installation
service nginx restart
service php-fpm restart
service mysqld restart

rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
yum -y --enablerepo=remi install phpMyAdmin

mkdir /usr/share/nginx/sites-enabled
mkdir /usr/share/nginx/sites-available

iptables -A INPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -m state --state NEW -p tcp --dport 8080 -j ACCEPT
/sbin/service iptables save
}

setup 2>&1 | tee install-log.txt
