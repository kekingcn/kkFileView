FROM maven:3.5.2-jdk-8-alpine as builder

# 添加 Aliyun Maven 镜像
RUN mkdir -p /root/.m2
RUN echo '<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" \
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" \
        xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 \
                            https://maven.apache.org/xsd/settings-1.0.0.xsd"> \
    <mirrors> \
        <mirror> \
            <id>alimaven</id> \
            <name>aliyun maven</name> \
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url> \
            <mirrorOf>central</mirrorOf> \
        </mirror> \
    </mirrors> \
</settings>' > /root/.m2/settings.xml
ENV MAVEN_CONFIG=/root/.m2

WORKDIR /kkFileView
COPY . .
RUN mvn clean package -DskipTests -Prelease


FROM keking/kkfileview-base:4.4.0
COPY --from=builder /kkFileView/server/target/kkFileView-*.tar.gz /opt/
RUN tar -xzf /opt/kkFileView-*.tar.gz -C /opt && rm /opt/kkFileView-*.tar.gz
ENV KKFILEVIEW_BIN_FOLDER=/opt/kkFileView-4.4.0-beta/bin
ENTRYPOINT ["java","-Dfile.encoding=UTF-8","-Dspring.config.location=/opt/kkFileView-4.4.0-beta/config/application.properties","-jar","/opt/kkFileView-4.4.0-beta/bin/kkFileView-4.4.0-beta.jar"]
