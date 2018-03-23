FROM ubuntu:16.04

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
RUN tar -xJvf node-v$NODE_VERSION-linux-x64.tar.xz -C /usr/local/lib/nodejs && rm -rf /node-v$NODE_VERSION*
RUN mv /usr/local/lib/nodejs/node-v$NODE_VERSION-linux-x64 /usr/local/lib/nodejs/node-v$NODE_VERSION
ENV PATH=/usr/local/lib/nodejs/node-v$NODE_VERSION/bin:$PATH

# front-end

RUN mkdir /www && cd /www && git clone https://github.com/x-utest/xtest-web.git
COPY config.js /www/xtest-web/src/config.js
RUN cd /www/xtest-web && npm install && npm run build

# back-end

RUN git clone https://github.com/our-dev/dtlib.git && \
    cd dtlib && ./install.sh && rm -rf /dtlib
RUN git clone https://github.com/x-utest/xtest-server-base.git && \
    cd xtest-server-base && ./install.sh && rm -rf /xtest-server-base
RUN git clone https://github.com/x-utest/xtest-server.git && \
    cd xtest-server && pip3 install -r requirements.txt

# Install Nginx

RUN apt-get install nginx -y
RUN cd /etc/nginx/conf.d/ && ln -s /xtest-server/nginx_config/* .

# Install MongoDB.
ENV MONGO_VERSION 3.2.7

RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 && \
  echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list && \
  apt-get update && \
  apt-get install -y mongodb-org=$MONGO_VERSION \
  mongodb-org-server=$MONGO_VERSION \
  mongodb-org-shell=$MONGO_VERSION \
  mongodb-org-mongos=$MONGO_VERSION \
  mongodb-org-tools=$MONGO_VERSION && \
  rm -rf /var/lib/apt/lists/*

COPY mongodb.conf /data/mongodb.conf
COPY start.sh /data/start.sh
COPY init_mongo.sh /data/init_mongo.sh

# Define mountable directories.
VOLUME ["/data/db"]

# Define working directory.
WORKDIR /data

# Define default command.
#ENTRYPOINT ["mongod", "-f", "mongodb.conf"]
CMD ["./start.sh"]

EXPOSE 8009 8099
