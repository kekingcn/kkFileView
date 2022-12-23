<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>OFD预览</title>
    <#include "*/commonHeader.ftl">
    <script src="js/base64.min.js" type="text/javascript"></script>
</head>
<body>
<#if currentUrl?contains("http://") || currentUrl?contains("https://")>
    <#assign finalUrl="${currentUrl}">
<#else>
    <#assign finalUrl="${baseUrl}${currentUrl}">
</#if>
<iframe src="" width="100%" frameborder="0"></iframe>
</body>
<script type="text/javascript">
    var url = '${finalUrl}';
    var baseUrl = '${baseUrl}'.endsWith('/') ? '${baseUrl}' : '${baseUrl}' + '/';
    if (!url.startsWith(baseUrl)) {
        url = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(url));
    }
    document.getElementsByTagName('iframe')[0].src = "${baseUrl}ofd/index.html?file="+ encodeURIComponent(url)+"";
    document.getElementsByTagName('iframe')[0].height = document.documentElement.clientHeight - 10;
    /**
     * 页面变化调整高度
     */
    window.onresize = function () {
        var fm = document.getElementsByTagName("iframe")[0];
        fm.height = window.document.documentElement.clientHeight - 10;
    }


    /*初始化水印*/
    window.onload = function () {
        initWaterMark();
    }
</script>
</html>
