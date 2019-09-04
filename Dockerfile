######## 源码 ########
FROM node:alpine as source

ENV YAPI_VERSION=1.8.3

ENV REGISTRY  http://192.168.110.119:8091/repository/npm/

WORKDIR /yapi/vendors

COPY config.js /yapi

RUN echo https://mirrors.ustc.edu.cn/alpine/v3.8/main > /etc/apk/repositories; \
    echo https://mirrors.ustc.edu.cn/alpine/v3.8/community >> /etc/apk/repositories;\
    echo "Asia/Shanghai" > /etc/timezone ; 

RUN apk add --no-cache git bash python make gcc g++ 

SHELL ["/bin/bash", "-c"]

RUN echo $(node -e "console.log(JSON.stringify(require('/yapi/config.js')))") > /yapi/config.json \
  && git clone -b "v${YAPI_VERSION}" --single-branch --depth 1 http://192.168.110.119:3000/yizhishang/YApi.git . \
  && rm -rf .git .github docs test *.{jpg,md} \
  && sed -i -e 's|Alert,|Alert, Divider,|' ./client/components/Notify/Notify.js \
  && sed -i -e 's|</a>|</a><Divider type="vertical" /><a target="view_window" href="https://github.com/fjc0k/docker-YApi#%E5%A6%82%E4%BD%95%E5%8D%87%E7%BA%A7">Docker 版升级指南</a>|' ./client/components/Notify/Notify.js \
  && npm config set registry ${REGISTRY} \
  && npm config set _auth  YWRtaW46cm9vdA== \
  && npm install ykit node-sass react-dnd react-dnd-html5-backend --package-lock-only \
  && npm ci \
  && npm run build-client \
  && shopt -s globstar && rm -rf **/*.{map,lock,log,md,yml}

######## 镜像 ########
FROM node:alpine

MAINTAINER yuanyongjun

WORKDIR /yapi

COPY --from=source /yapi .
COPY start.js .

EXPOSE 3000

CMD ["node", "./start.js"]