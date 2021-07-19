#!/bin/bash
DIR_HOME=("/opt/openoffice.org3" "/opt/libreoffice" "/opt/libreoffice6.1" "/opt/libreoffice7.0" "/opt/libreoffice7.1" "/opt/openoffice4" "/usr/lib/openoffice" "/usr/lib/libreoffice" "/usr/lib64/libreoffice")
FLAG=
OFFICE_HOME=
KKFILEVIEW_BIN_FOLDER=$(cd "$(dirname "$0")";pwd)
export KKFILEVIEW_BIN_FOLDER=$KKFILEVIEW_BIN_FOLDER
cd $KKFILEVIEW_BIN_FOLDER
echo "Using KKFILEVIEW_BIN_FOLDER $KKFILEVIEW_BIN_FOLDER"
grep 'office\.home' ../config/application.properties | grep '!^#'
if [ $? -eq 0 ]; then
  echo "Using customized office.home"
else 
 for i in ${DIR_HOME[@]}
  do
    if [ -f $i"/program/soffice.bin" ]; then
      FLAG=true
      OFFICE_HOME=${i}
      break
    fi
  done
  if [ ! -n "${FLAG}" ]; then
    echo "Installing OpenOffice"
    sh ./install.sh
  else 
    echo "Detected office component has been installed in $OFFICE_HOME"
  fi
fi
echo "Starting kkFileView..."
echo "Please execute ./showlog.sh to check log for more information"
echo "You can get help in our official homesite: https://kkFileView.keking.cn"
echo "If this project is helpful to you, please star it on https://gitee.com/kekingcn/file-online-preview/stargazers"
nohup java -Dfile.encoding=UTF-8 -Dspring.config.location=../config/application.properties -jar kkFileView-4.0.0.jar > ../log/kkFileView.log 2>&1 &
