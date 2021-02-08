#!/bin/bash

LOG=/home/ec2-user/tomcat/servers/aws_test/logs/localhost_access.`date +%Y-%m-%d`.log

tail -30000 ${LOG} | awk '{print $4}' | sort | uniq -c
