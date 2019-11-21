FROM centos:centos7.6.1810
MAINTAINER chenjh "842761733@qq.com"
ADD jodconverter-web/target/kkFileView-*.tar.gz /opt/
COPY fonts/* /usr/share/fonts/chienes/
RUN yum install -y kde-l10n-Chinese &&\
	yum install -y glibc-common &&\
	yum install -y fontconfig &&\
	yum install -y mkfontscale &&\
	localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 &&\
	echo "LANG=zh_CN.UTF-8" > /etc/locale.conf &&\
	source /etc/locale.conf &&\
	export LANG=zh_CN.UTF-8 &&\
	LANG="zh_CN.UTF-8" &&\
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
	yum install -y java-1.8.0-openjdk.x86_64 &&\
	yum install -y wget &&\
	yum install -y libXext.x86_64 &&\
	yum groupinstall -y  "X Window System" &&\
	cd /tmp &&\
	wget https://kkfileview.keking.cn/Apache_OpenOffice_4.1.6_Linux_x86-64_install-rpm_zh-CN.tar.gz -cO openoffice_rpm.tar.gz &&\
	tar zxf /tmp/openoffice_rpm.tar.gz &&\
	cd /tmp/zh-CN/RPMS &&\
	rpm -Uvih *.rpm &&\
	rpm -Uvih desktop-integration/openoffice4.1.6-redhat-menus-4.1.6-9790.noarch.rpm &&\
	rm -f /tmp/openoffice_rpm.tar.gz &&\
	rm -rf /tmp/zh-CN &&\
	cd /usr/share/fonts/chienes &&\
	mkfontscale &&\
	mkfontdir &&\
	fc-cache -fv
ENV LANG zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV KKFILEVIEW_BIN_FOLDER /opt/kkFileView-2.2.0-SNAPSHOT/bin
ENTRYPOINT ["java","-Dfile.encoding=UTF-8","-Dsun.java2d.cmm=sun.java2d.cmm.kcms.KcmsServiceProvider","-Dspring.config.location=/opt/kkFileView-2.2.0-SNAPSHOT/config/application.properties","-jar","/opt/kkFileView-2.2.0-SNAPSHOT/bin/kkFileView-2.2.0-SNAPSHOT.jar"]