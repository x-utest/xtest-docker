FROM ubuntu:16.04
MAINTAINER ShinYeung "ityoung@foxmail.com"

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install Python

RUN apt-get update && \
    apt-get install python3 python3-dev python3-pip -y

RUN ln -s /usr/bin/python3 /usr/bin/python

# Install utils

RUN apt-get install -y wget xz-utils git

# Install nodejs

ENV NODE_VERSION 8.10.0

RUN wget https://npm.taobao.org/mirrors/node/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz
RUN mkdir /usr/local/lib/nodejs
RUN tar -xJvf node-v$NODE_VERSION-linux-x64.tar.xz -C /usr/local/lib/nodejs
RUN mv /usr/local/lib/nodejs/node-v$NODE_VERSION-linux-x64 /usr/local/lib/nodejs/node-v$NODE_VERSION
RUN echo 'export NODEJS_HOME=/usr/local/lib/nodejs/node-v$NODE_VERSION' >> ~/.noderc
RUN echo 'export PATH=$NODEJS_HOME/bin:$PATH' >> ~/.noderc

# front-end

RUN mkdir /www && cd /www && git clone https://github.com/x-utest/xtest-web.git
COPY config.js /www/xtest-web/src/config.js
RUN source ~/.noderc && cd /www/xtest-web && npm install && npm run build

# back-end

RUN git clone https://github.com/our-dev/dtlib.git && \
    cd dtlib && ./install.sh
RUN git clone https://github.com/x-utest/xtest-server-base.git && \
    cd xtest-server-base && ./install.sh
RUN git clone https://github.com/x-utest/xtest-server.git && \
    cd xtest-server && pip3 install -r requirements.txt

# MongoDB

ENV MONGO_VERSION 3.2.7

RUN wget http://downloads.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-$MONGO_VERSION.tgz
RUN tar -zxvf mongodb-linux-x86_64-ubuntu1604-$MONGO_VERSION.tgz
RUN mkdir -p mongodb
RUN cp -R -n mongodb-linux-x86_64-ubuntu1604-$MONGO_VERSION/ mongodb
RUN mv mongodb /usr/local/lib/

RUN echo 'export PATH=/usr/local/lib/mongodb/mongodb-linux-x86_64-ubuntu1604-$MONGO_VERSION/bin:$PATH' >> ~/.bashrc
RUN echo 'export PATH=/usr/local/lib/mongodb/mongodb-linux-x86_64-ubuntu1604-$MONGO_VERSION/bin:$PATH' >> ~/.mongorc
# RUN source ~/.bashrc

RUN mkdir -p /data/db
COPY mongodb.conf mongodb.conf
# ADD mongo_admin.sh mongo_admin.sh
# ADD mongo_xtest.sh mongo_xtest.sh

# RUN source ~/.mongorc && mongod -f mongodb.conf && sleep 5 \
#     && ./mongo_admin.sh && sleep 2 && ./mongo_xtest.sh && sleep 2

# Nginx

RUN apt-get install nginx -y
RUN cd /etc/nginx/conf.d/ && ln -s /xtest-server/nginx_config/* .

EXPOSE 8009 8099

# Clear

RUN rm -rf /xtest-server-base /dtlib /node-v$NODE_VERSION* /mongodb-linux* /mongo_*

# Start

COPY start.sh start.sh

ENTRYPOINT ["/start.sh"]

CMD cd /xtest-server && python start.py
