# Big Data Development Environment

This project provides an WebIDE to interact with Spark and Hadoop/Hive.

# Cluster

## Architecture

![cluster Architectue](resources/img/Architecture.drawio.svg)

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

### service Ports
|Container|Tool|URL|User|Password|
|-|-|-|-|-|
|hadoop|Default FS|http://hive:54310|||
|pg_container|Postgres DB|http://pg_container:5432|root|root|
|spark|Spark Master|http://spark:7077|||

### Web GUI Ports
|Container|Tool|URL|User|Password|
|-|-|-|-|-|
|theia|Theia IDE|http://localhost:3000|||
|jupyter|Jupyter Lab|http://localhost:8888|||
|jupyter|sparkr-notebook application UI|http://localhost:4040|||
|hadoop|NameNode|http://localhost:9870|||
|hadoop|Yarn RM web application|http://localhost:5349|||
|spark|Spark Master GUI|http://localhost:8080|||
|spark|Spark Worker GUI|http://localhost:8081|||
|pgadmin4_container|Postgres GUI|http://localhost:5050|admin@admin.com|root|

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

# Hive

## Create hive Table

    $ docker container exec -it hive bash
    hive$ hive
    hive> create table if not exists employee (id string, name string, dept string);
    hive> show tables;
    hive> insert into employee values("1","Allen","IT");
    hive> select * from employee;

# Examples

You can find some templates [here](https://github.com/datainsightat/scala_examples)

# 2DO

* Create Postgres Docker
* Split Spark, Theia, Jupyter > Base / Service
* Hadoop GUI cannot upload csv
* R Pipeline