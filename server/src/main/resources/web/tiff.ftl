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
    var myp = document.getElementById('tiff');
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
       var  imageData = null;
     try{
    imageData = ctx.createImageData(canvas.width, canvas.height);
} catch(e){
  if (e.message.indexOf("CanvasRenderingContext2D")) 
{ 
       var imgObjj = new Image();
             imgObjj.src = url;
             myp.appendChild(imgObjj);
             console.log("错误:" + e);
    return;
 }
    console.log("错误:" + e);
var html = "";
html += "<head>";
html += "    <meta charset=\"utf-8\"/>";
html += "    <style type=\"text/css\">";
html += "        body {";
html += "            margin: 0 auto;";
html += "            width: 900px;";
html += "            background-color: #CCB;";
html += "        }";
html += "";
html += "        .container {";
html += "            width: 700px;";
html += "            height: 700px;";
html += "            margin: 0 auto;";
html += "        }";
html += "";
html += "        img {";
html += "            width: auto;";
html += "            height: auto;";
html += "            max-width: 100%;";
html += "            max-height: 100%;";
html += "            padding-bottom: 36px;";
html += "        }";
html += "";
html += "        span {";
html += "            display: block;";
html += "            font-size: 20px;";
html += "            color: blue;";
html += "        }";
html += "    </style>";
html += "</head>";
html += "";
html += "<body>";
html += "<div class=\"container\">";
html += "    <img src=\"images/sorry.jpg\"/>";
html += "    <span>";
html += "        该(tif)文件，系统解析错误，具体原因如下：";
html += "        <p style=\"color: red;\">文件[${file.name}]解析失败，请联系系统管理员</p>";
html += "    </span>";
html += "    <p>有任何疑问，请加入kk开源社区知识星球咨询：<a href=\"https://t.zsxq.com/09ZHSXbsQ\">https://t.zsxq.com/09ZHSXbsQ</a><br></p>";
html += "</div>";
html += "</body>";
html += "</html>";
   document.write(html);
	document.close();
    return;
}
        for (let i = 0; i < rgba.length; i++) {
            imageData.data[i] = rgba[i];
        }
        ctx.putImageData(imageData, 0, 0);
        const imgObj = document.createElement('img');
        imgObj.src = canvas.toDataURL('image/png');
        if (++p < pages.length) {
            imgObj.onload = loadOne;
        }
        myp.appendChild(imgObj);
    }

    function imgLoaded(e) {
        resp = e.target.response;
        pages = UTIF.decode(resp);
        p = 0;
        loadOne();
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
