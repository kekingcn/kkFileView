#!/bin/bash
KKFILEVIEW_BIN_FOLDER=$(cd "$(dirname "$0")";pwd)
export KKFILEVIEW_BIN_FOLDER=$KKFILEVIEW_BIN_FOLDER
cd $KKFILEVIEW_BIN_FOLDER
echo "Using KKFILEVIEW_BIN_FOLDER $KKFILEVIEW_BIN_FOLDER"
echo "Starting kkFileView..."
echo "Please check log file for more information"
nohup java -Dspring.config.location=../conf/application.properties -jar jodconverter-web-1.5.8.RELEASE.jar ../log/kkFileView.log 2>&1 &