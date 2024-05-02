#!/bin/bash

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
		rpm -Uvh ${rpm}
	fi
done
