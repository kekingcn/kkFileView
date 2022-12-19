<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>Tiff 图片预览</title>
    <#include "*/commonHeader.ftl">
    <link rel="stylesheet" href="css/viewer.min.css">
    <script src="js/UTIF.js"></script>
    <script src="js/base64.min.js" type="text/javascript"></script>
    <#if currentUrl?contains("http://") || currentUrl?contains("https://") || currentUrl?contains("file://")|| currentUrl?contains("ftp://")>
        <#assign finalUrl="${currentUrl}">
    <#else>
        <#assign finalUrl="${baseUrl}${currentUrl}">
    </#if>
</head>
<style type="text/css">
    body{ text-align:center}
    img{max-width: 100%;
        margin:0 auto;
        border: 2px solid #ddd;
    }
</style>
<body>
<#if "false" == pdfDownloadDisable>
    <!--endprint-->
    <button type="button" onclick="doPrint()">打印</button>
    <!--startprint-->
</#if>
<div id="tiff"></div>
<script>
    let pages;
    let p;
    let resp;
    function loadOne(e) {
        UTIF.decodeImage(resp, pages[p]);
        const rgba = UTIF.toRGBA8(pages[p]);
        const canvas = document.createElement('canvas');
        canvas.width = pages[p].width;
        canvas.height = pages[p].height;
        const ctx = canvas.getContext('2d');
        const imageData = ctx.createImageData(canvas.width, canvas.height);
        for (let i = 0; i < rgba.length; i++) {
            imageData.data[i] = rgba[i];
        }
        ctx.putImageData(imageData, 0, 0);
        const imgObj = document.createElement('img');
        imgObj.src = canvas.toDataURL('image/png');
        if (++p < pages.length) {
            imgObj.onload = loadOne;
        }
        var myp = document.getElementById('tiff');
        myp.appendChild(imgObj);
    }

    function imgLoaded(e) {
        resp = e.target.response;
        pages = UTIF.decode(resp);
        p = 0;
        loadOne();
    }

    String.prototype.startsWithh = function(str) {
        var reg = new RegExp("^" + str);
        return reg.test(this);
    }

    String.prototype.endsWithh = function(str) {
        var reg = new RegExp(str + "$");
        return reg.test(this);
    }

    var url = '${finalUrl}';
    var baseUrl = '${baseUrl}'.endsWithh('/') ? '${baseUrl}' : '${baseUrl}' + '/';
    if (!url.startsWithh(baseUrl)) {
        url = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(url));
    }
    const xhr = new XMLHttpRequest();
    xhr.open('GET', url);
    xhr.responseType = 'arraybuffer';
    xhr.onload = imgLoaded;
    xhr.send();

    /*初始化水印*/
    window.onload = function () {
        initWaterMark();
    }
</script>
</body>
</html>
