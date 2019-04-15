#!/bin/bash
KKFILEVIEW_BIN_FOLDER=$(cd "$(dirname "$0")";pwd)
export KKFILEVIEW_BIN_FOLDER=$KKFILEVIEW_BIN_FOLDER
cd $KKFILEVIEW_BIN_FOLDER
echo "Using KKFILEVIEW_BIN_FOLDER $KKFILEVIEW_BIN_FOLDER"
echo "Starting kkFileView..."
echo "Please check log file for more information"
nohup java -Dspring.config.location=../conf/application.properties -jar kkFileView-0.1.jar ../log/kkFileView.log 2>&1 &