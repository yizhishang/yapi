FROM node:10.15.2-jessie
MAINTAINER mrjin<me@jinfeijie.cn>
ENV VERSION 	1.5.6
ENV PORT        3000
ENV ADMIN_EMAIL "me@jinfeijie.cn"
ENV DB_SERVER 	"mongo"
ENV DB_NAME 	"yapi"
ENV DB_PORT 	27017
ENV GIT_URL     https://github.com/YMFE/yapi.git
ENV GIT_MIRROR_URL     http://192.168.110.119:3000/yizhishang/YApi.git
# ENV GIT_MIRROR_URL     https://gitee.com/mirrors/YApi.git
ENV REGISTRY	https://registry.npm.taobao.org

WORKDIR /home

COPY entrypoint.sh /bin
COPY config.json /home
COPY wait-for-it.sh /
COPY YApi-master.tar.gz /home

RUN rm -rf node && \
    tar -zxvf /home/YApi-master.tar.gz && \
	echo "hello world" && \
	pwd && ls && \
	mv /home/config.json /home/yapi/ && \
	cd /home/yapi && \
	npm install -g node-gyp yapi-cli && \
	npm install --production && \
 	chmod +x /bin/entrypoint.sh && \
 	chmod +x /wait-for-it.sh && \
	rm -rf /home/YApi-master.tar.gz

EXPOSE ${PORT}
ENTRYPOINT ["entrypoint.sh"]