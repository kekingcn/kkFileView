<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>PDF预览</title>
    <#include "*/commonHeader.ftl">
    <script src="js/base64.min.js" type="text/javascript"></script>
    <style>
        /* 简单全屏布局，无滚动条 */
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
        }
        iframe {
            width: 100%;
            height: 100%;
            border: none;
            display: block;
        }
        .img-preview {
            position: fixed;
            bottom: 20px;
            right: 20px;
            cursor: pointer;
            z-index: 999;
            width: 48px;
            height: 48px;
        }
    </style>
</head>
<body>

<#if pdfUrl?contains("http://") || pdfUrl?contains("https://")>
    <#assign finalUrl="${pdfUrl}">
<#else>
    <#assign finalUrl="${baseUrl}${pdfUrl}">
</#if>

<iframe id="pdfFrame" src="about:blank"></iframe>

<#if "false" == switchDisabled>
    <img class="img-preview" src="images/jpg.svg" alt="使用图片预览" title="使用图片预览" onclick="goForImage()"/>
</#if>

<script type="text/javascript">
    var url = '${finalUrl}';
    var kkagent = '${kkagent}';
    var baseUrl = '${baseUrl}'.endsWith('/') ? '${baseUrl}' : '${baseUrl}' + '/';
    if (kkagent === 'true' || !url.startsWith(baseUrl)) {
        url = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(url)) + "&key=${kkkey}";
    }
    var viewerUrl = baseUrl + "pdfjs/web/viewer.html?file=" + encodeURIComponent(url);
	var watermarkEncoded = encodeURIComponent('${watermarkTxt?js_string}');
    var highlightEncoded = encodeURIComponent('${highlightall?js_string}');
    viewerUrl += "&disablepresentationmode=${pdfPresentationModeDisable}";
    viewerUrl += "&disableopenfile=${pdfOpenFileDisable}";
    viewerUrl += "&disableprint=${pdfPrintDisable}";
    viewerUrl += "&disabledownload=${pdfDownloadDisable}";
    viewerUrl += "&disablebookmark=${pdfBookmarkDisable}";
    viewerUrl += "&disableediting=${pdfDisableEditing}";
    viewerUrl += "&watermarktxt=" + watermarkEncoded;
    viewerUrl += "&pdfhighlightall=" + highlightEncoded;
    viewerUrl += "#page=${page}";   // ?c 确保数字不包含千位分隔符
<#if "true" == pdfSidebarOpen>
	viewerUrl += "&pagemode=thumbs";
<#else>
	viewerUrl += "&pagemode=none";
</#if>
    var iframe = document.getElementById('pdfFrame');
    iframe.src = viewerUrl;

    // 图片预览切换
    function goForImage() {
        var href = window.location.href;
        if (href.indexOf("officePreviewType=pdf") !== -1) {
            href = href.replace("officePreviewType=pdf", "officePreviewType=image");
        } else {
            href += (href.indexOf('?') === -1 ? '?' : '&') + "officePreviewType=image";
        }
        window.location.href = href;
    }
</script>
</body>
</html>
