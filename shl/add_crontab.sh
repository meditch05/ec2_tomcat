#!/bin/bash

(crontab -l 2>/dev/null; echo "*/20 * * * * /home/ec2-user/shl/clear_log.sh") | crontab -
