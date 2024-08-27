# Build Instructions

Since the base runtime environment for kkfileview rarely changes and takes a long time to build, while the kkfileview code itself is frequently updated, the process of building its Docker image is split into two steps:

First, create the base image for kkfileview (kkfileview-base).

Then, use kkfileview-base as the base image to build and speed up the kkfileview Docker image build and release process.

To build the base image, run the following command:

> In this example, the image tag is 4.4.0. The Dockerfile maintained in this project considers cross-platform compatibility. If you need an arm64 architecture image, run the same build command on an arm64 architecture machine.

```shell
docker build --tag keking/kkfileview-base:4.4.0 .
```



## Cross-Platform Build

`docker buildx` supports building images for multiple platform architectures on a single machine. It is recommended to use this capability for cross-platform image builds.
For example, adding the `--platform=linux/arm64` parameter when executing the `docker buildx build` command will allow you to build an arm64 architecture image. This is particularly convenient for users who want to build arm64 images but don't have an arm64 machine.

> Currently, this project only supports building images for the linux/amd64 and linux/arm64 architectures.
> The buildx builder driver can use the default `docker` type, but if you use the `docker-container` type, you can build multiple architectures in parallel. This README will not cover that in detail, you can learn more on your own. Refer to [Docker Buildx | Docker Documentation](https://docs.docker.com/buildx/working-with-buildx/#build-multi-platform-images)

**Prerequisites**

Assuming the current machine is amd64 (x86_64) architecture, you'll need to enable the docker buildx feature and enable Linux QEMU user mode:

> Windows users with WSL2 who have installed a recent version of Docker Desktop will already meet these prerequisites, so no additional setup is required.

1. Install the docker buildx client plugin:

   > Docker version >=19.03 is required.

   If it's already installed, you can skip this step. For more details, refer to https://github.com/docker/buildx.

2. Enable QEMU user mode and install emulators for other platforms:

   > Linux kernel version >=4.8 is required.

   You can quickly enable and install emulators using the tonistiigi/binfmt image by running the following command:

   ```shell
   docker run --privileged --rm tonistiigi/binfmt --install all
   ```

Now you can enjoy the building. Here’s an example build command:

```shell
docker buildx build --platform=linux/amd64,linux/arm64 -t keking/kkfileview-base:4.4.0 --push .
```
