FROM node:12-alpine as builder

RUN apk add --no-cache git python make openssl tar gcc

ENV REGISTRY	https://registry.npm.taobao.org

# https://github.com/YMFE/yapi/archive/v1.8.3.tar.gz
COPY yapi-1.8.3.tar.gz /home

RUN cd /home && tar zxvf yapi.tar.gz && mkdir /api && mv /home/yapi-1.8.3 /api/vendors

RUN cd /api/vendors && \
    npm install --production --registry ${REGISTRY}

FROM node:12-alpine

MAINTAINER 285206405@qq.com

ENV TZ="Asia/Shanghai" HOME="/"

WORKDIR ${HOME}

COPY --from=builder /api/vendors /api/vendors

COPY config.json /api/

EXPOSE 3000

ENTRYPOINT ["node"]