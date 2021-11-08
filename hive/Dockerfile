#https://hadooptutorials.info/2020/10/05/part-1-apache-hadoop-installation-on-single-node-cluster-with-google-cloud-virtual-machine/
#https://hadooptutorials.info/2020/10/11/part-3-install-hive-on-hadoop/

FROM ubuntu:20.04

EXPOSE 5349 5249 9870

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
ENV CLASSPATH=$CLASSPATH:$HADOOP_HOME/lib/*:.
ENV CLASSPATH=$CLASSPATH:$HIVE_HOME/lib/*:.

# RUN useradd -ms /bin/bash hadoop_user && \
#     usermod -aG sudo hadoop_user && \
#     su - hadoop_user

###########
# GENERAL #
###########

RUN apt-get update && \
    apt-get install -y wget openssh-server openssh-client && \
    /etc/init.d/ssh start

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

# Create SSH key

ADD ssh/config ~/.ssh/config

RUN ssh-keygen -q -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# ADD hadoop_start.sh /hadoop_start.sh
# RUN ./hadoop_start.sh

# RUN /etc/init.d/ssh start && \
#     $HADOOP_HOME/sbin/start-dfs.sh && \
#     $HADOOP_HOME/sbin/start-yarn.sh && \
#     $HADOOP_HOME/bin/mapred --daemon start historyserver

########
# HIVE #
########

RUN wget https://dlcdn.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
    tar xvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
    mv apache-hive-$HIVE_VERSION-bin/ $HIVE_HOME && \
    rm apache-hive-$HIVE_VERSION-bin.tar.gz

ADD hive/* $HIVE_HOME/conf/

RUN chmod +x $HIVE_HOME/conf/hive-env.sh

RUN rm $HIVE_HOME/lib/guava* && \
    cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava* $HIVE_HOME/lib/

##########
# FINISH #
##########

#Run at container start
ADD docker_init.sh /docker_init.sh
ADD docker_start.sh /docker_start.sh

#Run during container build
RUN ["bin/bash","docker_init.sh"]

#Run at container start
CMD ["bin/bash","docker_start.sh"]