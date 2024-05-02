#!/bin/sh

echo "  ____  ____  __  __    ____  ____  ____  __    _____  _  _  "
echo " (  _ \(  _ \(  \/  )  (  _ \( ___)(  _ \(  )  (  _  )( \/ ) "
echo "  )   / )___/ )    (    )(_) ))__)  )___/ )(__  )(_)(  \  /  "
echo " (_)\_)(__)  (_/\/\_)  (____/(____)(__)  (____)(_____) (__)  "

sleep 3;


cd $INSTALLER_DIR/repository/rpm

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

