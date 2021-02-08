#!/bin/bash

EC2_HOME=/home/ec2-user
EC2_INIT_LOG_ROOT=${EC2_HOME}/ec2-init.root.log
EC2_INIT_LOG_EC2_USER=${EC2_HOME}/ec2-init.ec2-user.log

TOMCAT_GIT="https://github.com/meditch05/ec2_tomcat.git"

DOC_HOME=/home/ec2-user/tomcat/servers/aws_test/ogg-test

##########################################################################
# EC2 - Start Init ( by root, default )
##########################################################################
echo "`uptime`"                          >> ${EC2_INIT_LOG_ROOT}
echo "`date` - Init Start by (`whoami`)" >> ${EC2_INIT_LOG_ROOT}
chmod 666 ${EC2_INIT_LOG_ROOT}

##########################################################################
# EC2 - Install package ( by root, default )
##########################################################################
echo "`date` - yum install Start (`whoami`)" >> ${EC2_INIT_LOG_ROOT}

yum install -y jq-devel.x86_64                                           \
               git                                                       \
	       amazon-cloudwatch-agent                                   \
               java-1.8.0-openjdk-devel-1.8.0.272.b10-1.amzn2.0.1.x86_64 \
               | tee -a ${EC2_INIT_LOG_ROOT}

timedatectl set-timezone Asia/Seoul | tee -a ${EC2_INIT_LOG_ROOT}

echo "`date` - yum install Ended (`whoami`)" >> ${EC2_INIT_LOG_ROOT}

##########################################################################
# EC2 - Get Tomcat Engine ( by root, default )
##########################################################################
echo "`date` - Tomcat install Start (`whoami`)" >> ${EC2_INIT_LOG_EC2_USER}

mkdir git
cd git
git clone ${TOMCAT_GIT}

cd ec2_tomcat
sudo cp .bash_profile ${EC2_HOME}

tar -zxvf tomcat.tar.gz
cp -Rp tomcat ${EC2_HOME}
cp -Rp shl    ${EC2_HOME}

# rm -rf ${DOC_HOME}/WEB-INF/classes
# cp -Rp classes ${DOC_HOME}/WEB-INF

chown -R ec2-user:ec2-user ${EC2_HOME}
chown -R ec2-user:ec2-user ~/.bash_profile

echo "echo `date` - Tomcat install Ended (`whoami`)" >> ${EC2_INIT_LOG_EC2_USER}

##########################################################################
# EC2 - start Tomcat ( by ec2-user )
##########################################################################
echo "`date` - Tomcat Start (`whoami`)" >> ${EC2_INIT_LOG_EC2_USER}

su - ec2-user -c "cd /home/ec2-user/shl; add_crontab.sh"
su - ec2-user -c "cd /home/ec2-user/tomcat/servers/aws_test/shl; ./start.sh"

echo "`date` - Tomcat Started (`whoami`)" >> ${EC2_INIT_LOG_EC2_USER}

##########################################################################
# EC2 - End Init ( by root, default )
##########################################################################
echo "`date` - Init Ended" >> ${EC2_INIT_LOG_ROOT}
