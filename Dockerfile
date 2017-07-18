FROM centos:centos6


RUN yum -y update;
RUN yum -y clean all;


#Intsall tools which are required
RUN yum install -y  wget dialog curl sudo lsof vim axel telnet nano openssh-server openssh-clients bzip2 passwd tar bc git unzip


#Install Java
RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel


#Create pipeline-admin user.
RUN useradd pipeline-admin -u 1000
RUN echo pipeline-admin | passwd pipeline-admin --stdin

ENV HOME /home/pipeline-admin






USER root
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.0.tar.gz
RUN tar xvzf elasticsearch-5.4.0.tar.gz
RUN mv elasticsearch-5.4.0 /home/pipeline-admin/elasticsearch
RUN chown -R pipeline-admin:pipeline-admin /home/pipeline-admin/elasticsearch
RUN chown pipeline-admin:pipeline-admin /home/pipeline-admin/elasticsearch/config/elasticsearch.yml



ADD logs /home/pipeline-admin/logs
RUN chown -R pipeline-admin:pipeline-admin /home/pipeline-admin/logs

ADD EventLogInterceptor.jar /home/pipeline-admin/EventLogInterceptor.jar
RUN chown pipeline-admin:pipeline-admin /home/pipeline-admin/EventLogInterceptor.jar
RUN chmod +x /home/pipeline-admin/EventLogInterceptor.jar

ADD data-creation.sh /home/pipeline-admin/data-creation.sh
RUN chown pipeline-admin:pipeline-admin /home/pipeline-admin/data-creation.sh

RUN chmod +x /home/pipeline-admin/data-creation.sh

ADD startup.sh /home/pipeline-admin/startup.sh
RUN chown pipeline-admin:pipeline-admin /home/pipeline-admin/startup.sh
RUN chmod +x /home/pipeline-admin/startup.sh

USER pipeline-admin

CMD ["/home/pipeline-admin/startup.sh", "/home/pipeline-admin/logs","/home/pipeline-admin"]
