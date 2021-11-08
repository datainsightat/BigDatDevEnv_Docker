#!/bin/sh

#Hadoop
/etc/init.d/ssh start

echo 'Y' | $HADOOP_HOME/bin/hdfs namenode -format

#$HADOOP_HOME/sbin/start-dfs.sh
#$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/start-all.sh

hdfs dfs -mkdir /tmp
hdfs dfs -chmod g+w /tmp

hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /user/hive/warehouse

#Hive
$HIVE_HOME/bin/schematool -dbType derby -initSchema