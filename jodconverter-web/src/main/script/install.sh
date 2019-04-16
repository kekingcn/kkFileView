#!/bin/bash
cd /tmp

install_redhat() {
    wget https://iweb.dl.sourceforge.net/project/openofficeorg.mirror/4.1.6/binaries/zh-CN/Apache_OpenOffice_4.1.6_Linux_x86-64_install-rpm_zh-CN.tar.gz -cO openoffice_rpm.tar.gz && tar zxf /tmp/openoffice_rpm.tar.gz && cd /tmp/zh-CN/RPMS
   if [ $? -eq 0 ];then
     rpm -Uvih *.rpm
     echo 'install desktop service ...'
     rpm -Uvih desktop-integration/openoffice4.1.6-redhat-menus-4.1.6-9790.noarch.rpm
     echo 'install finshed...'
   else
     echo 'download package error...'
   fi
}

install_ubuntu() {
   wget  https://iweb.dl.sourceforge.net/project/openofficeorg.mirror/4.1.6/binaries/zh-CN/Apache_OpenOffice_4.1.6_Linux_x86-64_install-deb_zh-CN.tar.gz  -cO openoffice_deb.tar.gz && tar zxf /tmp/openoffice_deb.tar.gz && cd /tmp/zh-CN/DEBS
   echo $?
 if [ $? -eq 0 ];then
     dpkg -i *.deb
     echo 'install desktop service ...'
     dpkg -i desktop-integration/openoffice4.1-debian-menus_4.1.6-9790_all.deb
     echo 'install finshed...'
  else
    echo 'download package error...'
 fi
}


if [ -f "/etc/redhat-release" ]; then
  yum install -y wget
  install_redhat
else
  apt-get install -y wget
  install_ubuntu
fi