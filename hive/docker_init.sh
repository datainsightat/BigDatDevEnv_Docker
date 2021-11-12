#!/bin/sh

#Hadoop
/etc/init.d/ssh start

echo 'Y' | $HADOOP_HOME/bin/hdfs namenode -format

$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
# $HADOOP_HOME/sbin/start-all.sh
$HADOOP_HOME/bin/mapred --daemon start historyserver

hadoop fs -mkdir /user/ && \
hadoop fs -mkdir /user/hive && \
hadoop fs -mkdir /user/hive/warehouse && \
hadoop fs -mkdir /tmp && \
hadoop fs -chmod g+w /user/hive/warehouse && \
hadoop fs -chmod g+w /tmp

$HIVE_HOME/bin/schematool -initSchema -dbType derby
#$HIVE_HOME/bin/schematool -upgradeSchema -dbType derby

#Upload sample data
hadoop fs -mkdir /examples
hadoop fs -chmod g+w /examples
hadoop fs -put data/* /examples