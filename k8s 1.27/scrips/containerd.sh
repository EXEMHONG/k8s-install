#!/bin/sh

setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
swapoff -a
sudo sed -i --follow-symlinks '/^\/dev\/mapper\/centos-swap swap/s/^/#/' /etc/fstab

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

#[커널 모듈 등록 명령어]
sudo modprobe overlay
sudo modprobe br_netfilter
#[설정 파일 생성 명령어]
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
#[적용 명령어]
sysctl --system


#[설치 명령어]
cd $INSTALLER_DIR/repository/containerd
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



