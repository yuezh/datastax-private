#!/bin/bash
# This script gets a VM ready so DataStax OpsCenter can perform an install on it.

echo "Add host names to /etc/hosts"

CLUST_COUNT=5
NODE_COUNT=18

echo "127.0.0.1 ${HOSTNAME}" >> /etc/hosts
echo "127.0.0.1 localhost.localdomain localhost" >> /etc/hosts
echo "10.0.0.5  opcvm" >> /etc/hosts
for i in $(seq 0 1 $CLUST_COUNT)
do
    for j in $(seq 0 1 $NODE_COUNT)
    do
        echo "10.0.$i.$(expr $j + 6)  dc${i}vm${j}" >> /etc/hosts
    done
done

echo "Partitioning and formatting all attached data disks"
bash vm-disk-utils-0.1.sh

echo "Installing Java"
add-apt-repository -y ppa:webupd8team/java
apt-get -y update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
apt-get -y install oracle-java8-installer

echo "Modifying permissions"
chmod 777 /mnt
chmod 777 /datadisks
