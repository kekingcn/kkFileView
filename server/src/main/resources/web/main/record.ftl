<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0"/>
    <title>kkFileView版本记录</title>
    <link rel="icon" href="./favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="css/viewer.min.css"/>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css"/>
    <link rel="stylesheet" href="css/theme.css"/>
    <script type="text/javascript" src="js/jquery-3.6.1.min.js"></script>
    <script type="text/javascript" src="js/jquery.form.min.js"></script>
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
</head>

<body>

<!-- Fixed navbar -->
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar"
                    aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="https://kkview.cn" target='_blank'>kkFileView</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
            <ul class="nav navbar-nav">
                <li><a href="./index">首页</a></li>
                <li><a href="./integrated">接入说明</a></li>
                <li class="active"><a href="./record">版本发布记录</a></li>
                <li><a href="./sponsor">赞助开源</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container theme-showcase" role="main">
    <#--  版本发布记录  -->
    <div class="page-header">
        <h1>版本发布记录</h1>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2023年04月18日，v4.2.1 版本</h3>
        </div>
        <div class="panel-body">
            <div>
                1. 修复 dwg 等 CAD 类型文件报空指针的 bug<br>
            </div>
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2023年04月13日，v4.2.0 版本</h3>
        </div>
        <div class="panel-body">
            <div>
                1. 新增 SVG 格式文件预览支持<br>
                2. 新增加密的 Office 文件预览支持<br>
                3. 新增加密的 zip、rar 等压缩包文件预览支持<br>
                4. 新增 xmind 软件模型文件预览支持<br>
                5. 新增 bpmn 工作流模型文件预览支持<br>
                6. 新增 eml 邮件文件预览支持<br>
                7. 新增 epub 电子书文件预览支持<br>
                8. 新增 dotm,ett,xlt,xltm,wpt,dot,xlam,xla,dotx 等格式的办公文档预览支持<br>
                9. 新增 obj, 3ds, stl, ply, gltf, glb, off, 3dm, fbx, dae, wrl, 3mf, ifc, brep, step, iges, fcstd, bim 等 3D 模型文件预览支持<br>
                10. 新增可配置限制高风险文件上传的功能，比如 exe 文件<br>
                11. 新增可配置站点的备案信息<br>
                12. 新增演示站点删除文件需要密码的功能<br>
                13. 文本文档预览加入缓存<br>
                14. 美化 404、500 报错页<br>
                15. 优化发票等 ofd 文件预览的印证渲染兼容性<br>
                16. 移除 office-plugin 模块, 使用新版 jodconverter组件<br>
                17. 优化 Excel 文件的预览效果<br>
                18. 优化 CAD 文件的预览效果<br>
                19. 更新 xstream 、junrar、pdfbox 等依赖的版本<br>
                20. 更新 TIF 文件转换 PDF 的插件，添加转换缓存<br>
                21. 优化演示页 UI 部署<br>
                22. 压缩包文件预览支持目录<br>
                23. 修复部分接口 XSS 问题<br>
                24. 修复控制台打印的演示地址不跟着 content-path 配置走的问题<br>
                25. 修复 ofd 文件预览跨域问题<br>
                26. 修复内部自签证书 https 协议 url 文件无法下载的问题<br>
                27. 修复特殊符号的文件无法删除的问题<br>
                28. 修复 PDF 转图片,内存无法回收导致的 OOM<br>
                29. 修复 xlsx7.4 以上版本文件预览乱码的问题<br>
                30. 修复 TrustHostFilter 未拦截跨域接口的问题，这是一个安全问题，有使用到 TrustHost 功能的务必升级<br>
                31. 修复压缩包文件预览在 Linux 系统下文件名乱码的问题<br>
                32. 修复 ofd 文件预览页码只能显示 10 页的问题<br>
            </div>
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2022年12月14日，v4.1.0 版本</h3>
        </div>
        <div class="panel-body">
            <div>
                1. 全新首页视觉 @wsd7747 <br>
                2. tif图片预览兼容多页tif的pdf转换、jpg转换，以及jpg在线多页预览功能 @zhangzhen1979<br>
                3. 优化docker构建方案，使用分层构建方式 @yl-yue<br>
                4. 实现基于userToken缓存加密文件 @yl-yue<br>
                5. 实现加密word、ppt、excel文件预览 @yl-yue<br>
                6. Linux & Docker镜像升级LibreOffice 7.3<br>
                7. 更新OFD预览组件、更新tif预览组件、更新PPT水印支持<br>
                8. 大量其他升级优化 & 已知问题修复<br>
                <br>
                感谢 @yl-yue @wsd7747 @zhangzhen1979 @tomhusky @shenghuadun @kischn.sun 的代码贡献
            </div>
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2021年7月6日，v4.0.0 版本</h3>
        </div>
        <div class="panel-body">
            <div>
                1. 底层集成OpenOffice替换为LibreOffice，Office文件兼容性增强，预览效果提升<br>
                2. 修复压缩文件目录穿越漏洞<br>
                3. 修复PPT预览使用PDF模式无效<br>
                4. 修复PPT图片预览模式前端显示异常<br>
                5. 新增功能：首页文件上传功能可通过配置实时开启或禁用<br>
                6. 优化增加Office进程关闭日志<br>
                7. 优化Windows环境下，查找Office组件逻辑(内置的LibreOffice优先)<br>
                8. 优化启动Office进程改同步执行
            </div>
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2021年6月17日，v3.6.0版本</h3>
        </div>
        <div class="panel-body">
            <div>
                ** ofd 类型文件支持版本，本次版本重要功能均由社区开发贡献，感谢 @gaoxingzaq、@zhangxiaoxiao9527 的代码贡献
                **<br>
                1. 新增 ofd 类型文件预览支持，ofd 是国产的类似 pdf 格式的文件<br>
                2. 新增了 ffmpeg 视频文件转码预览支持，打开转码功能后，理论上支持所有主流视频的预览，如 rm、rmvb、flv 等<br>
                3. 美化了 ppt、pptx 类型文件预览效果，比之前版本好看太多<br>
                4. 更新了 pdfbox、xstream、common-io 等依赖的版本
            </div>
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2021年1月28日</h3>
        </div>
        <div class="panel-body">
            <div>
                ** 2020农历年最后一个版本发布，主要包含了部分 UI 改进，和解决了 QQ 群友、 Issue 里反馈的 Bug
                修复，最最重要的是发个新版，过个好年 **<br>
                1. 引入galimatias,解决不规范文件名导致文件下载异常<br>
                2. 更新index接入演示界面UI风格<br>
                3. 更新markdown文件预览UI风格<br>
                4. 更新XML文件预览UI风格，调整类文本预览架构，更方便扩展<br>
                5. 更新simTxT文件预览UI风格<br>
                6. 调整多图连续预览上下翻图的UI<br>
                7. 采用apache-common-io包简化所有的文件下载io操作<br>
                8. XML文件预览支持切换纯文本模式<br>
                9. 增强url base64解码失败时的提示信息<br>
                10. 修复导包错误以及图片预览 bug<br>
                11. 修复发行包运行时找不到日志目录的问题<br>
                12. 修复压缩包内多图连续预览的bug<br>
                13. 修复大小写文件类型后缀没通用匹配的问题<br>
                14. 指定Base64转码采用Apache Commons-code中的实现，修复base64部分jdk版本下出现的异常<br>
                15. 修复类文本类型HTML文件预览的bug<br>
                16. 修复：dwg文件预览时无法在jpg和pdf两种类型之间切换<br>
                17. escaping of dangerous characters to prevent reflected xss<br>
                18. 修复重复编码导致文档转图片预览失败的问题&编码规范
            </div>
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2020年12月27日</h3>
        </div>
        <div class="panel-body">
            <div>
                ** 2020年年终大版本更新，架构全面设计，代码全面重构，代码质量全面提升，二次开发更便捷，欢迎拉源码品鉴，提issue、pr共同建设
                **<br>
                1. 架构模块调整,大量的代码重构，代码质量提升N个等级，欢迎品鉴<br>
                2. 增强XML文件预览效果，新增XML文档数结构预览<br>
                3. 新增markdown文件预览支持，预览支持md渲染和源文本切换支持<br>
                4. 切换底层web server为jetty，解决这个issue：<a href="https://github.com/kekingcn/kkFileView/issues/168">#issues/168</a><br>
                5. 引入cpdetector，解决文件编码识别问题<br>
                6. url采用base64+urlencode双编码，彻底解决各种奇葩文件名预览问题<br>
                7. 新增配置项office.preview.switch.disabled，控制offic文件预览切换开关<br>
                8. 优化文本类型文件预览逻辑，采用Base64传输内容，避免预览时再次请求文件内容<br>
                9. office预览图片模式禁用图片放大效果，达到图片和pdf预览效果一致的体验<br>
                10. 直接代码静态设置pdfbox兼容低版本jdk，在IDEA中运行也不会有警告提示<br>
                11. 移除guava、hutool等非必须的工具包，减少代码体积<br>
                12. Office组件加载异步化，提速应用启动速度最快到5秒内<br>
                13. 合理设置预览消费队列的线程数<br>
                14. 修复压缩包里文件再次预览失败的bug<br>
                15. 修复图片预览的bug
            </div>
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2020年05月20日</h3>
        </div>
        <div class="panel-body">
            <div>
                1. 新增支持全局水印，并支持通过参数动态改变水印内容<br>
                2. 新增支持CAD文件预览<br>
                3. 新增base.url配置，支持使用nginx反向代理和使用context-path<br>
                4. 支持所有配置项支持从环境变量里读取，方便Docker镜像部署和集群中大规模使用<br>
                5. 支持配置限信任站点（只能预览来自信任点的文件源），保护预览服务不被滥用<br>
                6. 支持配置自定义缓存清理时间（cron表达式）<br>
                7. 全部能识别的纯文本直接预览，不用再转跳下载，如.md .java .py等<br>
                8. 支持配置限制转换后的PDF文件下载<br>
                9. 优化maven打包配置，解决 .sh 脚本可能出现换行符问题<br>
                10. 将前端所有CDN依赖放到本地，方便没有外网连接的用户使用<br>
                11. 首页评论服务由搜狐畅言切换到Gitalk<br>
                12. 修复url中包含特殊字符可能会引起的预览异常<br>
                13. 修复转换文件队列addTask异常<br>
                14. 修复其他已经问题<br>
                15. 官网建设：<a href="https://kkview.cn">https://kkview.cn</a><br>
                16. 官方Docker镜像仓库建设：<a href="https://hub.docker.com/r/keking/kkfileview">https://hub.docker.com/r/keking/kkfileview</a>
            </div>
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2019年06月18日</h3>
        </div>
        <div class="panel-body">
            <div>
                1. 支持自动清理缓存及预览文件<br>
                2. 支持http/https下载流url文件预览<br>
                3. 支持FTP url文件预览<br>
                4. 加入Docker构建
            </div>
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2019年04月08日</h3>
        </div>
        <div class="panel-body">
            <div>
                1. 缓存及队列实现抽象，提供JDK和REDIS两种实现(REDIS成为可选依赖)<br>
                2. 打包方式提供zip和tar.gz包，并提供一键启动脚本
            </div>
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2018年01月19日</h3>
        </div>
        <div class="panel-body">
            <div>
                1. 大文件入队提前处理<br>
                2. 新增addTask文件转换入队接口<br>
                3. 采用redis队列，支持kkFIleView接口和异构系统入队两种方式
            </div>
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2018年01月15日</h3>
        </div>
        <div class="panel-body">
            <div>
                1. 首页新增社会化评论框
            </div>
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2018年01月12日</h3>
        </div>
        <div class="panel-body">
            <div>
                1. 新增多图片同时预览<br>
                2. 支持压缩包内图片轮番预览
            </div>
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2018年01月02日</h3>
        </div>
        <div class="panel-body">
            <div>
                1. 修复txt等文本编码问题导致预览乱码<br>
                2. 修复项目模块依赖引入不到的问题<br>
                3. 新增spring boot profile，支持多环境配置<br>
                4. 引入pdf.js预览doc等文件，支持doc标题生成pdf预览菜单，支持手机端预览
            </div>
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">2017年12月12日</h3>
        </div>
        <div class="panel-body">
            <div>
                1. 项目gitee开源:<a href="https://gitee.com/kekingcn/file-online-preview" target="_blank">https://gitee.com/kekingcn/file-online-preview</a><br>
                2. 项目github开源:<a href="https://github.com/kekingcn/kkFileView" target="_blank">https://github.com/kekingcn/kkFileView</a>
            </div>
        </div>
    </div>
</div>
<script>

</script>
</body>
</html>
