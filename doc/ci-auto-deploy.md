# kkFileView master 自动部署

当前线上 Windows 服务器的实际部署信息如下：

- 部署根目录：`C:\kkFileView-5.0`
- 运行 jar：`C:\kkFileView-5.0\bin\kkFileView-5.0.jar`
- 启动脚本：`C:\kkFileView-5.0\bin\startup.bat`
- 运行配置：`C:\kkFileView-5.0\config\test.properties`
- 健康检查地址：`http://127.0.0.1:8012/`

当前自动部署链路采用服务器拉最新源码并本机编译的方式：

1. 通过 WinRM 连接 Windows 服务器
2. 在服务器上的源码目录执行 `git fetch/reset/clean`，同步到 `origin/$KK_DEPLOY_BRANCH`（默认 `master`）
3. 使用服务器上的 JDK 21 和 Maven 执行 `mvn clean package -Dmaven.test.skip=true`
4. 备份线上 jar，替换为新构建产物
5. 使用现有 `startup.bat` 重启，并做健康检查
6. 如果健康检查失败，则自动回滚旧 jar 并重新拉起

## 需要配置的 GitHub Secrets

- `KK_DEPLOY_HOST`
- `KK_DEPLOY_USERNAME`
- `KK_DEPLOY_PASSWORD`

以下部署参数当前由 workflow 从 GitHub Secrets 读取；如果未单独配置，则使用脚本默认值：

- `KK_DEPLOY_PORT=5985`
- `KK_DEPLOY_ROOT=C:\kkFileView-5.0`
- `KK_DEPLOY_HEALTH_URL=http://127.0.0.1:8012/`

下面这些非敏感参数可以通过 workflow env 或 GitHub Variables 覆盖；未配置时会使用默认值：
- `KK_DEPLOY_REPO_URL=https://github.com/kekingcn/kkFileView.git`
- `KK_DEPLOY_BRANCH=master`
- `KK_DEPLOY_SOURCE_ROOT=C:\kkFileView-source`
- `KK_DEPLOY_JAVA_HOME=C:\Program Files\jdk-21.0.2`
- `KK_DEPLOY_GIT_EXE=C:\kkFileView-tools\git\cmd\git.exe`
- `KK_DEPLOY_MVN_CMD=C:\kkFileView-tools\maven\bin\mvn.cmd`
- `KK_DEPLOY_MAVEN_SETTINGS=`

如果服务器到 GitHub 的拉取速度不稳定，也可以把 `KK_DEPLOY_REPO_URL` 改成你自己的 Git 镜像地址。
如果服务器访问 Maven Central 不稳定，也可以通过 `KK_DEPLOY_MAVEN_SETTINGS` 指向自定义 `settings.xml`，切换到就近镜像仓库。

## 服务器前置环境

服务器需要具备以下工具：

- Git for Windows（推荐安装在 `C:\kkFileView-tools\git`）
- Apache Maven 3.9.x（推荐安装在 `C:\kkFileView-tools\maven`）
- JDK 21（当前线上已存在：`C:\Program Files\jdk-21.0.2`）

## Workflow

新增 workflow：`.github/workflows/master-auto-deploy.yml`

- 触发条件：`push` 到 `master`，或手动 `workflow_dispatch`
- 部署方式：WinRM + 服务器源码同步 + 服务器本机 Maven 编译 + jar 替换/回滚
