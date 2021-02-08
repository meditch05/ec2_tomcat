#!/bin/bash

TOMCAT_DBCP_LOG=/tmp/dbdp.log
TOMCAT_THREAD_LOG=/tmp/thread.log
DATA=/tmp/data.log
FIELD=/tmp/field.log

##########################
# Tomcat Threads
##########################
curl -s --netrc-file /home/ec2-user/shl/auth.txt http://127.0.0.1:8080/probe/datasources.htm > ${TOMCAT_DBCP_LOG}
cat ${TOMCAT_DBCP_LOG} | sed -e "s/\r//g" | egrep     "jdbc\/orcl"  |           cut -d">"  -f2 | cut -d"<" -f1 >  ${DATA}
cat ${TOMCAT_DBCP_LOG} | sed -e "s/\r//g" | egrep -B4 "jdbc:oracle" | head -4 | cut -d">"  -f2 | cut -d"<" -f1 >> ${DATA}
cat ${TOMCAT_DBCP_LOG} | sed -e "s/\r//g" | egrep     "jdbc:oracle" |           cut -d"\"" -f2 | cut -d"<" -f1 >> ${DATA}
echo "NAME"        >  ${FIELD}
echo "MAX"         >> ${FIELD}
echo "ESTABLISHED" >> ${FIELD}
echo "BUSY"        >> ${FIELD}
echo "USER"        >> ${FIELD}
echo "URL"         >> ${FIELD}
echo "########################################################################"
paste ${FIELD} ${DATA} | column -t

##########################
# Tomcat DBCP ( ROOT.xml )
##########################
curl -s --netrc-file /home/ec2-user/shl/auth.txt http://127.0.0.1:8080/probe/threadpools.htm > ${TOMCAT_THREAD_LOG}
cat ${TOMCAT_THREAD_LOG} | grep -A5 "http-nio-8080" | cut -d">" -f2 | cut -d"<" -f1 > ${DATA}
echo "NAME"                 > ${FIELD}
echo "CURRENT_THREAD_COUNT" >> ${FIELD}
echo "CURRENT_THREADS_BUSY" >> ${FIELD}
echo "MAX_THREADS"          >> ${FIELD}
echo "MAX_SPARE_THREADS"    >> ${FIELD}
echo "MIN_SPARE_THREADS"    >> ${FIELD}
echo "########################################################################"
paste ${FIELD} ${DATA} | column -t 
echo "########################################################################"
