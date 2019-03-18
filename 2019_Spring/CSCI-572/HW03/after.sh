#!/bin.bash
set -eox pipefail
export PATH=${JAVA_HOME}/bin:${PATH}
export HADOOP_CLASSPATH=${JAVA_HOME}/lib/tools.jar
hadoop fs -rm -r ./fulldataoutput_18march.txt
hadoop fs -getmerge gs://dataproc-2dcb0a08-c83c-484c-a80b-d93604c00be2-us/fulldataoutput_18march ./fulldataoutput_18march.txt
hadoop fs -copyFromLocal ./fulldataoutput_18march.txt
hadoop fs -cp ./fulldataoutput_18march.txt gs://dataproc-2dcb0a08-c83c-484c-a80b-d93604c00be2-us/fulldataoutput_18march.txt
