<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="utf-8">
    <title>PDF预览</title>
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <style type="text/css">
        body{
            margin: 0;
            padding:0;
            border:0;
        }
    </style>
</head>
<body>
    <#if pdfUrl?contains("http://") || pdfUrl?contains("https://")>
        <#assign finalUrl="${pdfUrl}">
    <#else>
        <#assign finalUrl="${baseUrl}${pdfUrl}">
    </#if>
    <iframe src="" width="100%" frameborder="0"></iframe>

<#--    <img src="images/left.png" style="position: fixed; cursor: pointer; top: 40%; right: 60px; z-index: 999;" alt="使用图片预览" title="使用图片预览" onclick="goForImage()"/>-->
    <span class="fa fa-file-image-o fa-4x" style="position: fixed; cursor: pointer; top: 40%; right: 50px; z-index: 999;" title="使用图片预览" onclick="goForImage()"></span>


</body>
<script type="text/javascript">
    document.getElementsByTagName('iframe')[0].src = "/pdfjs/web/viewer.html?file="+encodeURIComponent('${finalUrl}');
    document.getElementsByTagName('iframe')[0].height = document.documentElement.clientHeight-10;
    /**
     * 页面变化调整高度
     */
    window.onresize = function(){
        var fm = document.getElementsByTagName("iframe")[0];
        fm.height = window.document.documentElement.clientHeight-10;
    }

    function goForImage() {
        var url = window.location.href;
        if (url.indexOf("officePreviewType=pdf") != -1) {
            url = url.replace("officePreviewType=pdf", "officePreviewType=image");
        } else {
            url = url + "&officePreviewType=image";
        }
        window.location.href=url;
    }
</script>
</html>