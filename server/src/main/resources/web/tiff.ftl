<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>Tiff 图片预览</title>
    <#include "*/commonHeader.ftl">
	   <link rel="stylesheet" href="css/officePicture.css"/>
    <script src="js/UTIF.js"></script>
    <script src="js/base64.min.js" type="text/javascript"></script>
    <#if currentUrl?contains("http://") || currentUrl?contains("https://") || currentUrl?contains("file://")|| currentUrl?contains("ftp://")>
        <#assign finalUrl="${currentUrl}">
    <#else>
        <#assign finalUrl="${baseUrl}${currentUrl}">
    </#if>
</head>
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
    var url = '${finalUrl?js_string}';
	var kkagent = '${kkagent}';
    var baseUrl = '${baseUrl}'.endsWith('/') ? '${baseUrl}' : '${baseUrl}' + '/';
    if (kkagent === 'true' || !url.startsWith(baseUrl)) {
        url = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(url))+ "&key=${kkkey}";
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
// 修改异常处理部分，让旋转按钮与正常解析部分保持一致
if (e.message.indexOf("CanvasRenderingContext2D")) 
{ 
    var html = "";
    html += "<div class=\"img-area\">";
    html += "<div class=\"image-container\" style=\"position:relative;\">";
    html += '<img class="my-photo" id="page1" src="'+url+'">';
    html += "<div class=\"button-container\" style=\"position:absolute; bottom:5px; right:5px; opacity:0.1; transition:opacity 0.2s;\" onmouseover=\"this.style.opacity='0.9'\" onmouseout=\"this.style.opacity='0.1'\">";
    html += "<button class=\"nszImg\" style=\"margin-right:3px; font-size:11px; padding:2px 6px; background:rgba(255,255,255,0.9); border:1px solid #999; border-radius:2px; min-width:50px;\">1/1页</button>";
    html += "<button class=\"sszImg\" onclick=\"rotateImg('page1', true)\" style=\"font-size:11px; padding:2px 6px; background:rgba(255,255,255,0.9); border:1px solid #999; border-radius:2px;\">↻</button>";
    html += "</div>";
    html += "</div>";
    html += "</div>";
    myp.innerHTML  = html;
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
       // imgObj.id = 'page${img_index+1}';
       // imgObj.className = "my-photo";
        imgObj.src = canvas.toDataURL('image/png');
        if (++p < pages.length) {
            imgObj.onload = loadOne;
        }
         console.log(p);
        
var html = "";
html += "<div class=\"img-area\">";
html += "<div class=\"image-container\" style=\"position:relative;\">";
html += '<img class="my-photo" id="page'+p+'" src="'+canvas.toDataURL('image/png')+'">';
html += "<div class=\"button-container\" style=\"position:absolute; bottom:5px; right:5px; opacity:0.1; transition:opacity 0.2s;\" onmouseover=\"this.style.opacity='0.9'\" onmouseout=\"this.style.opacity='0.1'\">";
html += "<button class=\"nszImg\" style=\"margin-right:3px; font-size:11px; padding:2px 6px; background:rgba(255,255,255,0.9); border:1px solid #999; border-radius:2px; min-width:50px;\">"+p+"/"+pages.length+"页</button>";
html += "<button class=\"sszImg\" onclick=\"rotateImg('page"+p+"', true)\" style=\"font-size:11px; padding:2px 6px; background:rgba(255,255,255,0.9); border:1px solid #999; border-radius:2px;\">↻</button>";
html += "</div>";
html += "</div>";
html += "</div>";
const child = document.createElement('div');
child.innerHTML  = html;
myp.appendChild(child);
    }

    function imgLoaded(e) {
        resp = e;
        pages = UTIF.decode(resp);
        p = 0;
        loadOne();
    }
    const xhr = new XMLHttpRequest();
    xhr.open('GET', url);
    xhr.responseType = 'arraybuffer';
    xhr.onload = function() {
  if (xhr.status === 200) {
    imgLoaded(xhr.response);
  } else {
    console.log(`Error ${xhr.status}: ${xhr.statusText}`)
        }
};
    xhr.send();
       function rotateImg(imgId, isRotate) {
        var img = document.querySelector("#" + imgId);

        if (img.classList.contains("imgT90")) {
            img.classList.remove("imgT90");
            if (isRotate) {
                img.classList.add("imgT180");
            }
        } else if (img.classList.contains("imgT-90")) {
            img.classList.remove("imgT-90");
            if (!isRotate) {
                img.classList.add("imgT-180");
            }
        } else if (img.classList.contains("imgT180")) {
            img.classList.remove("imgT180");
            if (isRotate) {
                img.classList.add("imgT270");
            } else {
                img.classList.add("imgT90");
            }
        } else if (img.classList.contains("imgT-180")) {
            img.classList.remove("imgT-180");
            if (isRotate) {
                img.classList.add("imgT-90");
            } else {
                img.classList.add("imgT-270");
            }
        } else if (img.classList.contains("imgT270")) {
            img.classList.remove("imgT270");
            if (!isRotate) {
                img.classList.add("imgT180");
            }
        } else if (img.classList.contains("imgT-270")) {
            img.classList.remove("imgT-270");
            if (isRotate) {
                img.classList.add("imgT-180");
            }
        } else {
            if (isRotate) {
                img.classList.add("imgT90");
            } else {
                img.classList.add("imgT-90");
            }
        }
    }
    function recoveryImg(imgId) {
        document.querySelector("#" + imgId).classList.remove("imgT90", "imgT180", "imgT270", "imgT-90", "imgT-180", "imgT-270")
    }

    /*初始化水印*/
    window.onload = function () {
        initWaterMark();
    }
</script>
</body>
</html>
