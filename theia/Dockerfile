#https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md#prerequisites
#https://github.com/theia-ide/theia-apps

FROM ubuntu:18.04

EXPOSE 3000

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV DEBIAN_FRONTEND noninteractive

ENV JAVA_VERSION=11
ENV JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:${PATH}"

ARG NODE_VERSION=12.18.3
ENV NODE_VERSION $NODE_VERSION
ENV YARN_VERSION 1.22.5

ENV SCALA_VERSION="2.12.14"
ENV SPARK_VERSION="3.2.0"
ENV SPARK_HADOOP_VERSION="3.2"
ENV POSTGRES_JDBC_VERSION="42.3.1"

ENV SPARK_HOME /opt/spark
ENV PATH="$SPARK_HOME/bin:${PATH}"
ENV PATH="$SPARK_HOME/sbin:${PATH}"
ENV PYSPARK_PYTHON=/usr/bin/python3

ENV SHELL=/bin/bash
ENV THEIA_DEFAULT_PLUGINS=local-dir:/home/theia/plugins
ENV GOPATH=/home/project

###########
# GENERAL #
###########

RUN apt-get update && \
    apt-get -y install build-essential curl git wget xz-utils libsecret-1-dev libsecret-1-0 net-tools

##############
# NODE, YARN #
##############

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz"  && \
    tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 --no-same-owne && \
    rm "node-v$NODE_VERSION-linux-x64.tar.xz" && \
    ln -s /usr/local/bin/node /usr/local/bin/nodejs

RUN curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz"  && \
    mkdir -p /opt/yarn && \
    tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 && \
    ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn && \
    ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg && \
    rm yarn-v$YARN_VERSION.tar.gz

########
# JAVA #
########

RUN apt-get update && \
    apt-get -y install openjdk-$JAVA_VERSION-jdk openjdk-$JAVA_VERSION-jdk-headless maven gradle && \
    ln -s /lib64/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2

#########
# SCALA #
#########

RUN wget https://scala-lang.org/files/archive/scala-${SCALA_VERSION}.deb && \
    apt-get install -y ./scala-${SCALA_VERSION}.deb && \
    rm -rf scala-${SCALA_VERSION}.deb /var/lib/apt/lists/*

#########
# SPARK #
#########

#https://phoenixnap.com/kb/install-spark-on-ubuntu
RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz && \
    tar xvf spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz && \
    mv spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION/ $SPARK_HOME && \
    rm spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz

############
# POSTGRES #
############

RUN wget https://jdbc.postgresql.org/download/postgresql-$POSTGRES_JDBC_VERSION.jar && \
    mv postgresql-$POSTGRES_JDBC_VERSION.jar $SPARK_HOME/jars

##########
# PYTHON #
##########

RUN apt-get update -y \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get install -y python-dev python-pip \
    && apt-get install -y python3.8 python3-dev python3-pip libpq-dev \
    && apt-get remove -y software-properties-common \
    && python -m pip install --upgrade pip --user \
    && python3.8 -m pip install --upgrade pip --user \
    && pip3 install python-language-server flake8 autopep8 pyspark==${SPARK_VERSION} pandas psycopg2
    #python3-psycopg2 libpq-dev 

#####
# R #
#####

#https://linuxize.com/post/how-to-install-r-on-ubuntu-18-04/
RUN apt-get install -y apt-transport-https software-properties-common libcurl4-gnutls-dev libxml2-dev libssl-dev && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \
    apt-get update && \
    apt-get install -y r-base

#########
# THEIA #
#########

WORKDIR /home/theia

ADD theia/latest.package.json /home/theia/package.json

RUN yarn --cache-folder ./ycache && rm -rf ./ycache && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && yarn theia download:plugins

RUN chmod g+rw /home && \
    mkdir -p /home/project && \
    mkdir -p /home/theia/.pub-cache/bin && \
    mkdir -p /usr/local/cargo

# Theia application
RUN apt-get clean && \
  apt-get autoremove -y && \
  rm -rf /var/cache/apt/* && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp/*

##########
# FINISH #
##########

ADD docker_start.sh /docker_start.sh
ADD spark/spark-env.sh $SPARK_HOME/conf/spark-env.sh

#Run at container start
CMD ["/bin/bash","/docker_start.sh"]