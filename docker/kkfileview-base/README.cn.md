# 构建说明

由于 kkfileview 的基础运行环境很少变动且制作耗时较久，而 kkfileview 本身代码开发会频繁改动，因此把制作其 Docker 镜像的步骤拆分为两次：

首先制作 kkfileview 的基础镜像（kkfileview-base）。

然后使用 kkfileview-base 作为基础镜像进行构建，加快 kkfileview docker 镜像构建与发布。

执行如下命令即可构建基础镜像：
> 这里镜像 tag 以 4.4.0 为例，本项目所维护的 Dockerfile 文件考虑了跨平台兼容性。 如果你需要用到 arm64 架构镜像, 则在arm64 架构机器上同样执行下面的构建命令即可

```shell
docker build --tag keking/kkfileview-base:4.4.0 .
```



## 跨平台构建

`docker buildx` 支持在一台机器上构建出多种平台架构的镜像。推荐使用该能力进行跨平台的镜像构建。
例如，执行 `docker buildx build` 命令时加上 `--platform=linux/arm64` 参数即可构建出 arm64 架构镜像。这极大方便了那些没有arm64 架构机器却想构建 arm64 架构镜像的用户。

> 当前本项目仅支持构建 linux/amd64 和 linux/arm64 两种平台架构的镜像
> buildx 的 builder driver 可以使用默认的 `docker` 类型, 若使用 `docker-container` 类型可以支持并行构建多种架构, 本文不再赘述, 有兴趣可以自行了解。参考 [Docker Buildx | Docker Documentation](https://docs.docker.com/buildx/working-with-buildx/#build-multi-platform-images)

**前提要求**

以当前机器为 amd64 (x86_64)架构为例。需要开启 docker 的 buildx 特性，以及开启 Linux 的 QEMU 用户模式：

> 使用 WSL2 的 Windows 用户如果安装了最新的 DockerDesktop, 则这些前提要求已满足, 无需额外下述设置。 

1. 安装 docker buildx 客户端插件：
   > docker 版本要求 >=19.03
   
   若已安装, 则跳过。详情参考 https://github.com/docker/buildx

2. 开启 QEMU 的用户模式功能, 并安装其它平台的模拟器:
   > Linux 内核要求 >=4.8

   使用 `tonistiigi/binfmt` 镜像可快速开启并安装模拟器，执行下面命令:

   ```shell
   docker run --privileged --rm tonistiigi/binfmt --install all
   ```

现在就可以愉快地开始构建了，构建命令示例:

```shell
docker buildx build --platform=linux/amd64,linux/arm64 -t keking/kkfileview-base:4.4.0 --push .
```
