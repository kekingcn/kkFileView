# kkFileView 安全配置指南

## ⚠️ 重要安全更新

从 4.4.0 之后版本开始，kkFileView 增强了安全性，默认拒绝所有未配置的外部文件预览请求，以防止 SSRF（服务器端请求伪造）攻击。

## 🔒 安全配置说明

### 1. 信任主机白名单配置（推荐）

在 `application.properties` 中配置允许预览的域名：

```properties
# 方式1：通过配置文件
trust.host = kkview.cn,yourdomain.com,cdn.example.com

# 方式2：通过环境变量
KK_TRUST_HOST=kkview.cn,yourdomain.com,cdn.example.com
```

**示例场景**：
- 只允许预览来自 `oss.aliyuncs.com` 和 `cdn.example.com` 的文件
```properties
trust.host = oss.aliyuncs.com,cdn.example.com
```

### 2. 允许所有主机（不推荐，仅测试环境）

```properties
trust.host = *
```

⚠️ **警告**：此配置会允许访问任意外部地址，存在安全风险，仅应在测试环境使用！

### 3. 黑名单配置（高级）

禁止特定域名或内网地址：

```properties
# 禁止访问内网地址（强烈推荐）
not.trust.host = localhost,127.0.0.1,192.168.*,10.*,172.16.*,169.254.*

# 禁止特定恶意域名
not.trust.host = malicious-site.com,spam-domain.net
```

**优先级**：黑名单 > 白名单

### 4. Docker 环境配置

```bash
docker run -d \
  -e KK_TRUST_HOST=yourdomain.com,cdn.example.com \
  -e KK_NOT_TRUST_HOST=localhost,127.0.0.1 \
  -p 8012:8012 \
  keking/kkfileview:4.4.0
```

## 🛡️ 安全最佳实践

### ✅ 推荐配置

```properties
# 1. 明确配置信任主机白名单
trust.host = your-cdn.com,your-storage.com

# 2. 配置黑名单防止内网访问
not.trust.host = localhost,127.0.0.1,192.168.*,10.*,172.16.*

# 3. 禁用文件上传（生产环境）
file.upload.disable = true

# 4. 配置基础URL（使用反向代理时）
base.url = https://preview.yourdomain.com
```

### ❌ 不推荐配置

```properties
# 危险：允许所有主机访问
trust.host = *

# 危险：启用文件上传（生产环境）
file.upload.disable = false
```

## 🔍 配置验证

### 测试白名单是否生效

1. 配置白名单：
```properties
trust.host = kkview.cn
```

2. 尝试预览白名单内的文件：
```
http://localhost:8012/onlinePreview?url=https://kkview.cn/test.pdf
✅ 应该可以正常预览
```

3. 尝试预览白名单外的文件：
```
http://localhost:8012/onlinePreview?url=https://other-domain.com/test.pdf
❌ 应该被拒绝，显示"不信任的文件源"
```

### 测试黑名单是否生效

1. 配置黑名单：
```properties
not.trust.host = localhost,127.0.0.1
```

2. 尝试访问本地文件：
```
http://localhost:8012/getCorsFile?urlPath=http://127.0.0.1:8080/admin
❌ 应该被拒绝
```

## 📋 常见问题

### Q1: 升级后无法预览文件了？

**原因**：新版本默认拒绝未配置的主机。

**解决**：在配置文件中添加信任主机列表：
```properties
trust.host = your-file-server.com
```

### Q2: 如何临时恢复旧版本行为？

**不推荐**，但如果确实需要：
```properties
trust.host = *
```

### Q3: 配置了白名单但还是无法访问？

检查以下几点：
1. 域名是否完全匹配（区分大小写）
2. 是否配置了黑名单，黑名单优先级更高
3. 查看日志中的 WARNING 信息
4. 确认环境变量是否正确设置

### Q4: 如何允许子域名？

已支持通配符域名匹配，可使用 `*.example.com`：
```properties
trust.host = *.example.com
```

说明：
- `*.example.com` 会匹配 `cdn.example.com`、`api.internal.example.com`，但不匹配根域 `example.com`
- 对于 IP 风格通配（如 `192.168.*`、`10.*`），仅匹配字面量 IPv4 地址，不匹配域名

## 🧱 应用层防护 Guard Core（可选，默认关闭）

