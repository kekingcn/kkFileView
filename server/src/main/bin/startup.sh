#!/bin/bash
#
#
#############################
# First_Author:  凯京科技
# Second_Author:  sanxi
# Version: 1.1
# Date:    2021/09/17
# Description:  v1.1：修改进程启动机制为pid形式。
#############################
#
DIR_HOME=("/opt/openoffice.org3" "/opt/libreoffice" "/opt/libreoffice6.1" "/opt/libreoffice7.0" "/opt/libreoffice7.1" "/opt/libreoffice7.2" "/opt/libreoffice7.3" "/opt/libreoffice7.4" "/opt/libreoffice7.5" "/opt/libreoffice7.6" "/opt/openoffice4" "/usr/lib/openoffice" "/usr/lib/libreoffice")
FLAG=
OFFICE_HOME=
KKFILEVIEW_BIN_FOLDER=$(cd "$(dirname "$0")" || exit 1 ;pwd)
PID_FILE_NAME="kkFileView.pid"
PID_FILE="${KKFILEVIEW_BIN_FOLDER}/${PID_FILE_NAME}"
MEMORY_LIMIT="2048"
export KKFILEVIEW_BIN_FOLDER=$KKFILEVIEW_BIN_FOLDER
AVAILABLE_MEMORY=$(echo "$(free -m)" | awk '/Mem:/ { print $7 }')
if [ "$AVAILABLE_MEMORY" -lt "2048" ]; then
  echo "Your system current available memory is: ${AVAILABLE_MEMORY}MB, not enough for run kkFileView (minimum 2048MB)"
  exit 1
elif [ "$AVAILABLE_MEMORY" -gt "3072" ]; then
  MEMORY_LIMIT="3072"
fi
JVM_OPTS="-Dfile.encoding=UTF-8 -Xms${MEMORY_LIMIT}M -Xmx${MEMORY_LIMIT}M"

## 如pid文件不存在则自动创建
if [ ! -f ${PID_FILE_NAME} ]; then
  touch "${KKFILEVIEW_BIN_FOLDER}/${PID_FILE_NAME}"
fi
## 判断当前是否有进程处于运行状态
if [ -s "${PID_FILE}" ]; then
  PID=$(cat "${PID_FILE}")
  echo "进程已处于运行状态，进程号为：${PID}"
  exit 1
else
  cd "$KKFILEVIEW_BIN_FOLDER" || exit 1
  echo "Using KKFILEVIEW_BIN_FOLDER $KKFILEVIEW_BIN_FOLDER"
  grep 'office\.home' ../config/application.properties | grep '!^#'
  if [ $? -eq 0 ]; then
    echo "Using customized office.home"
  else
  for i in ${DIR_HOME[@]}
    do
      if [ -f "$i/program/soffice.bin" ]; then
        FLAG=true
        OFFICE_HOME=${i}
        break
      fi
    done
    if [ ! -n "${FLAG}" ]; then
      echo "Installing LibreOffice"
      sh ./install.sh
    else
      echo "Detected office component has been installed in $OFFICE_HOME"
    fi
  fi

  ## 启动kkFileView
  echo "Starting kkFileView..."
  nohup java $JVM_OPTS -Dspring.config.location=../config/application.properties -jar kkFileView-4.4.0-SNAPSHOT.jar > ../log/kkFileView.log 2>&1 &
  echo "Please execute ./showlog.sh to check log for more information"
  echo "You can get help in our official home site: https://kkview.cn"
  echo "If you need further help, please join our kk opensource community: https://t.zsxq.com/09ZHSXbsQ"
  echo "If this project is helpful to you, please star it on https://gitee.com/kekingcn/file-online-preview/stargazers"
  PROCESS=$(ps -ef | grep -v grep | grep java | grep kkFileView | awk 'NR==1{print $2}')
  # 启动成功后将进程号写入pid文件
  echo "$PROCESS" > "$PID_FILE"
fi
