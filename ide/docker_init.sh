# Start Hadoop

#!/bin/sh

sudo su -

#Hadoop
/etc/init.d/ssh start

echo 'Y' | $HADOOP_HOME/bin/hdfs namenode -format

$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

hdfs dfs -mkdir /tmp
hdfs dfs -chmod g+w /tmp
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /user/hive/warehouse

#Hive
$HIVE_HOME/bin/schematool -dbType derby -initSchema

#Spark
#start-master.sh
#start-slave.sh -m 512M spark://localhost:7077
$SPARK_HOME/bin/start-all.sh

#Theia IDE
yarn start /home/project --hostname=0.0.0.0 --port=3000