<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>图片预览</title>
    <link rel="stylesheet" href="css/viewer.min.css">
    <script src="js/viewer.min.js"></script>
    <#include "*/commonHeader.ftl">
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
        <li><img id="${img}"  url="${img}" src="${img}" width="1px" height="1px"></li>
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
    // 修改下一页按钮的样式和位置
    $(function () {
        var outHandler = function(){
            $(this).css('background-color','rgba(0, 0, 0, 0)');
        };
        var overHandler = function(){
            $(this).css('background-color','rgba(0, 0, 0, .5)');
        };
        var next = $("li[data-action=next]");
        var prev = $("li[data-action=prev]");
        var viewerToolBar = $(".viewer-footer");
        // 覆盖按钮父类原始样式
        viewerToolBar.css("overflow", "visible");
        // 获取文档高度、宽度
        var clientHeight = window.innerHeight;
        var clientWidth = window.innerWidth;
        // 调整样式
        var styleCss = {},nextCss={},prevCss={};
        styleCss.position = "absolute";
        styleCss.top = -clientHeight;
        styleCss.width = clientWidth*0.1;
        styleCss.height = clientHeight + 52;
        // 覆盖原始样式
        styleCss.backgroundColor='rgba(0, 0, 0, 0)';
        styleCss.borderRadius='inherit';
        nextCss.right = "0";
        prevCss.left = "0";
        next.css($.extend(nextCss, styleCss));
        prev.css($.extend(prevCss, styleCss));
        next.on('mouseout',outHandler);
        next.on('mouseover',overHandler);
        prev.on('mouseout',outHandler);
        prev.on('mouseover',overHandler);
    });
    /*初始化水印*/
    window.onload = function() {
        initWaterMark();
    }
</script>
</body>

</html>
