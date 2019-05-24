# DOCKER-WAF-INSTALL #

#USE：Can do nginx direction proxy or WAF firewall


### Docker installation docker ###



    #install docker

    execute: sh install_docker.sh

    [root@localhost ~]# sh install_docker.sh


### Docker installation waf ###

    [root@localhost ~]# docker pull registry.cn-hangzhou.aliyuncs.com/ricek8s/uqsjsj:docker-waf-v1.1
    [root@localhost ~]# docker run -it -d -p 80:80 -p 443:443 --restart=always  --name docker-waf registry.cn-hangzhou.aliyuncs.com/ricek8s/uqsjsj:docker-waf-v1.1 /bin/bash



### Profile description ###
    dockerpid  = docker exec -it pid_name bash
    ngin_path：/usr/local/nginx/



### Verify the web service effect ###
[root@localhost ~]# curl http://tmp.test.com/test.php?id=../etc/passwd
![waf](https://share-emlog.oss-cn-beijing.aliyuncs.com/waf-web.png)






