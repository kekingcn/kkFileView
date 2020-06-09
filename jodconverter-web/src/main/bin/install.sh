#!/bin/bash
cd /tmp

install_redhat() {
    wget https://kkfileview.keking.cn/Apache_OpenOffice_4.1.6_Linux_x86-64_install-rpm_zh-CN.tar.gz -cO openoffice_rpm.tar.gz && tar zxf /tmp/openoffice_rpm.tar.gz && cd /tmp/zh-CN/RPMS
   if [ $? -eq 0 ];then
     yum install -y libXext.x86_64
     yum groupinstall -y  "X Window System"
     rpm -Uvih *.rpm
     echo 'install desktop service ...'
     rpm -Uvih desktop-integration/openoffice4.1.6-redhat-menus-4.1.6-9790.noarch.rpm
     echo 'install finshed...'
   else
     echo 'download package error...'
   fi
}

install_ubuntu() {
   wget  https://kkfileview.keking.cn/Apache_OpenOffice_4.1.6_Linux_x86-64_install-deb_zh-CN.tar.gz  -cO openoffice_deb.tar.gz && tar zxf /tmp/openoffice_deb.tar.gz && cd /tmp/zh-CN/DEBS
   echo $?
 if [ $? -eq 0 ];then
     apt-get install -y libxrender1
     apt-get install -y libxt6
     apt-get install -y libxext-dev
     apt-get install -y libfreetype6-dev
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