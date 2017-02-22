#!/bin/sh
apt-get update &&  apt-get -y upgrade
apt-get install -y php7.0-pgsql php7.0-fpm php7.0-curl unzip gdal-bin python-gdal software-properties-common python-software-properties
if [ $? != 0 ] ; then
	echo "Hubo un problema al instalar php-7.0";
	echo "Se interrumpe la ejecucion";
	exit;
fi

add-apt-repository ppa:webupd8team/java
apt-get update
apt-get install -y oracle-java8-installer
apt-get install -y oracle-java8-set-default
if [ $? != 0 ] ; then
        echo "Hubo un problema al instalar Oracle Java 8";
        echo "Se interrumpe la ejecucion";
        exit;
fi
apt-get install -y tomcat8 tomcat8-admin tomcat8-user
if [ $? != 0 ] ; then
        echo "Hubo un problema al instalar tomcat 8";
        echo "Se interrumpe la ejecucion";
        exit;
fi
apt-get install -y postgresql-9.5 postgresql-9.5-postgis-2.2 postgresql-9.5-postgis-scripts
if [ $? != 0 ] ; then
        echo "Hubo un problema al instalar php-7.0";
        echo "Se interrumpe la ejecucion";
        exit;
fi
wget http://downloads.sourceforge.net/project/geoserver/GeoServer/2.10.0/geoserver-2.10.0-war.zip
unzip geoserver-2.10.0-war.zip
cp geoserver.war /var/lib/tomcat8/webapps/
apt-get update &&  apt-get -y upgrade
apt-get autoremove
cat postgresql.conf > /etc/postgresql/9.5/main/postgresql.conf
cat pg_hba_sinpass.conf > /etc/postgresql/9.5/main/pg_hba.conf
service postgresql restart
psql -U postgres -c "create database rafamgis;"
psql -U postgres -d rafamgis -c "create extension postgis;"
psql -U postgres -d rafamgis -c "alter user postgres with password 'rafam2016';"
cat pg_hba_conpass.conf > /etc/postgresql/9.5/main/pg_hba.conf
cat tomcat-users.xml > /var/lib/tomcat8/conf/tomcat-users.xml
cat tomcat8 > /etc/default/tomcat8
service postgresql restart
if [ $(ps awx | grep postgresql | grep -v grep | wc -l) -eq 0 ] ; then
        echo "Hubo un problema al iniciar postgresql";
        echo "Se interrumpe la ejecucion";
        exit;
fi
service tomcat8 restart

if [ $(ps awx | grep tomcat8 | grep -v grep | wc -l) -eq 0 ] ; then
        echo "Hubo un problema al iniciar postgresql";
        echo "Se interrumpe la ejecucion";
        exit;
fi
echo "Si ya tiene instalado y configurado nginx termine el script con Ctrl-c o Ctrl-z"
echo "de lo contrario presione enter"
read x;
apt-get install -y nginx
cat default_nginx-php > /etc/nginx/sites-available/default
service nginx restart

if [ $(ps awx | grep nginx | grep -v grep | wc -l) -eq 0 ] ; then
        echo "Hubo un problema al iniciar postgresql";
        echo "Se interrumpe la ejecucion";
        exit;
fi

echo "Parece que todo se instalo correctamente";
