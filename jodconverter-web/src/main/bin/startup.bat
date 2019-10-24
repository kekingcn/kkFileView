@echo off
set "KKFILEVIEW_BIN_FOLDER=%cd%"
cd "%KKFILEVIEW_BIN_FOLDER%"
echo Using KKFILEVIEW_BIN_FOLDER %KKFILEVIEW_BIN_FOLDER%
echo Starting kkFileView...
echo Please check log file in ../log/kkFileView.log for more information
echo You can get help in our official homesite: https://kkFileView.keking.cn
echo If this project is helpful to you, please star it on https://gitee.com/kekingcn/file-online-preview/stargazers
java -Dsun.java2d.cmm=sun.java2d.cmm.kcms.KcmsServiceProvider -Dspring.config.location=..\config\application.properties -jar kkFileView-2.2.0-SNAPSHOT.jar -> ..\log\kkFileView.log