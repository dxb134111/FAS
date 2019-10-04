#!/bin/bash
function fhqcz() {
	setenforce 0 >/dev/null 2>&1
	if [ ! -f /etc/selinux/config ]; then
	echo "警告！SELinux关闭失败，请自行检查SELinux关键模块是否存在！脚本停止！"
	exit
	fi
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	iptables -F
	service iptables save >/dev/null 2>&1
	systemctl restart iptables.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告！IPtables重启失败！请手动重启IPtables查看失败原因！脚本停止！"
	exit
	fi
	iptables -A INPUT -s 127.0.0.1/32  -j ACCEPT
	iptables -A INPUT -d 127.0.0.1/32  -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport $httpdport -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 440 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 3389 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 1024 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 137 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 137 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 1194 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 1195 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 1196 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 1197 -j ACCEPT
	iptables -A INPUT -p udp -m udp --dport 137 -j ACCEPT
	iptables -A INPUT -p udp -m udp --dport 138 -j ACCEPT
	iptables -A INPUT -p udp -m udp --dport 53 -j ACCEPT
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT  
	iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	iptables -t nat -A PREROUTING -p udp --dport 138 -j REDIRECT --to-ports 53
	iptables -t nat -A PREROUTING -p udp --dport 137 -j REDIRECT --to-ports 53
	iptables -t nat -A PREROUTING -p udp --dport 1194 -j REDIRECT --to-ports 53
	iptables -t nat -A PREROUTING -p udp --dport 1195 -j REDIRECT --to-ports 53
	iptables -t nat -A PREROUTING -p udp --dport 1196 -j REDIRECT --to-ports 53
	iptables -t nat -A PREROUTING -p udp --dport 1197 -j REDIRECT --to-ports 53
	iptables -t nat -A PREROUTING --dst 10.8.0.1 -p udp --dport 53 -j DNAT --to-destination 10.8.0.1:5353
	iptables -t nat -A PREROUTING --dst 10.9.0.1 -p udp --dport 53 -j DNAT --to-destination 10.9.0.1:5353
	iptables -t nat -A PREROUTING --dst 10.10.0.1 -p udp --dport 53 -j DNAT --to-destination 10.10.0.1:5353
	iptables -t nat -A PREROUTING --dst 10.11.0.1 -p udp --dport 53 -j DNAT --to-destination 10.11.0.1:5353
	iptables -t nat -A PREROUTING --dst 10.12.0.1 -p udp --dport 53 -j DNAT --to-destination 10.12.0.1:5353
	iptables -A INPUT -p udp -m udp --dport 5353 -j ACCEPT  
	iptables -P INPUT DROP
	iptables -t nat -A POSTROUTING -s 10.0.0.0/24  -j MASQUERADE
	iptables -t nat -A POSTROUTING -j MASQUERADE
	service iptables save >/dev/null 2>&1
	systemctl restart iptables.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告！IPtables重启失败！请手动重启IPtables查看失败原因！脚本停止！"
	exit
	fi
	echo
	echo "防火墙已重置完成！"
}
function N01() {
setenforce 0 >/dev/null 2>&1
if [ ! -f /etc/selinux/config ]; then
	echo "警告！SELinux关闭失败，请自行检查SELinux关键模块是否存在！脚本停止！"
	exit
fi
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
rm -rf /etc/sysctl.conf
wget -q ${host}sysctl.conf -P /etc
if [ ! -f /etc/sysctl.conf ]; then
	echo "警告！IP路由转发配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit
fi
sysctl -p /etc/sysctl.conf >/dev/null 2>&1
systemctl stop firewalld.service >/dev/null 2>&1
systemctl disable firewalld.service >/dev/null 2>&1
systemctl stop iptables.service >/dev/null 2>&1
yum -y install iptables iptables-services >/dev/null 2>&1
systemctl start iptables.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！IPtables启动失败！请手动重启IPtables查看失败原因！脚本停止！"
exit
fi
iptables -F
service iptables save >/dev/null 2>&1
systemctl restart iptables.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！IPtables重启失败！请手动重启IPtables查看失败原因！脚本停止！"
exit
fi
iptables -A INPUT -s 127.0.0.1/32  -j ACCEPT
iptables -A INPUT -d 127.0.0.1/32  -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport $faspost -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 440 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 3389 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 1024 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 1194 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 1195 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 1196 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 1197 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 138 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 137 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 137 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 138 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 5353 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A PREROUTING -p udp --dport 138 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -p udp --dport 137 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -p udp --dport 1194 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -p udp --dport 1195 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -p udp --dport 1196 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -p udp --dport 1197 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING --dst 10.8.0.1 -p udp --dport 53 -j DNAT --to-destination 10.8.0.1:5353
iptables -t nat -A PREROUTING --dst 10.9.0.1 -p udp --dport 53 -j DNAT --to-destination 10.9.0.1:5353
iptables -t nat -A PREROUTING --dst 10.10.0.1 -p udp --dport 53 -j DNAT --to-destination 10.10.0.1:5353
iptables -t nat -A PREROUTING --dst 10.11.0.1 -p udp --dport 53 -j DNAT --to-destination 10.11.0.1:5353
iptables -t nat -A PREROUTING --dst 10.12.0.1 -p udp --dport 53 -j DNAT --to-destination 10.12.0.1:5353
iptables -A INPUT -p udp -m udp --dport 5353 -j ACCEPT
iptables -P INPUT DROP
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.9.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.10.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.11.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.12.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -j MASQUERADE
service iptables save >/dev/null 2>&1
systemctl restart iptables.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！IPtables重启失败！请手动重启IPtables查看失败原因！脚本停止！"
exit;0
fi
systemctl enable iptables.service >/dev/null 2>&1
}
function N02() {
yum -y install epel-release
yum -y install telnet avahi openssl openssl-libs openssl-devel lzo lzo-devel pam pam-devel automake pkgconfig gawk tar zip unzip net-tools psmisc gcc pkcs11-helper mariadb mariadb-server httpd libxml2 libxml2-devel bzip2 bzip2-devel libcurl libcurl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel gmp gmp-devel libmcrypt libmcrypt-devel readline readline-devel libxslt libxslt-devel dnsmasq jre-1.7.0-openjdk
rpm -Uvh ${host}webtatic-release.rpm
yum install php70w php70w-fpm php70w-bcmath php70w-cli php70w-common php70w-dba php70w-devel php70w-embedded php70w-enchant php70w-gd php70w-imap php70w-ldap php70w-mbstring php70w-mcrypt php70w-mysqlnd php70w-odbc php70w-opcache php70w-pdo php70w-pdo_dblib php70w-pear.noarch php70w-pecl-apcu php70w-pecl-apcu-devel php70w-pecl-imagick php70w-pecl-imagick-devel php70w-pecl-mongodb php70w-pecl-redis php70w-pecl-xdebug php70w-pgsql php70w-xml php70w-xmlrpc php70w-intl php70w-mcrypt --nogpgcheck php-fedora-autoloader php-php-gettext php-tcpdf php-tcpdf-dejavu-sans-fonts php70w-tidy -y
rpm -Uvh ${host}liblz4-1.8.1.2-alt1.x86_64.rpm
rpm -Uvh ${host}openvpn-2.4.6-1.el7.x86_64.rpm
}
function N03() {
systemctl start mariadb.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！MariaDB初始化失败！请手动启动MariaDB查看失败原因！脚本停止！"
exit;0
fi
mysqladmin -u root password "$fassqlpass"
mysql -u root -p$fassqlpass -e "create database vpndata;"
systemctl restart mariadb.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！MariaDB重启失败！请手动重启MariaDB查看失败原因！脚本停止！"
exit;0
fi
systemctl enable mariadb.service >/dev/null 2>&1
}
function N04() {
sed -i "s/#ServerName www.example.com:80/ServerName localhost:$faspost/g" /etc/httpd/conf/httpd.conf
sed -i "s/Listen 80/Listen $faspost/g" /etc/httpd/conf/httpd.conf
setenforce 0 >/dev/null 2>&1
systemctl start httpd.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！Apache启动失败！请手动启动Apache查看失败原因！脚本停止！"
exit;0
fi
systemctl enable httpd.service >/dev/null 2>&1
cat >> /etc/php.ini <<EOF
extension=php_mcrypt.dll
extension=php_mysqli.dll
EOF
systemctl start php-fpm.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！PHP启动失败！请手动启动PHP查看失败原因！脚本停止！"
exit;0
fi
systemctl enable php-fpm.service >/dev/null 2>&1
}
function N05() {
if [ ! -d /etc/openvpn ]; then
	echo "警告！OpenVPN安装失败，请自行检查rpm包下载源是否可用！脚本停止！"
	exit;0
fi
cd /etc/openvpn && rm -rf /etc/openvpn/*
wget -q ${host}openvpn.zip
if [ ! -f /etc/openvpn/openvpn.zip ]; then
	echo "警告！OpenVPN配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
unzip -o openvpn.zip >/dev/null 2>&1
rm -rf openvpn.zip && chmod 0777 -R /etc/openvpn
sed -i "s/newpass/"$fassqlpass"/g" /etc/openvpn/auth_config.conf
sed -i "s/服务器IP/"$IP"/g" /etc/openvpn/auth_config.conf
systemctl enable openvpn@server1194.service >/dev/null 2>&1
systemctl enable openvpn@server1195.service >/dev/null 2>&1
systemctl enable openvpn@server1196.service >/dev/null 2>&1
systemctl enable openvpn@server1197.service >/dev/null 2>&1
systemctl enable openvpn@server-udp.service >/dev/null 2>&1
}
function N06() {
if [ ! -f /etc/dnsmasq.conf ]; then
	echo "警告！dnsmasq安装失败，请自行检查dnsmasq是否安装正确！脚本停止！"
	exit;0
fi
rm -rf /etc/dnsmasq.conf
wget -q ${host}dnsmasq.conf -P /etc && chmod 0777 /etc/dnsmasq.conf
if [ ! -f /etc/dnsmasq.conf ]; then
	echo "警告！dnsmasq配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
systemctl enable dnsmasq.service >/dev/null 2>&1
}
function web() {
rm -rf /var/www/* && cd /var/www && wget -q https://down.cangshui.net/-mysh/FAS/fas_web.zip
if [ ! -f /var/www/fas_web.zip ]; then
	echo "警告！FAS-WEB配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
unzip -o fas_web.zip >/dev/null 2>&1 && rm -rf fas_web.zip && chmod 0777 -R /var/www/html
sed -i "s/fasadmin/"$fasadminname"/g" /var/www/vpndata.sql
sed -i "s/faspass/"$fasadminpasswd"/g" /var/www/vpndata.sql
sed -i "s/服务器IP/"$IP"/g" /var/www/vpndata.sql
mysql -uroot -p$fassqlpass vpndata < /var/www/vpndata.sql
rm -rf /var/www/vpndata.sql
mv /var/www/html/fassql /var/www/html/$fassqlip
sed -i "s/newpass/"$fassqlpass"/g" /var/www/html/config.php
echo "$RANDOM$RANDOM">>/var/www/auth_key.access
}
function sbin() {
mkdir /etc/rate.d/ && chmod -R 0777 /etc/rate.d/
cd /root&&wget -q ${host}res.zip
if [ ! -f /root/res.zip ]; then
	echo "警告！FAS-res配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
unzip -o res.zip >/dev/null 2>&1 && chmod -R 0777 /root && rm -rf /root/res.zip
mv /root/res/fas.service /lib/systemd/system/fas.service && chmod -R 0777 /lib/systemd/system/fas.service && systemctl enable fas.service >/dev/null 2>&1
cd /bin && wget -q ${host}bin.zip
if [ ! -f /bin/bin.zip ]; then
	echo "警告！FAS命令指示符配置文件下载失败，请自行检查下载源是否可用！脚本停止！"
	exit;0
fi
unzip -o bin.zip >/dev/null 2>&1 && rm -rf /bin/bin.zip && chmod -R 0777 /bin
echo 'FAS系统自定义屏蔽host文件
'>>/etc/fas_host && chmod 0777 /etc/fas_host
}
function qidongya() {
systemctl restart iptables.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！IPtables重启失败！请手动重启IPtables查看失败原因！脚本停止！"
exit;0
fi
systemctl restart mariadb.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！MariaDB重启失败！请手动重启MariaDB查看失败原因！脚本停止！"
exit;0
fi
systemctl restart httpd.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！Apache启动失败！请手动启动Apache查看失败原因！脚本停止！"
exit;0
fi
systemctl restart php-fpm.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！PHP启动失败！请手动启动PHP查看失败原因！脚本停止！"
exit;0
fi
systemctl restart dnsmasq.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！DNSmasq启动失败！请手动启动DNSmasq查看失败原因！脚本停止！"
exit;0
fi
systemctl restart openvpn@server1194.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！openvpn@server1194服务启动失败！请手动启动openvpn@server1194服务查看失败原因！脚本停止！"
exit;0
fi
systemctl restart openvpn@server1195.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！openvpn@server1195服务启动失败！请手动启动openvpn@server1195服务查看失败原因！脚本停止！"
exit;0
fi
systemctl restart openvpn@server1196.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！openvpn@server1196服务启动失败！请手动启动openvpn@server1196服务查看失败原因！脚本停止！"
exit;0
fi
systemctl restart openvpn@server1197.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！openvpn@server1197服务启动失败！请手动启动openvpn@server1197服务查看失败原因！脚本停止！"
exit;0
fi
systemctl restart openvpn@server-udp.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！openvpn@server-udp服务启动失败！请手动启动openvpn@server-udp服务查看失败原因！脚本停止！"
exit;0
fi
systemctl restart fas.service >/dev/null 2>&1
if [[ $? -eq 0 ]];then
echo "" >/dev/null 2>&1
else
echo "警告！Fas服务启动失败！请手动启动Fas服务查看失败原因！脚本停止！"
exit;0
fi
dhclient >/dev/null 2>&1
vpn restart >/dev/null 2>&1
}
function Installation() {
yum install jre-1.7.0-openjdk unzip zip wget curl -y >/dev/null 2>&1
}
function app1() {
rm -rf /APP
mkdir /APP >/dev/null 2>&1
cd /APP
wget -q ${host}fas.apk && wget -q ${host}apktool.jar && java -jar apktool.jar d fas.apk >/dev/null 2>&1 && rm -rf fas.apk
sed -i 's/demo.dingd.cn:80/'${fasapkipname}:${faspost}'/g' `grep demo.dingd.cn:80 -rl /APP/fas/smali/net/openvpn/openvpn/`
sed -i 's/叮咚流量卫士/'${fasapknames}'/g' "/APP/fas/res/values/strings.xml"
sed -i 's/net.fas.vpn/'${fasapkname}'/g' "/APP/fas/AndroidManifest.xml"
java -jar apktool.jar b fas >/dev/null 2>&1
wget -q ${host}signer.zip && unzip -o signer.zip >/dev/null 2>&1
mv /APP/fas/dist/fas.apk /APP/fas.apk
java -jar signapk.jar testkey.x509.pem testkey.pk8 /APP/fas.apk /APP/fas_sign.apk >/dev/null 2>&1
rm -rf /root/fasapp.apk
cp -rf /APP/fas_sign.apk /root/fasapp.apk
rm -rf /APP
if [ ! -f /root/fasapp.apk ]; then
echo
echo "筑梦FAS系统APP制作失败！"
echo
echo ""
echo
echo ""
exit;0
fi
}
function app() {
rm -rf /APP
mkdir /APP >/dev/null 2>&1
cd /APP
wget -q ${host}fas.apk && wget -q ${host}apktool.jar && java -jar apktool.jar d fas.apk >/dev/null 2>&1 && rm -rf fas.apk
sed -i 's/demo.dingd.cn:80/'${fasapkipname}:${faspost}'/g' `grep demo.dingd.cn:80 -rl /APP/fas/smali/net/openvpn/openvpn/`
sed -i 's/叮咚流量卫士/'${fasapknames}'/g' "/APP/fas/res/values/strings.xml"
sed -i 's/net.fas.vpn/'${fasapkname}'/g' "/APP/fas/AndroidManifest.xml"
java -jar apktool.jar b fas >/dev/null 2>&1
wget -q ${host}signer.zip && unzip -o signer.zip >/dev/null 2>&1
mv /APP/fas/dist/fas.apk /APP/fas.apk
java -jar signapk.jar testkey.x509.pem testkey.pk8 /APP/fas.apk /APP/fas_sign.apk >/dev/null 2>&1
rm -rf /var/www/html/fasapp.apk
cp -rf /APP/fas_sign.apk /var/www/html/fasapp.apk
rm -rf /APP
if [ ! -f /var/www/html/fasapp.apk ]; then
echo
echo "筑梦FAS系统APP制作失败！"
echo
echo ""
echo
echo ""
fi
}
function zhuji() {
	clear
	echo
	read -p "请输入本机数据库地址(localhost): " ffsqlip
	if [ -z "$ffsqlip" ];then
	ffsqlip=localhost
	fi
	
	echo
	read -p "请输入本机数据库端口(3306): " ffsqlport
	if [ -z "$ffsqlport" ];then
	ffsqlport=3306
	fi
	
	echo
	read -p "请输入本机数据库账号(root): " ffsqluser
	if [ -z "$ffsqluser" ];then
	ffsqluser=root
	fi
	
	echo
	read -p "请输入本机数据库密码: " fassqlpass
	if [ -z "$fassqlpass" ];then
	fassqlpass=
	fi
	
	echo
	echo "正在为您的系统进行负载，请稍等......"
	sleep 2
	SQL_RESULT=`mysql -h${ffsqlip} -P${ffsqlport} -u${ffsqluser} -p${fassqlpass} -e quit 2>&1`;
	SQL_RESULT_LEN=${#SQL_RESULT};
	if [[ !${SQL_RESULT_LEN} -eq 0 ]];then
	echo
	echo "数据库连接失败，请检查您的数据库密码后重试，脚本停止！";
	exit;
	fi
	
	iptables -A INPUT -p tcp -m tcp --dport $ffsqlport -j ACCEPT
	service iptables save >/dev/null 2>&1
	systemctl restart iptables.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告！IPtables重启失败！请手动重启IPtables查看失败原因！脚本停止！"
	exit
	fi
	
	mysql -h${ffsqlip} -P${ffsqlport} -u${ffsqluser} -p${fassqlpass} <<EOF
grant all privileges on *.* to '${ffsqluser}'@'%' identified by '${fassqlpass}' with grant option;
flush privileges;
EOF
	systemctl restart mariadb.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告！MariaDB重启失败！请手动重启MariaDB查看失败原因！脚本停止！"
	exit
	fi
	
	sleep 2
	echo
	echo "已成功为您的系统进行负载！您可以在任何搭载FAS系统机器上对接至本服务器！"
	
}
function port123() {
clear
echo -e "请选择协议类型（本程序仅适用于FAS系统）："
echo -e "1. TCP 代理端口"
echo -e "2. UDP 直连端口（将转发至53端口）"
read install_type

echo -n "请输入端口号(0-65535):"
read port


if [ $install_type == 1 ];then
	/root/res/proxy.bin -l $port -d
	read has < <(cat /etc/sysconfig/iptables | grep "tcp \-\-dport $port \-j ACCEPT" )
	if [ -z "$has" ];then
		iptables -A INPUT -p tcp -m tcp --dport $port -j ACCEPT
		service iptables save
		echo -e "[添加tcp $port 至防火墙白名单]"
	fi
	read has2 < <(cat /root/res/portlist.conf | grep "port $port tcp" )
	if [ -z "$has2" ];then
		echo -e "port $port tcp">>/root/res/portlist.conf
	fi
	echo -e "[已经成功添加代理端口]"
else
	read has < <(cat /etc/sysconfig/iptables | grep "udp \-\-dport $port \-j ACCEPT" )
	if [ -z "$has" ];then
		iptables -A INPUT -p udp -m udp --dport $port -j ACCEPT
		service iptables save
		echo -e "[添加tcp $port 至防火墙白名单]"
	fi
	iptables -t nat -A PREROUTING -p udp --dport $port -j REDIRECT --to-ports 53 && service iptables save
	echo -e "[已将此端口转发至53 UDP端口]"
fi
echo "感谢使用 再见！"
exit;0
}
function fuji() {
	clear
	echo
	read -p "请输入本机IP: " ffbenjiip
	if [ -z "$ffbenjiip" ];then
	ffbenjiip=
	fi
	
	echo
	read -p "请输入主机IP: " ffsqlip
	if [ -z "$ffsqlip" ];then
	ffsqlip=
	fi
	
	echo
	read -p "请输入主机数据库端口: " ffsqlport
	if [ -z "$ffsqlport" ];then
	ffsqlport=
	fi
	
	echo
	read -p "请输入主机数据库账号: " ffsqluser
	if [ -z "$ffsqluser" ];then
	ffsqluser=
	fi
	
	echo
	read -p "请输入主机数据库密码: " fassqlpass
	if [ -z "$fassqlpass" ];then
	fassqlpass=
	fi
	
	echo
	echo "正在为您的系统进行负载，请稍等......"
	sleep 2
	SQL_RESULT=`mysql -h${ffsqlip} -P${ffsqlport} -u${ffsqluser} -p${fassqlpass} -e quit 2>&1`;
	SQL_RESULT_LEN=${#SQL_RESULT};
	if [[ !${SQL_RESULT_LEN} -eq 0 ]];then
	echo
	echo "连接至主机数据库失败，请检查您的主机数据库密码后重试，脚本停止！";
	exit;
	fi

	rm -rf /etc/openvpn/auth_config.conf
	echo '#!/bin/bash
mysql_host='$ffsqlip'
mysql_user='$ffsqluser'
mysql_pass='$fassqlpass'
mysql_port='$ffsqlport'
mysql_data=vpndata
address='$ffbenjiip'
unset_time=600
del="/root/res/del"

status_file_1="/var/www/html/openvpn_api/online_1194.txt 7075 1194 tcp-server"
status_file_2="/var/www/html/openvpn_api/online_1195.txt 7076 1195 tcp-server"
status_file_3="/var/www/html/openvpn_api/online_1196.txt 7077 1196 tcp-server"
status_file_4="/var/www/html/openvpn_api/online_1197.txt 7078 1197 tcp-server"
status_file_5="/var/www/html/openvpn_api/user-status-udp.txt 7079 53 udp"
sleep=3'>/etc/openvpn/auth_config.conf && chmod -R 0777 /etc/openvpn/auth_config.conf
rm -rf /var/www/html/config.php
echo '<?php
/* 请勿修改 */
define("_host_","'$ffsqlip'");
define("_user_","'$ffsqluser'");
define("_pass_","'$fassqlpass'");
define("_port_","'$ffsqlport'");
define("_ov_","vpndata");
define("_openvpn_","openvpn");
define("_iuser_","iuser");
define("_ipass_","pass");
define("_isent_","isent");
define("_irecv_","irecv");
define("_starttime_","starttime");
define("_endtime_","endtime");
define("_maxll_","maxll");
define("_other_","dlid,tian");
define("_i_","i");'>/var/www/html/config.php && chmod -R 0777 /var/www/html/config.php
	systemctl stop mariadb.service >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "" >/dev/null 2>&1
	else
	echo "警告！MariaDB停止失败！请手动停止MariaDB查看失败原因！脚本停止！"
	exit;0
	fi
	
	sleep 2
	echo
	echo "已成功为您的系统进行负载！主机IP为："$ffsqlip"！"
	echo 
	echo "副机系统请前往shell控制台输入 unfas、unsql 关闭后台登录权限，以防被不法份子入侵系统！"
	echo
	echo "请您及时前往主机FAS后台管理添加本机，本机IP: "$ffbenjiip""
}
function menufuzai() {
	clear
	echo
	echo -e "================================================"
	echo -e "           欢迎使用FAS系统负载管理          "
	echo -e "================================================"
	echo -e "请选择："
	echo
	echo -e "\033[36m 1、主机开启远程连接权限\033[0m \033[31m（主机只需开启一次，后续直接副机对接主机即可）\033[0m"
	echo
	echo -e "\033[36m 2、副机连接主机数据库\033[0m \033[31m（在副机执行，每个机子无限负载主机，仅生效最后一次负载的机器）\033[0m"
	echo
	echo -e "\033[36m 3、退出脚本！\033[0m"
	echo
	echo 
	read -p " 请输入安装选项并回车: " a
	echo
	echo
	k=$a

	if [[ $k == 1 ]];then
	zhuji
	exit;0
	fi
	
	if [[ $k == 2 ]];then
	fuji
	exit;0
	fi
	
	if [[ $k == 3 ]];then
	echo
	echo "感谢您的使用，再见！"
	exit;0
	fi
	
	echo -e "\033[31m 输入错误！请重新运行脚本！\033[0m "
	exit;0
}
function done1() {
random=$( cat /var/www/auth_key.access )
unsql >/dev/null 2>&1
clear
echo "========================================================="
echo "安装完成"
echo "控制台: http://"$IP":"$faspost"/admin/"
echo "账号: "$fasadminname" 密码: "$fasadminpasswd""
echo "控制台随机本地密钥: "$random""
echo "内置数据库管理: http://"$IP":"$faspost"/"$fassqlip"/"
echo "========================================================="
echo "数据库账户: root   密码: "$fassqlpass"      "
echo "代理控制台: http://"$IP":"$faspost"/daili"
echo "========================================================="
echo "管理指令:"
echo "重启VPN：vpn restart" 
echo "FAS后台开启：onfas"
echo "启动VPN：vpn start" 
echo "FAS后台关闭：unfas"
echo "停止VPN：vpn stop" 
echo "数据库开启：onsql"
echo "开任意端口：port" 
echo "数据库关闭：unsql"
echo "========================================================="
echo "APP下载地址: http://"$IP":"$faspost"/fasapp.apk"
echo "如果上面这个APP下载链接下载不了，请手动重新运行脚本，菜单"
echo "里选择3.制作APP，然后在服务器的/root目录了里就能看到APP了"
echo '#盗版屏蔽dingd.cn
127.0.0.1 www.dingd.cn
127.0.0.1 api.dingd.cn' >> /etc/hosts
echo '#盗版屏蔽dingd.cn
127.0.0.1 www.dingd.cn
127.0.0.1 api.dingd.cn' >> /etc/fas_host
rm -f /var/www/html/admin/access.php
exit;0
}
function infoapp() {
	clear
	echo
	read -p "请设置APP名称(默认：流量卫士): " fasapknames
	if [ -z "$fasapknames" ];then
	fasapknames=流量卫士
	fi
	echo -e "已设置APP名称为:\033[32m "$fasapknames"\033[0m"
	
	echo
	read -p "请设置APP解析地址(可输入域名或IP，不带http://): " fasapkipname
	if [ -z "$fasapkipname" ];then
	fasapkipname=`curl -s http://api.cangshui.net/ip.php`;
	fi
	echo -e "已设置APP解析地址为:\033[32m "$fasapkipname"\033[0m"
	
	echo
	read -p "请设置APP端口（默认：81）: " faspost
	if [ -z "$faspost" ];then
	faspost=81
	fi
	echo -e "已设置APP端口为:\033[32m "$faspost"\033[0m"
	
	echo
	read -p "请设置APP包名（默认：net.fas.vpn）: " fasapkname
	if [ -z "$fasapkname" ];then
	fasapkname=net.fas.vpn
	fi
	echo -e "已设置APP包名为:\033[32m "$fasapkname"\033[0m"
	
	sleep 2
	clear 
	sleep 2 
	echo -e "\033[1;32m制作开始...\033[0m"
	sleep 2 
}
function fashoutaijiance() {
	if [ $fassqlip == phpMyAdmin ];then
	fassqlip=`date +%s%N | md5sum | head -c 20 ; echo`;
	echo -e "系统检测到您输入的数据库后台地址为phpMyAdmin，为了您的服务器安全，系统已默认修改您的数据库后台地址为: \033[32m"$fassqlip"\033[0m";
	echo
	sleep 2
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $fassqlip == llws ];then
	fassqlip=`date +%s%N | md5sum | head -c 20 ; echo`;
	echo -e "系统检测到您输入的数据库后台地址为llws，为了您的服务器安全，系统已默认修改您的数据库后台地址为: \033[32m"$fassqlip"\033[0m";
	echo
	sleep 2
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $fassqlip == phpmyadmin ];then
	fassqlip=`date +%s%N | md5sum | head -c 20 ; echo`;
	echo -e "系统检测到您输入的数据库后台地址为phpmyadmin，为了您的服务器安全，系统已默认修改您的数据库后台地址为: \033[32m"$fassqlip"\033[0m";
	echo
	sleep 2
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $fassqlip == sql ];then
	fassqlip=`date +%s%N | md5sum | head -c 20 ; echo`;
	echo -e "系统检测到您输入的数据库后台地址为sql，为了您的服务器安全，系统已默认修改您的数据库后台地址为: \033[32m"$fassqlip"\033[0m";
	echo
	sleep 2
	else
	echo "" >/dev/null 2>&1
	fi
	
	if [ $fassqlip == admin ];then
	fassqlip=`date +%s%N | md5sum | head -c 20 ; echo`;
	echo -e "系统检测到您输入的数据库后台地址为admin，为了您的服务器安全，系统已默认修改您的数据库后台地址为: \033[32m"$fassqlip"\033[0m";
	echo
	sleep 2
	else
	echo "" >/dev/null 2>&1
	fi
}
function infofas() {
	clear
	echo
	echo -e "\033[1;42;37m搭建FAS系统之前需要设置信息，不会填写直接回车\033[0m"
	echo
	sleep 1
	read -p "请设置后台账号(默认admin): " fasadminname
	if [ -z "$fasadminname" ];then
	fasadminname=admin
	fi
	echo -e "已设置后台账号为:\033[32m "$fasadminname"\033[0m"
	
	echo
	read -p "请设置后台密码(134111): " fasadminpasswd
	if [ -z "$fasadminpasswd" ];then
	fasadminpasswd=134111;
	fi
	echo -e "已设置后台密码为:\033[32m "$fasadminpasswd"\033[0m"
	
	echo
	read -p "请设置后台端口(默认81): " faspost
	if [ -z "$faspost" ];then
	faspost=81
	fi
	echo -e "已设置后台端口为:\033[32m http://"$IP":"$faspost"\033[0m"
	
	echo
	read -p "请设置数据库地址(默认dxb,禁用phpMyAdmin): " fassqlip
	if [ -z "$fassqlip" ];then
	fassqlip=dxb
	fi
	echo -e "已设置数据库地址为:\033[32m http://"$IP":"$faspost"/"$fassqlip"\033[0m"
	
	echo
	read -p "请设置数据库密码(默认134111): " fassqlpass
	if [ -z "$fassqlpass" ];then
	fassqlpass=134111
	fi
	echo -e "已设置数据库密码为:\033[32m "$fassqlpass"\033[0m"
	
	echo
	read -p "请设置APP名称(默认：流量卫士): " fasapknames
	if [ -z "$fasapknames" ];then
	fasapknames=流量卫士
	fi
	echo -e "已设置APP名称密码为:\033[32m "$fasapknames"\033[0m"
	
	echo
	read -p "请设置APP解析地址(可输入域名或IP，不带http://): " fasapkipname
	if [ -z "$fasapkipname" ];then
	fasapkipname=`curl -s http://api.cangshui.net/ip.php`;
	fi
	echo -e "已设置APP解析地址为:\033[32m "$fasapkipname"\033[0m"
	
	echo
	read -p "请设置APP包名（默认：net.fas.vpn）: " fasapkname
	if [ -z "$fasapkname" ];then
	fasapkname=net.fas.vpn
	fi
	echo -e "已设置APP包名为:\033[32m "$fasapkname"\033[0m"
	sleep 1
	echo
	echo "请稍等..."
	sleep 2
	echo
	fashoutaijiance
	sleep 1
	echo -e "\033[1;5;31m即将安装FAS系统\033[0m"
	sleep 2
	clear 
	sleep 1
	echo -e "\033[1;32m安装开始...\033[0m"
	sleep 2 
}
function infodongyun() {
	clear
	echo
	read -p "请输入您的后台端口(默认81): " httpdport
	if [ -z "$httpdport" ];then
	httpdport=81
	fi
	echo -e "您已输入的后台端口为:\033[32m "$httpdport"\033[0m"
	sleep 2
	clear
	sleep 1
	printf "\n[\033[34m 1/1 \033[0m]   正在重置防火墙并关闭SELinux....\n";
	sleep 2
}
function fuzaiji() {
	sleep 1
	echo "请稍等，正在为您关闭负载机扫描..."
	sleep 2
	if [ ! -f /bin/jk.sh ]; then
	echo
	echo "警告！负载机扫描关闭失败！请确认您是否已经关闭过或还未搭建筑梦FAS系统！"
	exit;0
	fi
	rm -rf /bin/jk.sh
    vpn restart
	echo "负载机扫描关闭成功！感谢您的使用，再见！"
}
function mysqlstop() {
	sleep 1
	echo "请稍等，正在为您关闭负载机数据库服务..."
	sleep 2
	service mariadb stop >/dev/null 2>&1
	if [[ $? -eq 0 ]];then
	echo "MariaDB关闭成功！感谢您的使用，再见！" >/dev/null 2>&1
	else
	echo "警告！MariaDB关闭失败！请手动关闭MariaDB查看失败原因！脚本停止！"
	exit 0
	fi
	systemctl disable mariadb.service >/dev/null 2>&1
	echo
	echo "MariaDB关闭成功！感谢您的使用，再见！"
}
function menu() {
	clear
	echo
	echo -e "           欢迎使用FAS交流群:659918247          "
	echo -e "请选择："
	echo
	echo -e "\033[31m 1、安装FAS系统 \033[0m"
	echo ""
	echo -e "\033[31m 2、安装APP制作环境 \033[0m"
	echo ""
	echo -e "\033[31m 3、制作APP \033[0m"
	echo
	echo -e "\033[31m 4、FAS系统负载\033[0m"
	echo
	echo -e "\033[31m 5、重置防火墙\033[0m"
	echo
	echo -e "\033[31m 6、关闭数据库服务\033[0m"
	echo 
	echo -e "\033[31m 7、关闭负载机的扫描\033[0m"
	echo
	echo -e "\033[31m 8、添加TCP/UDP端口\033[0m"
	echo
	echo -e "\033[31m 9、退出脚本 \033[0m"
	echo
	echo 
	read -p " 请输入安装选项并回车: " a
	echo
	k=$a

	if [[ $k == 1 ]];then
	infofas
	clear
	printf "\n[\033[34m 1/7 \033[0m]   安装防火墙\n";
	N01
	printf "\n[\033[34m 2/7 \033[0m]   安装LAMP环境\n";
	N02 >/dev/null 2>&1
	printf "\n[\033[34m 3/7 \033[0m]   安装流控程序\n";
	N03
	N04
	N05
	N06
	printf "\n[\033[34m 4/7 \033[0m]   安装WEB\n";
	web
	printf "\n[\033[34m 5/7 \033[0m]   设置依赖\n";
	sbin
	printf "\n[\033[34m 6/7 \033[0m]   制作APP\n";
	app
	printf "\n[\033[34m 7/7 \033[0m]   启动所有服务\n";
	qidongya
	done1
	exit;0
	fi
	
	if [[ $k == 2 ]];then
	clear
	echo
	sleep 2 
	echo -e "\033[1;32m安装开始...\033[0m"
	clear
	sleep 2
	printf "\n[\033[34m 1/1 \033[0m]   正在安装APP所需环境（耗时较长，耐心等待）....\n";
	Installation
	echo "APP所需环境安装已完成，请执行脚本输入3制作您的APP吧！"
	exit;0
	fi
	
	if [[ $k == 3 ]];then
	infoapp
	clear
	printf "\n[\033[34m 1/1 \033[0m]   正在制作Fas - APP....\n";
	app1
	echo
	echo "筑梦FAS-APP制作完成，请前往/root 目录获取 fasapp.apk 文件！"
	exit;0
	fi
	
	if [[ $k == 4 ]];then
	menufuzai
	exit;0
	fi
	
	if [[ $k == 5 ]];then
	infodongyun
	fhqcz
	exit;0
	fi
	
	if [[ $k == 6 ]];then
	mysqlstop
	exit;0
	fi
	
	if [[ $k == 7 ]];then
	fuzaiji
	exit;0
	fi
	
	if [[ $k == 8 ]];then
	port123
	exit;0
	fi
	
	if [[ $k == 9 ]];then
	echo "感谢您的使用，再见！"
	exit;0
	fi
	
	echo -e "\033[31m 输入错误！请重新运行脚本！\033[0m "
	exit;0
}
function ipget() {
clear
sleep 2
echo
echo "请选择IP源获取方式（自动获取失败的，请选择手动输入！）"
echo
echo "1、自动获取IP"
echo "2、手动输入IP"
echo
read -p "请输入: " a
echo
k=$a

if [[ $k == 1 ]];then
sleep 1
echo "请稍等..."
sleep 2
IP=`curl -s http://api.cangshui.net/ip.php`;
clear
sleep 1
echo
echo "系统检测到的IP为："$IP"，如不正确请立即停止安装，回车继续："
read
sleep 1
echo "请稍等..."
sleep 2
menu
fi

if [[ $k == 2 ]];then
sleep 1
read -p "请输入您的IP/动态域名: " IP
if [ -z "$IP" ];then
IP=
fi
echo "请稍等..."
sleep 2
clear
sleep 1
echo
echo "系统检测到您输入的IP/动态域名为："$IP"，如不正确请立即停止安装，回车继续："
read
sleep 1
echo "请稍等..."
sleep 2
menu
fi

echo -e "\033[31m 输入错误！请重新运行脚本！\033[0m "
exit;0
}
function logo() {
clear
echo "1或2随便选"
echo "1"
echo "2"
echo
read -p " 请选择: " a
echo
k=$a

if [[ $k == 1 ]];then
clear
sleep 2
echo "欢迎使用FAS"
echo "如要继续请回车"
read
ipget
fi

if [[ $k == 2 ]];then
clear
sleep 2
echo "欢迎使用FAS"
echo "如要继续请回车"
read
ipget
fi

sleep 2
echo -e "\033[31m 说了选1或2  \033[0m "
reboot
exit;0
}
function safe() {
if [ ! -e "/dev/net/tun" ]; then
    echo
    echo -e "\033[1;32m安装出错\033[0m \033[5;31m[原因：系统存在异常！]\033[0m 
	\033[1;32m错误码：\033[31mVFVOL1RBUOiZmuaLn+e9keWNoeS4jeWtmOWcqA== \033[0m\033[0m"
	exit 0;
fi
if [ ! -f /bin/mv ]; then
	echo
	echo "\033[1;31m\033[05m 警告！检测到非法系统环境，请管理员检查服务器或者重装系统后重试！错误码：bXbkuI3lrZjlnKg= \033[0m"
	exit;0
fi
if [ ! -f /bin/cp ]; then
	echo
	echo "\033[1;31m\033[05m 警告！检测到非法系统环境，请管理员检查服务器或者重装系统后重试！错误码：Y3DkuI3lrZjlnKg= \033[0m"
	exit;0
fi
if [ ! -f /bin/rm ]; then
	echo
	echo "\033[1;31m\033[05m 警告！检测到非法系统环境，请管理员检查服务器或者重装系统后重试！错误码：cm3kuI3lrZjlnKg= \033[0m"
	exit;0
fi
if [ ! -f /bin/ps ]; then
	echo
	echo "\033[1;31m\033[05m 警告！检测到非法系统环境，请管理员检查服务器或者重装系统后重试！错误码：cHPkuI3lrZjlnKg= \033[0m"
	exit;0
fi
if [ -f /etc/os-release ];then
centos_v=`cat /etc/os-release |awk -F'[="]+' '/^VERSION_ID=/ {print $2}'`
if [ $centos_v != "7" ];then
echo
echo "-bash: "$0": 对不起，系统环境异常，当前系统为：CentOS "$centos_v" ，请更换系统为 CentOS 7.0 - 7.4 后重试！"
exit 0;
fi
elif [ -f /etc/redhat-release ];then
centos_v=`cat /etc/redhat-release |grep -Eos '\b[0-9]+\S*\b' |cut -d'.' -f1`
if [ $centos_v != "7" ];then
echo
echo "-bash: "$0": 对不起，系统环境异常，当前系统为：CentOS "$centos_v" ，请更换系统为 CentOS 7.0 - 7.4后重试！"
exit 0;
fi
else
echo
echo "-bash: "$0": 对不起，系统环境异常，当前系统为：CentOS 未知 ，请更换系统为 CentOS 7.0 - 7.4 后重试！"
exit 0;
fi
}
function main() {
rm -rf $0 >/dev/null 2>&1
clear 
echo
echo "脚本开始运行"
sleep 2 
echo
echo "检查安装环境"
safe
yum -y install curl wget openssl >/dev/null 2>&1
host=https://github.com/dxb134111/FAS/raw/master/
logo
}
main
exit;0
