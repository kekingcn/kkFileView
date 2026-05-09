<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>draw.io 文件预览</title>
    <#include "*/commonHeader.ftl">
    <script src="js/base64.min.js" type="text/javascript"></script>
    <style>
        body {
            margin: 0;
            overflow: hidden;
        }
        iframe {
            display: block;
            width: 100%;
            border: none;
        }
    </style>
</head>
<body>
<iframe id="drawioFrame" title="draw.io 预览"></iframe>

<#if currentUrl?contains("http://") || currentUrl?contains("https://")>
    <#assign finalUrl = "${currentUrl}">
<#else>
    <#assign finalUrl = "${baseUrl}${currentUrl}">
</#if>

<script>
    (function() {
        // 获取最终文件地址
        var fileUrl = '${finalUrl}';
        var kkagent = '${kkagent}';
        var baseUrl = '${baseUrl}';
        if (!baseUrl.endsWith('/')) baseUrl += '/';

        // 跨域或代理处理
        if (kkagent === 'true' || !fileUrl.startsWith(baseUrl)) {
            fileUrl = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(fileUrl)) + "&key=${kkkey}";
        }

        var encodedUrl = encodeURIComponent(fileUrl);
        var drawioBase = baseUrl + "drawio/index.html";

        // 构建查询参数（保留原有所有参数，增加 file=）
        var params = new URLSearchParams({
            lightbox: '1',
            gapi: '0',
            db: '0',
            od: '0',
            tr: '0',
            gh: '0',
            gl: '0',
            edit: '_blank',
            lang: 'zh',
            file: fileUrl   // 新增 ?file= 参数
        });

        // 最终 URL：查询参数 + 原有的 #Uhash
        var iframeSrc = drawioBase + '?' + params.toString() + '#Uhttp://127.0.0.1/1.drawio';

        var iframe = document.getElementById('drawioFrame');
        iframe.src = iframeSrc;
        iframe.height = document.documentElement.clientHeight - 10;

        // 窗口大小变化时调整 iframe 高度
        window.addEventListener('resize', function() {
            iframe.height = document.documentElement.clientHeight - 10;
        });

        // 可选：初始化水印（假设 initWaterMark 已定义）
        if (typeof initWaterMark === 'function') {
            window.addEventListener('load', initWaterMark);
        }
    })();
</script>
</body>
</html>