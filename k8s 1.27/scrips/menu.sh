#!/bin/sh

script_dir=$(pwd)
cd ..
if [[ -z "$INSTALLER_DIR" ]]
then # add new
  echo "export INSTALLER_DIR=$(pwd)" >> ~/.bashrc
  source ~/.bashrc
else # modify existing    
  sed -i "s|INSTALLER_DIR=$INSTALLER_DIR|INSTALLER_DIR=$(pwd)|g" ~/.bashrc
  source ~/.bashrc
fi
cd scripts



while :
do
 echo "========================"
 echo "Kubernetes install menu"
 echo "========================"
 echo "1. Single-Node config"
 echo "2. install"
 echo "0. exit"
 echo -n "Enter: "
 read ans
 case $ans in
  1)
    source $INSTALLER_DIR/scripts/master_config.sh 
    ;;
  2)
    while :
    do
      echo "======================"
      echo "Kubernetes Install"
      echo "======================"
      echo "1. rpm packages"
      echo "2. ContainerD"
      echo "3. Kubernetes"
      echo "0. Back"
      echo -n "Enter: "
      read install_ans
      case $install_ans in
      1)
        sh $INSTALLER_DIR/scripts/base_packages.sh
      ;;
      2) 
        sh $INSTALLER_DIR/scripts/containerd.sh
        sh $INSTALLER_DIR/scripts/containerdrun.sh
        sh $INSTALLER_DIR/scripts/containerdruns.sh
      ;;
      3)
        sh $INSTALLER_DIR/scripts/kubernetes_base.sh
        sh $INSTALLER_DIR/scripts/kubernetes_master.sh
      ;;
      0)
        break
      ;;
      esac
    done
    ;;
  0)
    break
  ;; 
 esac
done
cd $INSTALLER_DIR