kkFileView 可以选择启用 [Guard Core](https://github.com/Guard-Core/spring-boot-guard)（spring-boot-guard，MIT），在应用内增加请求频率限制、攻击特征检测和自动封禁。它**不替代** `trust.host` / `not.trust.host` 和各个安全修复，只限制谁能访问这些接口、访问多快，并封禁持续探测的客户端。

Guard Core is an optional, off-by-default application-layer guard (rate limits, attack screening, auto-ban). It does not replace `trust.host` / `not.trust.host` or the code fixes for the advisories. It limits who can reach the routes, how fast, and bans clients that keep probing.

### 启用 / Enable

```properties
guard.enabled = true
# 或环境变量 / or: KK_GUARD_ENABLED=true
```

不设置 `guard.enabled` 或设置为 `false` 时，不会注册任何 Guard 组件，行为与之前完全一致。建议先用 `KK_GUARD_PASSIVE_MODE=true`（只记录不拦截）观察一段时间，再关闭观察模式。完整配置见 `application.properties` 的“十五、Guard Core 应用层防护”。

### 它做什么 / What it does

| 风险 / Risk | 措施 / Measure | 配置 / Setting |
|---|---|---|
| 转换、预览、远程读取、入队被刷（LibreOffice 转换消耗大量 CPU） | 每个客户端的全局和分接口请求限制，超限返回 429 | `guard.rate-limit`、`guard.endpoint-rate-limits[...]` |
| 目录穿越、注入、XSS、扫描探测（路径、查询参数、请求头、请求体，包含 Base64 解码后的 url） | 攻击特征检测，返回 400，持续触发的客户端自动封禁 | `guard.enabled-detection-categories`、`guard.auto-ban-*` |
| 反复读取不存在的远程文件 | 同一接口累计大量 404 的客户端封禁 | `guard.global-behavior-rules[0]` |
| 删除密码被猜解 | 删除失败超过 5 次的客户端封禁 1 小时 | `FileController#deleteFile` 上的 `@GuardReturnMonitor` |
| 上传请求过大或类型不对 | `/fileUpload` 只接受 `multipart/form-data`，Content-Length 超过 500MB 直接返回 413 | `FileController#fileUpload` 上的注解 |
| 写操作接口被匿名调用（上传、创建文件夹、删除、addTask） | IP 白名单和/或密钥（请求头 `X-KK-Admin-Key`），同时设置时两者都必须满足 | `KK_GUARD_ADMIN_ALLOWED_IPS`、`KK_GUARD_ADMIN_KEY` |

### 诚实的限制 / Honest limits

- 不检测 `ssrf` 类别：预览内网地址是正常用法，SSRF 仍由 `trust.host` / `not.trust.host` 负责。Guard 会解码 Base64 的 `url` 并检测解码后的内容，但 AES 加密（`encryption=aes`）的 `url` 无法检测。
- 默认不启用 `sensitive_file` 和 `recon` 类别：它们会把 `.java`、`.py`、`.sql`、`.sh`、`.jsp`、`.asp` 等源码文件的访问路径当作探测，而 kkFileView 会预览这类文件。可以用 `KK_GUARD_DETECTION_CATEGORIES` 覆盖。
- 使用 `local.preview.dir`（`file://` 预览）时，需要把 `url`、`urlPath`、`urls`、`currentUrl` 加入 `guard.excluded-detection-params`，否则 `file://` 会被当作文件包含攻击。
- 404 规则按接口统计，不是按路径统计：遍历大量不同静态路径的扫描器只会被请求限制限速，不会被封禁。
- `/fileUpload` 的 multipart 请求体不做检测（`scanBody = false`）：spring-boot-guard 1.3.0 会检测表单字段和文件部分的内容，而 kkFileView 会保存并预览 html、sql、sh 等源码，这类文件会被当作攻击拒绝。路径、查询参数和请求头仍然检测，`path` 表单字段由 `FileController` 校验。Guard 看不到上传文件部分的内容，`Content-Type` 检查的是请求而不是文件部分，文件类型仍由 `prohibit` 控制。声明的 Content-Length 达到 2GB 或以上时，引擎的大小检查会抛出异常并返回 500（请求仍然被拒绝）。
- 引擎不会封禁回环地址（127.0.0.1）：来自回环地址的探测会被拒绝，但不会被封禁。
- 计数和封禁默认保存在进程内存中：多实例之间不共享，重启后清空。需要共享时设置 `KK_GUARD_ENABLE_REDIS=true` 和 `KK_GUARD_REDIS_URL`（独立于 `cache.type=redis`）。
- 全局限制默认 600 次/分钟：预览页面会加载大量静态资源，限制按客户端地址统计，办公室出口共用一个地址时请调大 `KK_GUARD_RATE_LIMIT`。
- 响应头和 CORS 保持关闭：kkFileView 常被嵌入 iframe，Guard 的 `X-Frame-Options` 会破坏嵌入。
- 反向代理之后必须设置 `KK_GUARD_TRUSTED_PROXIES`（代理的 IP/CIDR），否则所有客户端共用代理的地址。只信任来自这些地址的 `X-Forwarded-For`。不要同时设置 `server.forward-headers-strategy=native/framework`，两者二选一；启动日志会说明当前由谁决定客户端地址。

## 🚨 安全事件响应

如果发现可疑的预览请求：

1. 检查日志文件，搜索 "拒绝访问主机" 关键字
2. 确认 `trust.host` 配置是否合理
3. 检查是否有异常的网络请求
4. 如发现攻击行为，及时更新黑名单配置

## 📞 获取帮助

- GitHub Issues: https://github.com/kekingcn/kkFileView/issues
- Gitee Issues: https://gitee.com/kekingcn/file-online-preview/issues

---

**安全提示**：定期检查和更新信任主机列表，遵循最小权限原则。
