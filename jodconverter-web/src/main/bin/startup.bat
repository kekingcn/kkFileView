@echo off
set "KKFILEVIEW_BIN_FOLDER=%cd%"
cd "%KKFILEVIEW_BIN_FOLDER%"
echo Using KKFILEVIEW_BIN_FOLDER %KKFILEVIEW_BIN_FOLDER%
echo Starting kkFileView...
echo Please check log file for more information
java -Dsun.java2d.cmm=sun.java2d.cmm.kcms.KcmsServiceProvider -Dspring.config.location=..\conf\application.properties -jar kkFileView-2.0.2.jar -> ..\log\kkFileView.log