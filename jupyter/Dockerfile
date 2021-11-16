#This Dockerfile is based on the work of Andre Marcos Perez (https://github.com/andre-marcos-perez/spark-cluster-on-docker)

FROM ubuntu:18.04

EXPOSE 8888

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
#https://almond.sh/docs/install-versions
ENV ALMOND_VERSION="0.10.9"
ENV SPARK_VERSION="3.2.0"
ENV SPARK_HADOOP_VERSION="3.2"

ENV SPARK_HOME /opt/spark
ENV PATH="$SPARK_HOME/bin:${PATH}"
ENV PATH="$SPARK_HOME/sbin:${PATH}"
ENV PYSPARK_PYTHON=/usr/bin/python3

ENV JUPYTERLAB_VERSION="3.2.1"

###########
# GENERAL #
###########

RUN apt-get update && \
    apt-get install -y wget curl openssh-server openssh-client git net-tools

########
# JAVA #
########

RUN apt-get update && \
    apt-get -y install openjdk-$JAVA_VERSION-jdk openjdk-$JAVA_VERSION-jdk-headless && \
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

##########
# PYTHON #
##########

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get install -y python-dev python-pip \
    && apt-get install -y python3.8 python3-dev python3-pip \
    && apt-get remove -y software-properties-common \
    && python -m pip install --upgrade pip --user \
    && python3.8 -m pip install --upgrade pip --user \
    && pip3 install python-language-server flake8 autopep8

#####
# R #
#####

#https://linuxize.com/post/how-to-install-r-on-ubuntu-18-04/
RUN apt-get install -y apt-transport-https software-properties-common && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \
    apt-get update && \
    apt-get install -y r-base

###################
# Jupyter Kernels #
###################

# -- Layer: JupyterLab + Python kernel for PySpark

RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev && \
    pip3 install --upgrade pip && \
    pip3 install wget==3.2 pyspark==${SPARK_VERSION} jupyterlab==${JUPYTERLAB_VERSION}

# # -- Layer: Scala kernel for Spark

# RUN apt-get install -y ca-certificates-java --no-install-recommends && \
#     curl -Lo coursier https://git.io/coursier-cli && \
#     chmod +x coursier && \
#     ./coursier launch --fork almond:${ALMOND_VERSION} --scala ${SCALA_VERSION} -- --display-name "Scala ${SCALA_VERSION}" --install && \
#     rm -f coursier

# -- Layer: R kernel for SparkR

RUN apt-get install -y r-base-dev && \
    R -e "install.packages('IRkernel')" && \
    R -e "IRkernel::installspec(displayname = 'R 3.5', user = FALSE)" && \
    curl https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/SparkR_${SPARK_VERSION}.tar.gz -k -o sparkr.tar.gz && \
    R CMD INSTALL sparkr.tar.gz && \
    rm -f sparkr.tar.gz

##########
# FINISH #
##########

ADD docker_start.sh /docker_start.sh

#Run at container start
CMD ["/bin/bash","/docker_start.sh"]
