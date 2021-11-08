#https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md#prerequisites
#https://github.com/theia-ide/theia-apps

FROM ubuntu:18.04 as common

#Hadoop
EXPOSE 9870 9000 9864

#Hive
EXPOSE 10000 9999 9083


ENV DEBIAN_FRONTEND noninteractive

ENV JAVA_VERSION=8
ENV JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:${PATH}"

ENV HADOOP_VERSION="3.2.2"
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_INSTALL=$HADOOP_HOME
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
#ENV PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
ENV PATH="$HADOOP_HOME/sbin:${PATH}"
ENV PATH="$HADOOP_HOME/bin:${PATH}"
#ENV HADOOP_OPTS"-Djava.library.path=$HADOOP_HOME/lib/nativ"
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"
ENV YARN_NODEMANAGER_USER="root"

ENV HIVE_VERSION="3.1.2"
ENV HIVE_HOME /opt/hive
ENV PATH="$HIVE_HOME/bin:${PATH}"

ENV SHARED_WORKSPACE=/opt/workspace

# Common deps
RUN apt-get update && \
    apt-get -y install build-essential \
                       curl \
                       git \
                       gpg \
                       python \
                       wget \
                       xz-utils \
                       sudo \
                       libsecret-1-0 \
                       libsecret-1-dev \
                       nano \
                       openssh-server openssh-client \
                       ca-certificates

# Create SSH key

ADD ssh/config ~/.ssh/config

RUN ssh-keygen -q -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# Developer tools

# Java
RUN apt-get -y install openjdk-$JAVA_VERSION-jdk openjdk-$JAVA_VERSION-jdk-headless maven gradle

# Hadoop
#https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Standalone_Operation
#https://phoenixnap.com/kb/install-hadoop-ubuntu
RUN curl -O https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    tar xvf hadoop-$HADOOP_VERSION.tar.gz && \
    mv hadoop-$HADOOP_VERSION/ $HADOOP_HOME && \
    rm hadoop-$HADOOP_VERSION.tar.gz

ADD hadoop/* $HADOOP_HOME/etc/hadoop/

# Hive
#https://cwiki.apache.org/confluence/display/Hive/GettingStarted
#https://phoenixnap.com/kb/install-hive-on-ubuntu
RUN curl -O https://dlcdn.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
    tar xvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
    mv apache-hive-$HIVE_VERSION-bin/ $HIVE_HOME && \
    rm apache-hive-$HIVE_VERSION-bin.tar.gz

ADD hive/hive-config.sh $HIVE_HOME/bin/hive-config.sh
ADD hive/hive-site.xml $HIVE_HOME/conf/hive-site.xml

RUN rm $HIVE_HOME/lib/guava* && \
    cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava* $HIVE_HOME/lib/

ADD docker_init.sh /
ADD docker_start.sh /

#ENTRYPOINT ["bin/bash","docker_init.sh"]

#Run during container build
RUN ["bin/bash","docker_init.sh"]

#Run at container start
CMD ["bin/bash","docker_start.sh"]