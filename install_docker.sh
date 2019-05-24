#!/bin/bash
#author:rice
#datetime:2019-01-26



#configuration yum

yum -y install epel*
yum -y install wget curl git \
gcc gcc-c++ unzip vim  bind-utils \
lrzsz  telnet net-tools nfs-utils lsof \
tcpdump htop python-pip nmap-ncat.x86_64 iptables \

#close selinux

setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/#UseDNS no/UseDNS no/g' /etc/ssh/sshd_config

#close firewalld
sudo systemctl disable firewalld

#install docker procedure

#remove docker procedure

sudo yum -y remove docker \
                docker-client \
                docker-client-latest \
                docker-common \
                docker-latest \
                docker-latest-logrotate \
                docker-logrotate \
                docker-selinux \
                docker-engine-selinux \
                docker-engine \
				docker*

find / -name docker |xargs rm -rf;
cd /etc/yum.repos.d/ && wget http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install -y  docker-ce-18.03.1.ce

#set docker addresss
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{

  "registry-mirrors":["https://culfukli.mirror.aliyuncs.com"]
  
}
EOF
sudo systemctl daemon-reload
sudo systemctl enable docker && systemctl restart docker

sudo tee /bin/dockerpid <<-'EOF'
#!/bin/bash

x1=${1}

docker exec -it $x1 bash

EOF
chmod +x /bin/dockerpid
docker pull centos && docker ps

