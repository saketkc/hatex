#!/bin.bash
set -eox pipefail
export PATH=${JAVA_HOME}/bin:${PATH}
export HADOOP_CLASSPATH=${JAVA_HOME}/lib/tools.jar
hadoop fs -rm -r ./devdataoutput.txt
hadoop fs -getmerge gs://dataproc-2dcb0a08-c83c-484c-a80b-d93604c00be2-us/devdataoutput ./devdataoutput.txt
hadoop fs -copyFromLocal ./devdataoutput.txt
hadoop fs -cp ./devdataoutput.txt gs://dataproc-2dcb0a08-c83c-484c-a80b-d93604c00be2-us/devdataoutput.txt
