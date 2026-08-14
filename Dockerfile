FROM keking/kkfileview-base:5.0.0
ADD server/target/kkFileView-*.tar.gz /opt/
ENV KKFILEVIEW_BIN_FOLDER=/opt/kkFileView-5.0.2/bin
ENTRYPOINT ["java","-Dfile.encoding=UTF-8","-Dspring.config.location=/opt/kkFileView-5.0.2/config/application.properties","-jar","/opt/kkFileView-5.0.2/bin/kkFileView-5.0.2.jar"]
