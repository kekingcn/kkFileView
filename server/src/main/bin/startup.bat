@echo off
set "KKFILEVIEW_BIN_FOLDER=%cd%"
cd "%KKFILEVIEW_BIN_FOLDER%"
echo Using KKFILEVIEW_BIN_FOLDER %KKFILEVIEW_BIN_FOLDER%
echo Starting kkFileView...
echo Please check log file in ../log/kkFileView.log for more information
echo You can get help in our official homesite: https://kkFileView.keking.cn
echo If this project is helpful to you, please star it on https://gitee.com/kekingcn/file-online-preview/stargazers
java -Dspring.config.location=..\config\application.properties -jar kkFileView-3.5.1.jar -> ..\log\kkFileView.log