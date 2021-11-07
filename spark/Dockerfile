#https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md#prerequisites
#https://github.com/theia-ide/theia-apps

FROM ubuntu:18.04 as common


#Spark
EXPOSE 8080 7077 8081


ENV DEBIAN_FRONTEND noninteractive

ENV JAVA_VERSION=11
ENV JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:${PATH}"

ARG NODE_VERSION=12.18.3
ENV NODE_VERSION $NODE_VERSION
ENV YARN_VERSION 1.22.5

ENV SCALA_HADOOP_VERSION="3.2"
ENV SCALA_VERSION="2.12.10"
ENV SPARK_VERSION="3.0.0"

ENV SPARK_HOME /opt/spark
ENV PATH="$SPARK_HOME/bin:${PATH}"
ENV PATH="$SPARK_HOME/sbin:${PATH}"
ENV PYSPARK_PYTHON=/usr/bin/python3

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

# Spark
#https://phoenixnap.com/kb/install-spark-on-ubuntu
RUN curl -O https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$SCALA_HADOOP_VERSION.tgz && \
    tar xvf spark-$SPARK_VERSION-bin-hadoop$SCALA_HADOOP_VERSION.tgz && \
    mv spark-$SPARK_VERSION-bin-hadoop$SCALA_HADOOP_VERSION/ $SPARK_HOME && \
    rm spark-$SPARK_VERSION-bin-hadoop$SCALA_HADOOP_VERSION.tgz

# Scala
RUN curl https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.deb -k -o scala.deb && \
    apt-get install -y ./scala.deb && \
    rm -rf scala.deb /var/lib/apt/lists/*

# Python 3
RUN apt-get update && \
    apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get install -y python-dev python-pip \
    && apt-get install -y python3.8 python3-dev python3-pip \
    && apt-get remove -y software-properties-common \
    && python -m pip install --upgrade pip --user \
    && python3.8 -m pip install --upgrade pip --user \
    && pip3 install python-language-server flake8 autopep8

# # R
# #https://linuxize.com/post/how-to-install-r-on-ubuntu-18-04/
RUN apt-get update && \
    apt-get install -y apt-transport-https software-properties-common && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \
    apt-get update && \
    apt-get install -y r-base

#ADD docker_init.sh /
ADD docker_start.sh /

#ENTRYPOINT ["bin/bash","docker_init.sh"]

#Run during container build
#RUN ["bin/bash","docker_init.sh"]

#Run at container start
CMD ["bin/bash","docker_start.sh"]