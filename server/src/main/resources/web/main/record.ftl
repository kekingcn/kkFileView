<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>kkFileView 版本记录</title>
    <link rel="icon" href="./favicon.ico" type="image/x-icon">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=JetBrains+Mono:wght@400;600&family=Space+Grotesk:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="css/theme.css"/>
    <link rel="stylesheet" href="css/main-pages.css"/>
    <script type="text/javascript" src="js/jquery-3.6.1.min.js"></script>
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
</head>

<body class="app-shell">
<nav class="site-nav navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand" href="https://kkview.cn" target="_blank">kkFileView</a>
        </div>
        <ul class="nav navbar-nav">
            <li><a href="./index">首页</a></li>
            <li><a href="./integrated">接入说明</a></li>
            <li class="active"><a href="./record">版本发布记录</a></li>
            <li><a href="./sponsor">赞助开源</a></li>
            <li><a href="./contact">技术支持</a></li>
        </ul>
    </div>
</nav>

<div class="page-shell">
    <div class="container" role="main">
        <section class="hero-section release-hero">
            <div class="hero-copy">
                <span class="eyebrow">Release Timeline</span>
                <h1 class="hero-title">版本发布记录</h1>
                <p class="hero-subtitle">
                    你可以先看最新版本的升级重点，再顺着时间轴继续了解历史版本细节。
                </p>
                <div class="release-badge-row">
                    <span class="tag highlight">最新版本 v5.0.2</span>
                    <span class="tag brand">发布日期 2026-08-14</span>
                    <span class="tag warn">JDK 21+ 强制要求</span>
                    <span class="tag">安全补丁 / HTML、文件删除、PDF 转图修复</span>
                </div>
            </div>
        </section>

        <section class="release-section">
            <div class="timeline-year">2026</div>
            <div class="timeline-list">
                <article class="release-card">
                    <h3>v5.0.2</h3>
                    <div class="release-meta">
                        <span class="tag brand">2026-08-14</span>
                        <span class="tag highlight">最新稳定版本</span>
                        <span class="tag warn">建议尽快升级</span>
                    </div>
                    <div class="release-columns">
                        <div class="release-group">
                            <h4>安全修复</h4>
                            <ul class="release-list">
                                <li>HTML 文件改在不具有同源权限的 iframe 沙箱中预览，并默认禁用 JavaScript。</li>
                                <li>文件删除接口默认禁用，改用 POST，并要求显式配置密码后进行精确比较。</li>
                            </ul>
                        </div>
                        <div class="release-group">
                            <h4>修复</h4>
                            <ul class="release-list">
                                <li>刷新 ImageIO 插件，修复 PDF 转图片预览时 JBIG2 等图像读取器未被发现导致的图片丢失。</li>
                            </ul>
                        </div>
                        <div class="release-group">
                            <h4>配置调整</h4>
                            <ul class="release-list">
                                <li><code>delete.password</code> 默认改为 <code>false</code>。</li>
                                <li><code>kk.scriptjs</code> 默认改为 <code>false</code>，启用后仍保持沙箱隔离。</li>
                            </ul>
                        </div>
                        <div class="release-group">
                            <h4>升级重点</h4>
                            <ul class="release-list">
                                <li>建议所有 v5.0.1 及更早版本用户尽快升级。</li>
                                <li>继续要求 JDK 21 及以上，现有配置可直接沿用。</li>
                                <li>如需删除功能，请配置独立强密码，并将调用方式改为 POST。</li>
                            </ul>
                        </div>
                    </div>
                </article>

                <article class="release-card">
                    <h3>v5.0.1</h3>
                    <div class="release-meta">
                        <span class="tag brand">2026-07-13</span>
                        <span class="tag">上一补丁版本</span>
                        <span class="tag warn">建议尽快升级</span>
                    </div>
                    <div class="release-columns">
                        <div class="release-group">
                            <h4>安全修复</h4>
                            <ul class="release-list">
                                <li>修复 <code>/addTask</code> 未覆盖信任主机和本地目录过滤导致的 SSRF 风险。</li>
                                <li>修复 <code>/listFiles</code> 可越出演示目录导致的路径遍历和目录信息泄露。</li>
                            </ul>
                        </div>
                        <div class="release-group">
                            <h4>修复</h4>
                            <ul class="release-list">
                                <li>修复 PDF 跨域、页码、高亮、打印、打印水印及反向代理路径问题。</li>
                                <li>修复 Redis 多种运行模式的配置兼容问题。</li>
                                <li>修复 HTTP 错误处理、共享 Client 生命周期和 xlsx 数据校验解析问题。</li>
                            </ul>
                        </div>
                        <div class="release-group">
                            <h4>优化</h4>
                            <ul class="release-list">
                                <li>大型 xlsx 文件使用 Web Worker 解析，并保留主线程自动回退。</li>
                                <li>新增 <code>pdf.sidebar.open</code>，支持配置 PDF 默认侧栏状态。</li>
                                <li>Maven CI 增加 Linux、Windows、macOS 构建验证。</li>
                            </ul>
                        </div>
                        <div class="release-group">
                            <h4>升级重点</h4>
                            <ul class="release-list">
                                <li>建议所有 v5.0.0 及更早版本用户尽快升级。</li>
                                <li>继续要求 JDK 21 及以上。</li>
                                <li>现有 v5.0.0 配置可直接沿用。</li>
                            </ul>
                        </div>
                    </div>
                </article>

                <article class="release-card">
                    <h3>v5.0.0</h3>
                    <div class="release-meta">
                        <span class="tag brand">2026-04-14</span>
                        <span class="tag">5.0 功能版本</span>
                        <span class="tag warn">升级需 JDK 21+</span>
                    </div>
                    <div class="release-columns">
                        <div class="release-group">
                            <h4>优化</h4>
                            <ul class="release-list">
                                <li>优化 xlsx、图片、tif、svg、json 解析效果。</li>
                                <li>优化 FTP 多客户端接入与 marked 解析。</li>
                                <li>首页支持目录访问，并切换为 POST 服务端分页。</li>
                                <li>压缩包预览页重构为单工作区布局，支持目录折叠与右侧内嵌预览。</li>
                                <li>优化压缩包内文件类型标识，以及单图预览页展示样式。</li>
                                <li>重构演示门户页面，包括首页、接入说明、版本记录与赞助页。</li>
                            </ul>
                        </div>
                        <div class="release-group">
                            <h4>新增</h4>
                            <ul class="release-list">
                                <li>新增 msg、heic/heif、页码、高亮、AES、Basic Auth、秘钥等能力。</li>
                                <li>新增防重复转换、异步等待、上传限制与 cadviewer 转换方法。</li>
                                <li>新增 pptm 支持。</li>
                                <li>补充面向工程自动化与编码代理的仓库说明文档。</li>
                            </ul>
                        </div>
                        <div class="release-group">
                            <h4>修复</h4>
                            <ul class="release-list">
                                <li>修复压缩包路径问题与安全问题。</li>
                                <li>修复图片水印不完整。</li>
                                <li>修复 SSL 自签证书接入问题。</li>
                                <li>修复压缩包内 Office 文件重复解压后被追加写坏、导致一直加载中的问题。</li>
                                <li>Office 默认预览切到 PDF 模式，并默认展开 PDF 缩略图侧栏。</li>
                                <li>修复 OFD 表格竖线溢出导致的渲染异常，并修正 PDF.js 兼容性补丁。</li>
                            </ul>
                        </div>
                        <div class="release-group">
                            <h4>更新</h4>
                            <ul class="release-list">
                                <li>JDK 版本要求升级到 21 及以上。</li>
                                <li>前端解析链路升级：PDF、ODF、3D 模型。</li>
                                <li>后端异步转换升级：PDF、TIF、视频、CAD。</li>
                                <li>启动脚本改为自动发现当前发布包中的 jar，并同步更新 Docker 与发布辅助文档。</li>
                                <li>默认配置策略调整：Office 预览默认使用 PDF 模式，默认隐藏图片/PDF 模式切换按钮；如需保留旧的图片优先体验，请显式设置 <code>office.preview.type=image</code> 与 <code>office.preview.switch.disabled=false</code>。</li>
                                <li>信任域名配置匹配策略扩展：<code>trust.host</code> 及相关规则支持通配符与 CIDR 匹配；升级后请重新核对白名单和黑名单的匹配范围。</li>
                            </ul>
                        </div>
                    </div>
                </article>
            </div>

            <div class="timeline-year">2025</div>
            <div class="timeline-list">
                <article class="release-card">
                    <h3>v4.4.0</h3>
                    <div class="release-meta">
                        <span class="tag brand">2025-01-16</span>
                        <span class="tag">PDF 线程 / 超时 / 内存管理</span>
                        <span class="tag">ARM64 Docker</span>
                    </div>
                    <div class="release-columns">
                        <div class="release-group">
                            <h4>优化</h4>
                            <ul class="release-list">
                                <li>升级 xlsx、markdown、dcm、PDF.JS、epub 等前端解析组件。</li>
                                <li>Office 功能调整，支持批注、页码限制与水印。</li>
                                <li>自动检测 Office 安装路径，增强 LibreOffice 7.5 / 7.6 兼容。</li>
                                <li>优化 Dockerfile，支持真正跨平台构建镜像。</li>
                            </ul>
                        </div>
                        <div class="release-group">
                            <h4>新增</h4>
                            <ul class="release-list">
                                <li>新增 xlsx 打印、GZIP 压缩、CSV 前端解析、xbrl 预览。</li>
                                <li>CAD 支持转换 SVG/TIF，新增超时结束与线程管理。</li>
                                <li>增加验证码删除、Host 黑名单、Office 转换超时设置。</li>
                            </ul>
                        </div>
                        <div class="release-group">
                            <h4>修复</h4>
                            <ul class="release-list">
                                <li>修复 forceUpdatedCache、本地缓存、PDF 解密、BPMN 跨域等问题。</li>
                                <li>修复视频跨域、TXT 二次分页、Markdown 转义、EPUB 跨域。</li>
                                <li>修复压缩包穿越漏洞和多类路径 / 水印问题。</li>
                            </ul>
                        </div>
                        <div class="release-group">
                            <h4>升级重点</h4>
                            <ul class="release-list">
                                <li>PDF 预览新增签名、绘图、插图控制与搜索定位能力。</li>
                                <li>Drawio 默认改为预览模式。</li>
                                <li>ckplayer 替换旧视频播放器。</li>
                            </ul>
                        </div>
                    </div>
                </article>
            </div>

            <div class="timeline-year">2024</div>
            <div class="timeline-list">
                <article class="release-card">
                    <h3>v4.4.0-beta</h3>
                    <div class="release-meta">
                        <span class="tag brand">2024-04-15</span>
                        <span class="tag">4.4 方向预演</span>
                    </div>
                    <div class="release-columns">
                        <div class="release-group">
                            <h4>能力铺垫</h4>
                            <ul class="release-list">
                                <li>升级 OFD、xlsx、CAD、markdown、dcm、PDF.JS 与 epub 解析组件。</li>
                                <li>首页开始引入搜索、页码定位与显示内容定义能力。</li>
                                <li>加入 CSV 前端解析与 Office 转换超时配置。</li>
                            </ul>
                        </div>
                        <div class="release-group">
                            <h4>安全与稳定</h4>
                            <ul class="release-list">
                                <li>修复 forceUpdatedCache、PDF 解密后台报错与 bpmn 跨域问题。</li>
                                <li>增强视频跨域、压缩包路径、url 特殊符号与多媒体缓存清理逻辑。</li>
                                <li>加入 Host 黑名单与验证码删除能力。</li>
                            </ul>
                        </div>
                    </div>
                </article>
            </div>

            <div class="timeline-year">历史归档</div>
            <div class="archive-grid">
                <article class="archive-item">
                    <h3>2023-07-04 · v4.3.0</h3>
                    <ul>
                        <li>新增 dcm、drawio、dwg、PDF 密码、PDF DPI 自定义和 front-end xlsx 解析。</li>
                        <li>加入 pages、eps、iges、igs、dwt、dng、ifc、dwfx、stl、cf2、plt 等格式支持。</li>
                        <li>优化 OFD 兼容性、美化 TXT 分页框，升级 Linux / Windows 内置 LibreOffice 7.5.3。</li>
                    </ul>
                </article>
                <article class="archive-item">
                    <h3>2023-04-18 · v4.2.1</h3>
                    <ul>
                        <li>修复 dwg 等 CAD 类型文件空指针问题。</li>
                    </ul>
                </article>
                <article class="archive-item">
                    <h3>2023-04-13 · v4.2.0</h3>
                    <ul>
                        <li>新增 SVG、加密 Office / 压缩包、xmind、bpmn、eml、epub、3D 模型等预览支持。</li>
                        <li>新增高风险文件上传限制、站点备案配置、删除文件密码功能。</li>
                        <li>优化演示页 UI、压缩包目录浏览，修复 XSS、OFD 跨域、OOM 与乱码等问题。</li>
                    </ul>
                </article>
                <article class="archive-item">
                    <h3>2022-12-14 · v4.1.0</h3>
                    <ul>
                        <li>全新首页视觉改版。</li>
                        <li>tif 多页兼容、Docker 分层构建、加密文件基于 userToken 缓存、升级 LibreOffice 7.3。</li>
                        <li>感谢社区贡献者 @yl-yue、@wsd7747、@zhangzhen1979 等。</li>
                    </ul>
                </article>
                <article class="archive-item">
                    <h3>2021-07-06 · v4.0.0</h3>
                    <ul>
                        <li>底层集成从 OpenOffice 切换为 LibreOffice。</li>
                        <li>修复压缩目录穿越、PPT PDF 模式与图片预览异常。</li>
                        <li>首页上传能力可通过配置动态启停。</li>
                    </ul>
                </article>
                <article class="archive-item">
                    <h3>2021-06-17 · v3.6.0</h3>
                    <ul>
                        <li>新增 OFD 预览与 ffmpeg 视频转码预览支持。</li>
                        <li>美化 PPT / PPTX 预览效果并升级多个基础依赖。</li>
                    </ul>
                </article>
                <article class="archive-item">
                    <h3>2021-04-06 · v3.5.1</h3>
                    <ul>
                        <li>修复 tif / tiff 初始内存过小导致预览失败。</li>
                        <li>修复 PDF 预览模式跨域问题。</li>
                    </ul>
                </article>
                <article class="archive-item">
                    <h3>2021-03-17 · v3.5.0</h3>
                    <ul>
                        <li>新增 office-plugin 超时可配置、tiff/tif 预览、高亮代码文件预览和 wps 支持。</li>
                        <li>升级 Spring Boot 2.4.2，优化项目结构、脚本与下载 IO。</li>
                    </ul>
                </article>
                <article class="archive-item">
                    <h3>2021-01-28 · v3.3.1</h3>
                    <ul>
                        <li>更新 index、markdown、XML、simTxt 等页面 UI 风格。</li>
                        <li>修复图片、压缩包、多种编码与危险字符相关问题。</li>
                    </ul>
                </article>
                <article class="archive-item">
                    <h3>2020-12-27 · v3.3.0</h3>
                    <ul>
                        <li>大规模架构重构，增强 XML / Markdown 文本预览架构。</li>
                        <li>切换底层 web server 为 Jetty，引入 cpdetector，Base64 + urlencode 双编码。</li>
                        <li>Office 组件加载异步化，明显提速应用启动速度。</li>
                    </ul>
                </article>
                <article class="archive-item">
                    <h3>2020-08-12 · v2.2.1</h3>
                    <ul>
                        <li>支持纯文本预览原样输出，升级 pdf.js，优化 Docker 镜像底层。</li>
                        <li>预览接口同时支持 GET 和 POST。</li>
                    </ul>
                </article>
                <article class="archive-item">
                    <h3>2020-05-20 · v2.2.0</h3>
                    <ul>
                        <li>新增全局水印、CAD 预览、base.url、环境变量配置与站点信任控制。</li>
                        <li>支持缓存清理 cron、自定义限制 PDF 下载、官网和 Docker 仓库建设。</li>
                    </ul>
                </article>
                <article class="archive-item">
                    <h3>2019-06-20 / 2019-04-08</h3>
                    <ul>
                        <li>支持自动清理缓存、HTTP/HTTPS 下载流 URL、FTP URL 与 Docker 构建。</li>
                        <li>缓存及队列实现抽象，提供 JDK 与 Redis 两种实现。</li>
                    </ul>
                </article>
                <article class="archive-item">
                    <h3>2018-01 到 2017-12</h3>
                    <ul>
                        <li>项目初始阶段补齐多图预览、压缩包内图片轮播、文本编码修复与 pdf.js 预览链路。</li>
                        <li>开放 Gitee / GitHub 仓库，逐步打磨 addTask 入队接口与 Redis 队列能力。</li>
                    </ul>
                </article>
            </div>
        </section>
    </div>
</div>
</body>
</html>
