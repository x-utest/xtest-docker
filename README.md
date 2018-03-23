# xtest-docker
Try run a Docker container to run XTest system easily!

# Premise：

1. Install Docker in your host;

# USAGE:

1. clone this project;

2. change some configuration in this project:

- change the ipadress to your **host IP** in the first line of `config.json`;
- Unless you have a strong reason to, **don't** change other configurations, or you have to change some code in `xtest-server` and `Dockerfile` .

3. run

```
docker build -t xtest:1.0 .
```

to build xtest Docker image;

4. create a volume in your host

```
docker volume create xtest-data
```

5. first run, you need to initialize your mongodb with command:

```
docker run -v xtest-data/data/db -it xtest:1.0 ./init_mongo.sh
```

6. after you initialize mongodb, you can start xtest:

```
docker run -p 8009:8009 -p 8099:8099 -v xtest-data/data/db -it xtest:1.0
```

> you can customize your web entry port `8099`, while you need to keep api port as `8009`.

7. visit xtest system through `HOST_IP:8009`;

8. ENJOY IT!
