# dockerfile to build image for Tomcat 8
FROM  skrishna/docker:latest

# file author / maintainer
MAINTAINER "shyam" "shyam@gmail.com"

#Changing User
USER root

# Install prepare infrastructure
RUN yum -y update && \
 yum -y install wget && \
 yum -y install tar && \
 yum -y install unzip && \
 yum install -y install gcc gcc-c++ && \
 yum install python -y && \
 curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && \
 python get-pip.py

# Installing awscli
RUN pip install awscli --upgrade
RUN aws --version

#Timezone setup to EST
RUN ln -sf /usr/share/zoneinfo/EST5EDT /etc/localtime
ENV UMASK 0022

#Starting image building process
ADD . /APP
WORKDIR /APP
RUN mkdir /opt/tomcat/tmp/ && \
    unzip application.war -d  /opt/tomcat/webapps/application/
#ADD SymJavaAPI.jar /opt/tomcat/lib
#ADD jai-codec-1.1.3.jar /opt/tomcat/lib
#ADD dynamsoft-dbr-6.2-jni.jar /opt/tomcat/lib
ADD libDynamsoftBarcodeJNI.so /opt/tomcat/tmp/
EXPOSE 8080
ADD env.sh /usr/bin/
#RUN mkdir /application/
RUN mkdir -p /application/log/ $$ \
    rm -rf /APP/* && \
    chmod 775 /usr/bin/env.sh
CMD ["/usr/bin/env.sh"]