# Big Data Development Environment

This project provides an WebIDE to interact with Spark and Hadoop/Hive.

# Cluster

## Setup

Build the docker containers using the Dockerfiles provided in the subfolders of this repo.

    $ docker build -t jupyter jupyter/.
    $ docker build -t ide ide/.
    $ docker build -t hadoop hadoop/.
    $ docker build -t spark spark/.

## Run Cluster
öls
    $ docker-compose up

## Access the Tools

|Container|Tool|URL|User|Password|
|-|-|-|-|-|
|ide|Theia IDE|http://localhost:3000|||
|jupyter|Jupyter Lab|http://localhost:8888|||
|hadoop|Hadoop GUI|http://localhost:9870|||
|hadoop|Hadoop Namenode|http://localhost:9000||
|hadoop|Hadoop Applications GUI|http://localhost:8088||
|spark|Spark GUI|http://localhost:8080|||
|spark|Spark Master|http://localhost:7070|||
|pgadmin4_container|Postgres GUI|http://localhost:5050|admin@admin.com|root|
|pg_container|Postgres DB|http://localhost:5432|root|root|

## Shut down Cluster

    $ docker-compose down

## Examples

Get some usage examples from [this](https://github.com/datainsightat/scala_examples.git) git repo.

# Postgres

## Create Server

[Postgres GUI](http://localhost:5432) > Add New Server:

    General:
        Name: newserver
    Connection:
        Host: pg_container
        Username: root
        Password: root

# Hadoop

## Browse hdfs

    $ docker container exec hadoop hdfs dfs -ls /

## Create directory

    $ docker container exec hadoop hdfs dfs -mkdir /data

## Upload file to hdfs

    $ docker cp file.csv hadoop:/
    $ docker container exec hadoop hdfs dfs -put file.csv /data/
    $ docker container exec hadoop rm file.csv

# 2DO

* Create Postgres Docker
* Save Workspace on Host
* Hadoop GUI cannot upload csv