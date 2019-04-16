#!/bin/bash
DIR_HOME=("/opt/openoffice.org3" "/opt/libreoffice" "/opt/openoffice4" "/usr/lib/openoffice" "/usr/lib/libreoffice")
FLAG=
OFFICE_HOME=
KKFILEVIEW_BIN_FOLDER=$(cd "$(dirname "$0")";pwd)vim
export KKFILEVIEW_BIN_FOLDER=$KKFILEVIEW_BIN_FOLDER
cd $KKFILEVIEW_BIN_FOLDER
echo "Using KKFILEVIEW_BIN_FOLDER $KKFILEVIEW_BIN_FOLDER"
grep 'office\.home' ../conf/application.properties | grep '!^#'
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
    sh ../script/install.sh
  else 
    echo "Detected office component has been installed in $OFFICE_HOME"
  fi
fi
echo "Starting kkFileView..."
echo "Please check log file for more information"
nohup java -Dspring.config.location=../conf/application.properties -jar kkFileView-0.1.jar > ../log/kkFileView.log 2>&1 &
