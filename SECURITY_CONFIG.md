# kkFileView 安全配置指南

## ⚠️ 重要安全更新

从 4.4.0 之后版本开始，kkFileView 增强了安全性，默认拒绝所有未配置的外部文件预览请求，以防止 SSRF（服务器端请求伪造）攻击。

## 🔒 安全配置说明

### 1. 信任主机白名单配置（推荐）

在 `application.properties` 中配置允许预览的域名：

```properties
# 方式1：通过配置文件
trust.host = kkview.cn,yourdomain.com,cdn.example.com,*.cdn.example.com

# 方式2：通过环境变量
KK_TRUST_HOST=kkview.cn,yourdomain.com,cdn.example.com,*.cdn.example.com
```

**示例场景**：
- 只允许预览来自 `oss.aliyuncs.com` 和 `cdn.example.com` 的文件
```properties
trust.host = oss.aliyuncs.com,cdn.example.com
```
- 允许预览来自 `example.com` 的域名和 `example.com` 与 `cdn.example.com` 子域名的文件
```properties
trust.host = example.com,*.example.com,*.cdn.example.com
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
not.trust.host = malicious-site.com,spam-domain.net,*.spam-domain.net
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
trust.host = your-cdn.com,your-storage.com,*.your-storage.com

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

```properties
trust.host = *.example.com,*.cdn.example.com
```

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
