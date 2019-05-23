#!/bin/bash
#Author: Template
yum -y install gcc gcc-c++ \ 
autoconf automake \
make unzip wget \
zlib zlib-devel \
openssl openssl-devel \
pcre pcre-devel libxml2 \
GeoIP GeoIP-devel GeoIP-data \
libxml2-dev libxslt-devel gd-devel \



cd /usr/local/src/

[ ! -f "LuaJIT-2.0.5.tar.gz" ] && wget http://luajit.org/download/LuaJIT-2.0.5.tar.gz 
[ ! -f "nginx-1.14.0.tar.gz" ] && wget http://nginx.org/download/nginx-1.14.0.tar.gz && 
[ ! -f "v0.3.0.tar.gz" ] && wget https://github.com/simplresty/ngx_devel_kit/archive/v0.3.0.tar.gz 
[ ! -f "v0.10.13.tar.gz" ] && wget https://github.com/openresty/lua-nginx-module/archive/v0.10.13.tar.gz
[ ! -f "master.zip" ] && wget https://github.com/loveshell/ngx_lua_waf/archive/master.zip --no-check-certificate

ls *.tar.gz | xargs -n 1  tar xf

cd LuaJIT-2.0.5 && make && make install && cd ..

echo "export LUAJIT_LIB=/usr/local/lib" >> /etc/profile && \
echo "export LUAJIT_INC=/usr/local/include/luajit-2.0" >> /etc/profile
source /etc/profile
cd nginx-1.14.0 && useradd -s /sbin/nologin -M www
./configure --user=www --group=www \
--prefix=/usr/local/nginx-1.14.0 \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_gzip_static_module \
--pid-path=/usr/local/nginx-1.14.0/nginx.pid \
--with-http_realip_module \
--add-module=/usr/local/src/ngx_devel_kit-0.3.0 \
--add-module=/usr/local/src/lua-nginx-module-0.10.13 \
--with-ld-opt="-Wl,-rpath,$LUAJIT_LIB" && make -j8 && make install && ln -s /usr/local/nginx-1.14.0 /usr/local/nginx

mkdir -p /usr/local/nginx/logs/hack/ && chown -R www.www /usr/local/nginx/logs/hack/ && chmod -R 755 /usr/local/nginx/logs/hack/

sed -i '25 a lua_package_path \"/usr/local/nginx/conf/waf/?.lua\";\nlua_shared_dict limit 10m;\ninit_by_lua_file  /usr/local/nginx/conf/waf/init.lua;\naccess_by_lua_file /usr/local/nginx/conf/waf/waf.lua;' /usr/local/nginx/conf/nginx.conf

cd /usr/local/src/ && unzip master.zip -d /usr/local/nginx/conf/ && mv /usr/local/nginx/conf/ngx_lua_waf-master /usr/local/nginx/conf/waf

/usr/local/nginx/sbin/nginx