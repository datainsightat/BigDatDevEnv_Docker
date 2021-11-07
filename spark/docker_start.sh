#!/bin/sh

/etc/init.d/ssh start

#Spark
#start-master.sh
#start-slave.sh -m 512M spark://localhost:7077
$SPARK_HOME/sbin/start-all.sh

#Keep Container alive
tail -f /dev/null