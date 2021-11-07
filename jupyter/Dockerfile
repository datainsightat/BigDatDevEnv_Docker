#This Dockerfile is based on the work of Andre Marcos Perez (https://github.com/andre-marcos-perez/spark-cluster-on-docker)

FROM ubuntu:20.04

LABEL mantainer="Bernhard Mayrhofer <bernhard@mayrhofer.email>"

#ENV JAVA_VERSION=java-1.8.0-openjdk
#ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV JAVA_VERSION=java-1.11.0-openjdk
ENV JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64

ENV HADOOP_VERSION="3.2"
ENV SCALA_VERSION="2.12.10"
ENV SCALA_KERNEL_VERSION="0.10.9"
ENV SPARK_VERSION="3.0.0"
ENV JUPYTERLAB_VERSION="3.2.1"

ENV DEBIAN_FRONTEND=noninteractive

ENV SCALA_HOME="/usr/bin/scala"
ENV PATH=${PATH}:${SCALA_HOME}/bin
ENV SHARED_WORKSPACE=/opt/workspace

# -- Layer: Image Metadata

LABEL org.label-schema.name="Apache Spark Standalone Cluster on Docker - Cluster Base Image"
LABEL org.label-schema.description="Cluster base image shipped with Python, Scala and a shared workspace folder"
LABEL org.label-schema.url="https://github.com/datainsightat/docker-hadoop-spark.git"
LABEL org.label-schema.schema-version="0.1"

# Install Java

RUN apt-get update -y && \
    #apt-get install -y --no-install-recommends openjdk-8-jdk && \
    apt-get install -y --no-install-recommends openjdk-11-jdk && \
    ln -s /lib64/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2

# -- Layer: OS + Python + Scala + R

RUN mkdir -p ${SHARED_WORKSPACE}/data && \
    mkdir -p /usr/share/man/man1 && \
    apt-get update -y && \
    apt-get install -y curl python3 r-base && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    curl https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.deb -k -o scala.deb && \
    apt install -y ./scala.deb && \
    rm -rf scala.deb /var/lib/apt/lists/*

# -- Runtime

VOLUME ${SHARED_WORKSPACE}

# -- Layer: Notebooks and data

#ADD workspace/ ${SHARED_WORKSPACE}/

# -- Layer: JupyterLab + Python kernel for PySpark

RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev && \
    pip3 install --upgrade pip && \
    pip3 install wget==3.2 pyspark==${SPARK_VERSION} jupyterlab==${JUPYTERLAB_VERSION}

# -- Layer: Scala kernel for Spark

#ARG scala_version

RUN apt-get install -y ca-certificates-java --no-install-recommends && \
    curl -Lo coursier https://git.io/coursier-cli && \
    chmod +x coursier && \
    ./coursier launch --fork almond:${SCALA_KERNEL_VERSION} --scala ${SCALA_VERSION} -- --display-name "Scala ${SCALA_VERSION}" --install && \
    rm -f coursier

# -- Layer: R kernel for SparkR

RUN apt-get install -y r-base-dev && \
    R -e "install.packages('IRkernel')" && \
    R -e "IRkernel::installspec(displayname = 'R 3.5', user = FALSE)" && \
    curl https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/SparkR_${SPARK_VERSION}.tar.gz -k -o sparkr.tar.gz && \
    R CMD INSTALL sparkr.tar.gz && \
    rm -f sparkr.tar.gz

# -- Runtime

EXPOSE 8888

WORKDIR ${SHARED_WORKSPACE}

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=
