#!/bin.bash
set -eox pipefail
export PATH=${JAVA_HOME}/bin:${PATH}
export HADOOP_CLASSPATH=${JAVA_HOME}/lib/tools.jar
hadoop fs -rm -r ./5722018484_output.txt
hadoop fs -getmerge gs://dataproc-2dcb0a08-c83c-484c-a80b-d93604c00be2-us/5722018484_output ./5722018484_output.txt
hadoop fs -copyFromLocal ./5722018484_output.txt
hadoop fs -cp ./5722018484_output.txt gs://dataproc-2dcb0a08-c83c-484c-a80b-d93604c00be2-us/5722018484_output.txt
