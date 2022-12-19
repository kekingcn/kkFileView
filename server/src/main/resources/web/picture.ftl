<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>图片预览</title>
    <#include "*/commonHeader.ftl">
    <link rel="stylesheet" href="css/viewer.min.css">
    <script src="js/viewer.min.js"></script>
    <style>
        body {
            background-color: #404040;
        }
        #image { width: 800px; margin: 0 auto; font-size: 0;}
        #image li {  display: inline-block;width: 50px;height: 50px; margin-left: 1%; padding-top: 1%;}
        /*#dowebok li img { width: 200%;}*/
    </style>
</head>
<body>

<ul id="image">
    <#list imgUrls as img>
        <#if img?contains("http://") || img?contains("https://")>
            <#assign img="${img}">
        <#else>
            <#assign img="${baseUrl}${img}">
        </#if>
        <li><img id="${img}"  url="${img}" src="${img}" style="display: none"></li>
    </#list>
</ul>

<script>
    var viewer = new Viewer(document.getElementById('image'), {
        url: 'src',
        navbar: false,
        button: false,
        backdrop: false,
        loop : true
    });
    document.getElementById("${currentUrl}").click();

    /*初始化水印*/
    window.onload = function() {
        initWaterMark();
    }
</script>
</body>

</html>
