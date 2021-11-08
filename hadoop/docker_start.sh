#!/bin/sh

#Hadoop
/etc/init.d/ssh start

#$HADOOP_HOME/sbin/start-dfs.sh
#$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/start-all.sh

#Keep Container alive
tail -f /dev/null