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

4. run

```
docker run -p 8009:8009 -p 8099:8099 -it xtest:1.0
```

to start xtest system;

5. visit xtest system through `HOST_IP:8009`;

6. ENJOY IT!
