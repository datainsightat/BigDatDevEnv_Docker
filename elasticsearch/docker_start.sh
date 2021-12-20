#!/bin/sh

/etc/init.d/ssh start

#Spark
#$SPARK_HOME/sbin/start-master.sh
#$SPARK_HOME/sbin/start-slave.sh spark://localhost:7077
$SPARK_HOME/sbin/start-all.sh

#Keep Container alive
tail -f /dev/null