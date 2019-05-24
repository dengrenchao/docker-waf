# DOCKER-WAF-INSTALL #

#USE：Can do nginx direction proxy or WAF firewall


### Docker installation docker ###



    安装 docker
    执行 sh install_docker.sh
    [root@localhost ~]# sh install_docker.sh


### Docker installation waf ###

    [root@localhost ~]# docker push registry.cn-hangzhou.aliyuncs.com/ricek8s/uqsjsj:docker-waf-v1.1
    [root@localhost ~]# docker run -it -d -p 80:80 -p 443:443 --restart=always  --name docker-waf registry.cn-hangzhou.aliyuncs.com/ricek8s/uqsjsj:docker-waf-v1.1 /bin/bash



###配置文件说明
dockerpid  = docker exec -it pid_name bash

ngin_path：/usr/local/nginx/







