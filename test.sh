#!/bin/bash
#Author: Template


yum -y install gcc gcc-c++ 
yum -y install autoconf automake 
yum -y install make unzip wget 
yum -y install zlib zlib-devel 
yum -y install openssl openssl-devel 
yum -y install pcre pcre-devel libxml2 
yum -y install GeoIP GeoIP-devel GeoIP-data 
yum -y install libxml2-dev libxslt-devel gd-devel 



cd /usr/local/src/

[ ! -f "waf.tgz" ] && wget https://github.com/dengrenchao/docker-waf/blob/master/waf.tgz

ls *.tgz | xargs -n 1  tar xf
cd LuaJIT-2.0.5 && make && make install && cd ..

echo "export LUAJIT_LIB=/usr/local/lib" >> /etc/profile && \
echo "export LUAJIT_INC=/usr/local/include/luajit-2.0" >> /etc/profile
source /etc/profile
cd nginx-1.14.0 && useradd -s /sbin/nologin -M nginx
./configure --user=nginx --group=nginx \
--prefix=/usr/local/nginx \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_gzip_static_module \
--pid-path=/var/run/nginx/nginx.pid \
--lock-path=/var/lock/nginx.lock \
--error-log-path=/usr/local/nginx/logs/nginx/error.log \
--http-log-path=/usr/local/nginx/logs/nginx/access.log \
--with-http_realip_module \
--add-module=/usr/local/src/ngx_devel_kit-0.3.0 \
--add-module=/usr/local/src/lua-nginx-module-0.10.13 \
--add-module=/usr/local/src/nginx-upstream-fair-master \
--http-client-body-temp-path=/var/temp/nginx/client \
--http-proxy-temp-path=/var/temp/nginx/proxy \
--http-fastcgi-temp-path=/var/temp/nginx/fastcgi \
--http-uwsgi-temp-path=/var/temp/nginx/uwsgi \
--http-scgi-temp-path=/var/temp/nginx/scgi \
--with-ld-opt="-Wl,-rpath,$LUAJIT_LIB" && make -j8 && make install && ln -s /usr/local/nginx-1.14.0 /usr/local/nginx

mkdir -p /usr/local/nginx/logs/hack/ && chown -R nginx.nginx /usr/local/nginx/logs/hack/ && chmod -R 755 /usr/local/nginx/logs/hack/

sed -i '25 a lua_package_path \"/usr/local/nginx/conf/waf/?.lua\";\nlua_shared_dict limit 10m;\ninit_by_lua_file  /usr/local/nginx/conf/waf/init.lua;\naccess_by_lua_file /usr/local/nginx/conf/waf/waf.lua;' /usr/local/nginx/conf/nginx.conf

cd /usr/local/src/ && unzip master.zip -d /usr/local/nginx/conf/ && mv /usr/local/nginx/conf/ngx_lua_waf-master /usr/local/nginx/conf/waf


/usr/local/nginx/sbin/nginx