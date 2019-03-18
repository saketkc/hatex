#!/bin.bash
set -eox pipefail
export PATH=${JAVA_HOME}/bin:${PATH}
export HADOOP_CLASSPATH=${JAVA_HOME}/lib/tools.jar
hadoop fs -mkdir -p /user/kcsaket
hadoop com.sun.tools.javac.Main InvertedIndex.java
jar cf invertedindex.jar InvertedIndex*.class
hadoop fs -rmr ./invertedindex.jar
hadoop fs -copyFromLocal ./invertedindex.jar
hadoop fs -cp ./invertedindex.jar gs://dataproc-2dcb0a08-c83c-484c-a80b-d93604c00be2-us/JAR
