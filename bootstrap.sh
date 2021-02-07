#!/bin/bash
 
cp /etc/motd /etc/motd.bkp
cat << EOF > /etc/motd
 
I have been modified by cloud-init at $(date)
 
EOF

sed -i s/^SELINUX=.*$/SELINUX=permissive/ /etc/selinux/config
setenforce 0
systemctl stop firewalld
systemctl disable firewalld

yum check-update
#yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker 
systemctl start docker
systemctl enable docker

systemctl status docker

yum -y install httpd

echo 'Welcome Oracle Cloud Test Apache' >/var/www/html/index.html

systemctl start httpd
systemctl enable httpd

docker login -u nabarunsen -p Kolkata@128
docker pull nabarunsen/dropwizardhelloworld:v1.0
docker run -p 8080:8080 docker.io/nabarunsen/dropwizardhelloworld &






