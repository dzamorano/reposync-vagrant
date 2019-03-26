#!/bin/bash

USERNAME=$1
PASSWORD=$2
POOL=$3
OCP_RELEASE=$4
ANSIBLE_VERSION=$5

subscription-manager register --username=${USERNAME} --password=${PASSWORD} --force
subscription-manager attach --pool=${POOL}
subscription-manager repos --disable "*"
subscription-manager repos --enable="rhel-7-server-rpms" \
                           --enable="rhel-7-server-extras-rpms" \
						   --enable="rhel-7-server-ose-${OCP_RELEASE}-rpms" \
						   --enable="rhel-7-server-ansible-${ANSIBLE_VERSION}-rpms"
yum clean all
rm -rf /var/cache/yum