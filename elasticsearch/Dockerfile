#https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md#prerequisites
#https://github.com/theia-ide/theia-apps
#https://hadooptutorials.info/2020/10/11/part-4-install-spark-2/

FROM ubuntu:20.04 as common

#Spark
EXPOSE 8080 7077 8081 7000

ENV DEBIAN_FRONTEND noninteractive

ENV JAVA_VERSION=8
ENV JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:${PATH}"

ENV SCALA_VERSION="2.12.14"

ENV ES_VERSION="7.16.2"
ENV ES_HOME=/opt/elasticsearch
ENV PATH="$ES_HOME/bin:${PATH}"

ENV SSH_USER="root"

###########
# GENERAL #
###########

RUN apt-get update && \
    apt-get install -y wget openssh-server openssh-client net-tools

########
# JAVA #
########

RUN apt-get update && \
    apt-get -y install openjdk-$JAVA_VERSION-jdk openjdk-$JAVA_VERSION-jdk-headless

#########
# SCALA #
#########

RUN wget https://scala-lang.org/files/archive/scala-${SCALA_VERSION}.deb && \
    apt-get install -y ./scala-${SCALA_VERSION}.deb && \
    rm -rf scala-${SCALA_VERSION}.deb /var/lib/apt/lists/*

################
# ELASTISEARCH #
################

#https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_VERSION-linux-x86_64.tar.gz && \
    tar xvf elasticsearch-$ES_VERSION-linux-x86_64.tar.gz && \
    mv elasticsearch-$ES_VERSION/ $ES_HOME && \
    rm elasticsearch-$ES_VERSION-linux-x86_64.tar.gz
    # && \
    #cd $ES_HOME/ 

##########
# FINISH #
##########

# Create SSH key

RUN /etc/init.d/ssh start

ADD ssh/config root/.ssh/config

RUN ssh-keygen -q -t rsa -P '' -f $SSH_USER/.ssh/id_rsa && \
    cat $SSH_USER/.ssh/id_rsa.pub >> $SSH_USER/.ssh/authorized_keys && \
    chmod 0600 $SSH_USER/.ssh/authorized_keys

ADD docker_start.sh /

#Run at container start
#CMD ["bin/bash","docker_start.sh"]