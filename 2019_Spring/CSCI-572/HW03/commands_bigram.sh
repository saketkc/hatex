#!/bin.bash
set -eox pipefail
export PATH=${JAVA_HOME}/bin:${PATH}
export HADOOP_CLASSPATH=${JAVA_HOME}/lib/tools.jar
hadoop fs -mkdir -p /user/kcsaket
hadoop com.sun.tools.javac.Main InvertedIndexBigram.java
jar cf invertedindex_bigram.jar InvertedIndexBigram*.class
hadoop fs -rmr ./invertedindex_bigram.jar
hadoop fs -copyFromLocal ./invertedindex_bigram.jar
hadoop fs -cp ./invertedindex_bigram.jar gs://dataproc-2dcb0a08-c83c-484c-a80b-d93604c00be2-us/JAR
