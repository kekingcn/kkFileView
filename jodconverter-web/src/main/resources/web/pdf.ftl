<!DOCTYPE html>

<html lang="en">
<head>
    <style type="text/css">
        body{
            margin: 0;
            padding:0;
            border:0;
        }
    </style>
</head>
<body>
    <#if pdfUrl?contains("http://")>
        <#assign finalUrl="${pdfUrl}">
    <#else>
        <#assign finalUrl="${baseUrl}${pdfUrl}">
    </#if>
    <iframe src="/pdfjs/web/viewer.html?file=${finalUrl}" width="100%" frameborder="0"></iframe>

    <img src="images/left.png" style="position: fixed; cursor: pointer; top: 40%; right: 70px; z-index: 999;" alt="使用图片预览" title="使用图片预览" onclick="goForImage()"/>

</body>
<script type="text/javascript">
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