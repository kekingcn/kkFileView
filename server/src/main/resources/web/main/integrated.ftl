<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>kkFileView 接入说明</title>
    <link rel="icon" href="./favicon.ico" type="image/x-icon">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=JetBrains+Mono:wght@400;600&family=Space+Grotesk:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="css/theme.css"/>
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <link rel="stylesheet" href="css/main-pages.css"/>
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="highlight/highlight.min.js"></script>
</head>

<body class="app-shell">
<nav class="site-nav navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand" href="https://kkview.cn" target="_blank">kkFileView</a>
        </div>
        <ul class="nav navbar-nav">
            <li><a href="./index">首页</a></li>
            <li class="active"><a href="./integrated">接入说明</a></li>
            <li><a href="./record">版本发布记录</a></li>
            <li><a href="./sponsor">赞助开源</a></li>
            <li><a href="./contact">技术支持</a></li>
        </ul>
    </div>
</nav>

<div class="page-shell">
    <div class="container" role="main">
        <section class="hero-section release-hero">
            <div class="hero-copy">
                <span class="eyebrow">Integration Guide</span>
                <h1 class="hero-title">5 分钟把 kkFileView 接进你的业务项目。</h1>
                <p class="hero-subtitle hero-subtitle-inline">
                    这里按常见接入场景提供示例，方便你直接按需选用。默认假设服务地址为 <span class="text-highlight">${baseUrl}</span>。
                </p>
                <div class="note-row">
                    <span class="tag brand">HTTP / HTTPS</span>
                    <span class="tag">FTP</span>
                    <span class="tag highlight">AES</span>
                    <span class="tag warn">附加参数</span>
                </div>
                <div class="summary-grid">
                    <div class="summary-panel">
                        <strong>URL</strong>
                        <span>所有预览能力统一汇总到 `onlinePreview` 入口。</span>
                    </div>
                    <div class="summary-panel">
                        <strong>Base64</strong>
                        <span>普通接入默认对原始文件地址做 Base64 编码后再传入。</span>
                    </div>
                    <div class="summary-panel">
                        <strong>参数扩展</strong>
                        <span>支持页码、高亮、水印、密码、跨域、AES 和秘钥等控制项。</span>
                    </div>
                </div>
            </div>
        </section>

        <div class="docs-layout">
            <aside class="page-toc">
                <h3>快速导航</h3>
                <ul>
                    <li><a href="#quick-start">快速开始</a></li>
                    <li><a href="#http-preview">HTTP 文件预览</a></li>
                    <li><a href="#stream-preview">流式接口预览</a></li>
                    <li><a href="#ftp-preview">FTP 预览</a></li>
                    <li><a href="#basic-auth">Basic 鉴权</a></li>
                    <li><a href="#aes-preview">AES 加密</a></li>
                    <li><a href="#extra-params">附加参数</a></li>
                </ul>
            </aside>

            <div class="docs-content">
                <section class="doc-card" id="quick-start">
                    <div class="doc-card-header">
                        <div>
                            <span class="eyebrow">Quick Start</span>
                            <h3>接入思路</h3>
                        </div>
                        <div class="tags">
                            <span class="tag brand">推荐入口</span>
                        </div>
                    </div>
                    <p>前端只需要拿到可访问的文件 URL，然后把它编码后拼到 `${baseUrl}onlinePreview` 上即可。对于大多数业务系统，这是最快的落地路径。</p>
                    <ul>
                        <li>普通 HTTP/HTTPS 文件地址：直接 Base64 编码后传入。</li>
                        <li>下载流接口没有后缀名：补充 `fullfilename=xxx.xxx`。</li>
                        <li>鉴权或加密场景：附加 Basic、FTP、AES 等参数。</li>
                    </ul>
                </section>

                <section class="doc-card" id="http-preview">
                    <div class="doc-card-header">
                        <div>
                            <span class="eyebrow">HTTP / HTTPS</span>
                            <h3>普通文件地址预览</h3>
                        </div>
                        <button class="copy-btn" type="button" onclick="copyCode(this)">复制代码</button>
                    </div>
                    <p>适用于系统已经直接暴露出可下载文件地址的情况。前端只需要编码后打开新窗口。</p>
                    <div class="code-block">
                        <code class="language-javascript">var url = 'http://127.0.0.1:8080/file/test.txt';
window.open('${baseUrl}onlinePreview?url=' + encodeURIComponent(base64Encode(url)));</code>
                    </div>
                </section>

                <section class="doc-card" id="stream-preview">
                    <div class="doc-card-header">
                        <div>
                            <span class="eyebrow">Streaming</span>
                            <h3>流式接口预览</h3>
                        </div>
                        <button class="copy-btn" type="button" onclick="copyCode(this)">复制代码</button>
                    </div>
                    <p>很多业务系统通过 `fileId`、`code` 等参数走统一下载接口，此时原始 URL 没有后缀名，需要额外指定完整文件名。</p>
                    <div class="code-block">
                        <code class="language-javascript">var originUrl = 'http://127.0.0.1:8080/filedownload?fileId=1';
