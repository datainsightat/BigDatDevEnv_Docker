#https://hadooptutorials.info/2020/10/05/part-1-apache-hadoop-installation-on-single-node-cluster-with-google-cloud-virtual-machine/
#https://hadooptutorials.info/2020/10/11/part-3-install-hive-on-hadoop/

FROM ubuntu:20.04

#Hadoop
EXPOSE 54310 54311 9870 5349 5259

#Hive
EXPOSE 10000 9999 9083

ENV DEBIAN_FRONTEND noninteractive

ENV JAVA_VERSION=8
ENV JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:${PATH}"

ENV HADOOP_VERSION="3.2.2"
ENV HADOOP_HOME=/opt/hadoop
ENV PATH="$HADOOP_HOME/bin:${PATH}"
ENV PATH="$HADOOP_HOME/sbin:${PATH}"
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"
ENV YARN_NODEMANAGER_USER="root"
ENV HADOOP_YARN_HOME=$HADOOP_HOME

ENV HIVE_VERSION="3.1.2"
ENV HIVE_HOME /opt/hive
ENV PATH="$HIVE_HOME/bin:${PATH}"
# ENV CLASSPATH=$CLASSPATH:$HADOOP_HOME/lib/*:.
# ENV CLASSPATH=$CLASSPATH:$HIVE_HOME/lib/*:.

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

##########
# HADOOP #
##########

RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    tar xvf hadoop-$HADOOP_VERSION.tar.gz && \
    mv hadoop-$HADOOP_VERSION/ $HADOOP_HOME && \
    rm hadoop-$HADOOP_VERSION.tar.gz

#Add Hadoop configuration files

ADD hadoop/* $HADOOP_CONF_DIR/

RUN mkdir -p $HADOOP_HOME/hadoop_data/hdfs/namenode && \
    mkdir -p $HADOOP_HOME/hadoop_data/hdfs/datanode

#Fix Maven bug
RUN wget https://repo1.maven.org/maven2/org/apache/htrace/htrace-core4/4.0.1-incubating/htrace-core4-4.0.1-incubating.jar && \
    mv htrace-core4-4.0.1-incubating.jar $HADOOP_HOME/lib
    #rm htrace-core4-4.0.1-incubating.jar

########
# HIVE #
########

RUN wget https://dlcdn.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
    tar xvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
    mv apache-hive-$HIVE_VERSION-bin/ $HIVE_HOME && \
    rm apache-hive-$HIVE_VERSION-bin.tar.gz

ADD hive/* $HIVE_HOME/conf/
ADD hive/* $SPARK_HOME/conf/

RUN chmod +x $HIVE_HOME/conf/hive-env.sh
RUN chmod +x $SPARK_HOME/conf/hive-env.sh

RUN rm $HIVE_HOME/lib/guava* && \
    cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava* $HIVE_HOME/lib/

##########
# FINISH #
##########

# Create SSH key

RUN /etc/init.d/ssh start

ADD ssh/config root/.ssh/config

RUN ssh-keygen -q -t rsa -P '' -f $SSH_USER/.ssh/id_rsa && \
    cat $SSH_USER/.ssh/id_rsa.pub >> $SSH_USER/.ssh/authorized_keys && \
    chmod 0600 $SSH_USER/.ssh/authorized_keys

#Run at container start
ADD docker_init.sh /docker_init.sh
ADD docker_start.sh /docker_start.sh

RUN mkdir /data
ADD data/* /data/

#Run during container build
RUN ["bin/bash","docker_init.sh"]

#Run at container start
CMD ["bin/bash","docker_start.sh"]