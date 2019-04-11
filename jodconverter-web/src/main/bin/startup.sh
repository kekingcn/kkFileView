#!/bin/bash
nohup java -Dspring.config.location=../conf/application.properties -jar jodconverter-web-1.5.8.RELEASE.jar ../log/kkFileView.log 2>&1 &