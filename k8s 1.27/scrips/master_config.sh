#!/bin/sh

script_dir=$(pwd)
cd ..
default_dir=$(pwd)

echo "============================"
echo "Configuration"
echo "============================"
echo "Enter the hostname of this master node. if you didn't set hostname, Enter the hostname that you want to use."
echo -n "Enter: "
read host
echo -e "\nEnter Master IP"
echo -n "Enter: "
read master_host_ip



cd $default_dir
if [[ -z "$MASTER_HOSTNAME" ]]
then # add new
  echo "export MASTER_HOSTNAME=$host" >> ~/.bashrc
  source ~/.bashrc
else # modify existing    
  sed -i "s|MASTER_HOSTNAME=$MASTER_HOSTNAME|MASTER_HOSTNAME=$host|g" ~/.bashrc
  source ~/.bashrc
fi

if [[ -z "$MASTER_IP" ]]
then # add new
  echo "export MASTER_IP=$master_host_ip" >> ~/.bashrc
  source ~/.bashrc
else # modify existing    
  sed -i "s|MASTER_IP=$MASTER_IP|MASTER_IP=$master_host_ip|g" ~/.bashrc
  source ~/.bashrc
fi

if [[ -z "$CLUSTER_MASTER_IP" ]]
then # add new
  echo "export CLUSTER_MASTER_IP=$master_host_ip" >> ~/.bashrc
  source ~/.bashrc
else # modify existing    
  sed -i "s|CLUSTER_MASTER_IP=$CLUSTER_MASTER_IP|CLUSTER_MASTER_IP=$master_host_ip|g" ~/.bashrc
  source ~/.bashrc
fi

if [[ -z "$INSTALLER_DIR" ]]
then # add new
  echo "export INSTALLER_DIR=$(pwd)" >> ~/.bashrc
  source ~/.bashrc
else # modify existing    
  sed -i "s|INSTALLER_DIR=$INSTALLER_DIR|INSTALLER_DIR=$(pwd)|g" ~/.bashrc
  source ~/.bashrc
fi

cd $script_dir

