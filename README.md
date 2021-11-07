# Big Data Development Environment

This project provides an WebIDE to interact with Spark and Hadoop/Hive.

# Setup

Build the docker containers using the Dockerfiles provided in the subfolders of this repo.

    $ docker build jupyter jupyter/.
    $ docker build ide ide/.
    $ docker build hadoop hadoop/.
    $ docker build spark spark/.

# Run the Cluster

    $ docker-compose up

# Access the Tools

|Container|Tool|URL|User|Password|
|-|-|-|-|-|
|ide|Theia IDE|http://localhost:3000|||
|jupyter|Jupyter Lab|http://localhost:8888|||
|hadoop|Hadoop GUI|http://localhost:9870|||
|hadoop|Hadoop Namenode|http://localhost:9000||
|spark|Spark GUI|http://localhost:8080|||
|spark|Spark Master|http://localhost:7070|||
|pgadmin4_container|Postgres GUI|http://localhost:5050|admin@admin.com|root|
|pg_container|Postgres DB|http://localhost:5432|root|root|

# Shut down the Cluster

    $ docker-compose down

# 2DO

* Create Postgres Docker
* Save Workspace on Host