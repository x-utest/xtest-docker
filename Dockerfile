FROM python:3.5

# back-end
RUN git clone https://github.com/x-utest/xtest-server.git && \
    cd xtest-server && pip3 install -r requirements.txt

# Set DOCKER ENV
ENV DOCKER 1

# Install Nginx
RUN apt-get update && apt-get install nginx -y
RUN cd /etc/nginx/conf.d/ && ln -s /xtest-server/nginx_config/* .


# Define mountable directories.
VOLUME ["/data/db"]

# Define working directory.
WORKDIR /data

# Define default command.
COPY start_server.sh /data/start_server.sh
CMD ["./start_server.sh"]

EXPOSE 8009 8099
