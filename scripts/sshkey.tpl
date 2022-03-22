#!/bin/bash

cp /home/opc/.ssh/authorized_keys /home/opc/.ssh/authorized_keys.bak
echo "${key_magento}" >> /home/opc/.ssh/authorized_keys
echo "${key_redis}" >> /home/opc/.ssh/authorized_keys
chown -R opc /home/opc/.ssh/authorized_keys
