#!/bin/bash

> /home/ec2-user/tomcat/servers/aws_test/logs/localhost_access.`date +%Y-%m-%d`.log
find /home/ec2-user/tomcat/servers/aws_test/logs/gclog -type f | while read FILE
do
   > ${FILE}
done
