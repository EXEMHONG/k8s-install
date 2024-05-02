#!/bin/sh

echo "  _  _  ___  ___    ____  ____  ____  __    _____  _  _  "
echo " ( )/ )( _ )/ __)  (  _ \( ___)(  _ \(  )  (  _  )( \/ ) "
echo "  )  ( / _ \\__ \   )(_) ))__)  )___/ )(__  )(_)(  \  /  " 
echo " (_)\_)\___/(___/  (____/(____)(__)  (____)(_____) (__)  " 

sleep 3;

cat <<EOF | sudo tee /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
$MASTER_IP $MASTER_HOSTNAME
EOF


sysctl --system
systemctl stop firewalld
systemctl disable firewalld

cd $INSTALLER_DIR/repository/image

sudo ctr -n k8s.io images import coredns.tar
sudo ctr -n k8s.io images import etcd.tar
sudo ctr -n k8s.io images import kube-apiserver.tar
sudo ctr -n k8s.io images import kube-controller-manager.tar
sudo ctr -n k8s.io images import kube-proxy.tar
sudo ctr -n k8s.io images import kube-scheduler.tar
# kubernetes 1.27.6 의 경우 pause 3.6, 3.9 가 둘 다 필요
sudo ctr -n k8s.io images import pause3.6.tar
sudo ctr -n k8s.io images import pause3.9.tar
# sudo ctr -n k8s.io images import mirrored-flannelcni-flannel.tar
# sudo ctr -n k8s.io images import mirrored-flannelcni-flannel-cni-plugin.tar



sleep 10

cd $INSTALLER_DIR/repository/kubernetes

if [ -z "$BASH_VERSION" ]; then exec bash "$0" "$@"; exit; fi

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-*

rpm_list=`find . -name "*.rpm"`

for rpm in ${rpm_list}
do
if [[ ${rpm} == *"kubernetes-cni"* ]]; then
echo "rpm -ivh ${rpm} --nodeps"
rpm -ivh ${rpm} --nodeps
elif [[ ${rpm} == *"01_python3"* ]]; then
echo "rpm -ivh ${rpm} --nodeps"
 rpm -ivh ${rpm} --nodeps
else
echo "rpm -Uvh ${rpm}"
rpm -Uvh ${rpm} --nodeps
fi
done



cd $INSTALLER_DIR
