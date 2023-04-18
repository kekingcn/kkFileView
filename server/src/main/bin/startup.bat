@echo off
set "KKFILEVIEW_BIN_FOLDER=%cd%"
cd "%KKFILEVIEW_BIN_FOLDER%"
echo Using KKFILEVIEW_BIN_FOLDER %KKFILEVIEW_BIN_FOLDER%
echo Starting kkFileView...
echo Please check log file in ../log/kkFileView.log for more information
echo You can get help in our official home site: https://kkview.cn
echo If you need further help, please join our kk opensource community: https://t.zsxq.com/09ZHSXbsQ
echo If this project is helpful to you, please star it on https://gitee.com/kekingcn/file-online-preview/stargazers
java -Dspring.config.location=..\config\application.properties -jar kkFileView-4.2.1.jar -> ..\log\kkFileView.log