var previewUrl = originUrl + '&amp;fullfilename=test.txt';
window.open('${baseUrl}onlinePreview?url=' + encodeURIComponent(Base64.encode(previewUrl)));</code>
                    </div>
                </section>

                <section class="doc-card" id="ftp-preview">
                    <div class="doc-card-header">
                        <div>
                            <span class="eyebrow">FTP</span>
                            <h3>FTP 资源预览</h3>
                        </div>
                        <button class="copy-btn" type="button" onclick="copyCode(this)">复制代码</button>
                    </div>
                    <p>FTP 如果允许匿名访问，可以直接预览；如果需要认证，则把连接参数拼到 URL 后面传入。</p>
                    <div class="code-block">
                        <code class="language-javascript">// 匿名 FTP
var url = 'ftp://127.0.0.1/file/test.txt';
window.open('${baseUrl}onlinePreview?url=' + encodeURIComponent(Base64.encode(url)));

// 认证 FTP
var originUrl = 'ftp://127.0.0.1/file/test.txt';
var previewUrl = originUrl + '?ftp.control.port=21&amp;ftp.username=admin&amp;ftp.password=123456&amp;ftp.control.encoding=utf8';
window.open('${baseUrl}onlinePreview?url=' + encodeURIComponent(Base64.encode(previewUrl)));</code>
                    </div>
                </section>

                <section class="doc-card" id="basic-auth">
                    <div class="doc-card-header">
                        <div>
                            <span class="eyebrow">Basic Auth</span>
                            <h3>带 Basic 鉴权的 HTTP 资源</h3>
                        </div>
                        <button class="copy-btn" type="button" onclick="copyCode(this)">复制代码</button>
                    </div>
                    <p>如果文件源本身需要用户名和密码，可以直接把 Basic 鉴权参数拼到地址中，再交给 kkFileView。</p>
                    <div class="code-block">
                        <code class="language-javascript">var originUrl = 'http://127.0.0.1/file/test.txt';
var previewUrl = originUrl + '?basic.name=admin&amp;basic.pass=123456';
window.open('${baseUrl}onlinePreview?url=' + encodeURIComponent(Base64.encode(previewUrl)));</code>
                    </div>
                </section>

                <section class="doc-card" id="aes-preview">
                    <div class="doc-card-header">
                        <div>
                            <span class="eyebrow">AES</span>
                            <h3>前后端同秘钥加密接入</h3>
                        </div>
                        <button class="copy-btn" type="button" onclick="copyCode(this)">复制代码</button>
                    </div>
                    <p>如果不希望明文传递原始文件地址，可以在前端先做 AES 加密，再通过 `encryption=aes` 告知服务端按 AES 方式解密。</p>
                    <div class="code-block">
                        <code class="language-javascript">&lt;script src="${baseUrl}js/crypto-js.js"&gt;&lt;/script&gt;
&lt;script src="${baseUrl}js/aes.js"&gt;&lt;/script&gt;

function aesEncrypt(encryptString, key) {
  var keyBytes = CryptoJS.enc.Utf8.parse(key);
  var srcs = CryptoJS.enc.Utf8.parse(encryptString);
  var encrypted = CryptoJS.AES.encrypt(srcs, keyBytes, {
    mode: CryptoJS.mode.ECB,
    padding: CryptoJS.pad.Pkcs7
  });
  return encrypted.toString();
}

var key = '1234567890123456';
var url = 'http://127.0.0.1/file/test.txt';
window.open('${baseUrl}onlinePreview?url=' + encodeURIComponent(aesEncrypt(url, key)) + '&amp;encryption=aes');</code>
                    </div>
                </section>

                <section class="doc-card" id="extra-params">
                    <div class="doc-card-header">
                        <div>
                            <span class="eyebrow">Parameters</span>
                            <h3>常用附加参数</h3>
                        </div>
                        <button class="copy-btn" type="button" onclick="copyCode(this)">复制代码</button>
                    </div>
                    <p>这些参数都应该在原始 URL 编码完成之后，再附加到预览地址后面。</p>
                    <ul>
                        <li>`filePassword`：加密文件的密码。</li>
                        <li>`page`：指定预览页码。</li>
                        <li>`highlightall`：关键字高亮。</li>
                        <li>`watermarkTxt`：动态水印文本。</li>
                        <li>`forceUpdatedCache=true`：强制刷新缓存。</li>
                        <li>`kkagent=true`：需要 kkFileView 代理跨域时启用。</li>
                        <li>`usePasswordCache=true`：开启密码缓存。</li>
                        <li>`key`：实例启用秘钥后传入访问秘钥。</li>
                    </ul>
                    <div class="code-block">
                        <code class="language-javascript">var url = 'http://127.0.0.1:8080/file/test.txt';
window.open(
  '${baseUrl}onlinePreview?url=' +
  encodeURIComponent(base64Encode(url)) +
  '&amp;filePassword=123' +
  '&amp;page=1' +
  '&amp;highlightall=kkfileview' +
  '&amp;watermarkTxt=kkfileview' +
  '&amp;kkagent=false' +
  '&amp;key=123'
);</code>
                    </div>
                </section>
            </div>
        </div>
    </div>
</div>

<script>
    if (window.hljs) {
        document.querySelectorAll('.code-block code').forEach(function (block) {
            hljs.highlightBlock(block);
        });
    }

    function copyCode(button) {
        var code = button.parentNode.parentNode.querySelector('code').innerText;
        var originalText = button.textContent;
        navigator.clipboard.writeText(code).then(function () {
            button.textContent = '已复制';
            setTimeout(function () {
                button.textContent = originalText;
            }, 1500);
        });
    }
</script>
</body>
</html>
