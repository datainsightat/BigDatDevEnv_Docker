#!/bin/sh

#Hadoop
/etc/init.d/ssh start

#$HADOOP_HOME/sbin/start-dfs.sh
#$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/start-all.sh
$HADOOP_HOME/bin/mapred --daemon start historyserver

#Keep Container alive Test
tail -f /dev/null