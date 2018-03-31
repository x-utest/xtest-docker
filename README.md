# xtest-docker

xtest 测试系统的 Dockerfile，方便部署。

# 前提：

1. 在需要安装 xtest 系统的宿主机上装有 Docker 环境。

# 使用方法:

1. 下载该项目源码;

2. 修改部分配置，包括:

- 修改 `config.json` 文件首行的 IP 为你宿主机的 IP，可以选择修改端口号为你期望的端口号，但是建议保持不动；
- 除非你有特殊要求, 保持其他文件不动, 否则你可能需要 `xtest-server` 和 `Dockerfile` 文件中的部分代码。

3. 构建 xtest 镜像，冒号后为版本号，不需要可以不写

```
docker build -t xtest:1.0 .
```

4. 在宿主机上创建 docker 卷，用于 MongoDB 数据持久化

```
docker volume create --name xtest-data
```

5. 上述步骤均完成后，第一次运行 xtest 容器需要先进行初始化 MongoDB，执行如下命令：

```
docker run -v xtest-data:/data/db -it xtest:1.0 ./init_mongo.sh
```

6. 在完成初始化 MongoDB 后，以后需要运行 xtest 容器时执行如下命令：

```
docker run -p 8009:8009 -p 8099:8099 -v xtest-data:/data/db -it xtest:1.0
```

> 该命令中，`8099` 端口为浏览器访问端口，若修改该端口，则步骤7也需要修改。例如你希望访问`HOST_IP:1234`，则将本步骤中 `-p 8099:8099` 修改为 `-p 1234:8099`；
> `8009` 端口用于 xtest 前后端通信，若你在步骤2中修改了该端口，则本步骤也需要做相应修改。例如你在步骤2中将端口修改为2345，则需要将本步骤中 `-p 8009:8009` 修改为 `-p 2345:8009` 。

7. 浏览器输入 `HOST_IP:8099`，即可访问 xtest 系统；

8. 欢迎使用！
