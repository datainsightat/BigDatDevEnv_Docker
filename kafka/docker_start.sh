#!/bin/sh

#/etc/init.d/ssh start

#Zookeeper
$KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties &

#Kafka
$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties &

#Kafka

#Keep Container alive
tail -f /dev/null