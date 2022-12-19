<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8"/>
    <title>多媒体文件预览</title>
    <#include "*/commonHeader.ftl">
    <link rel="stylesheet" href="plyr/plyr.css"/>
    <script type="text/javascript" src="plyr/plyr.js"></script>
    <style>
        body {
            background-color: #404040;
        }

        .m {
            width: 1024px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<div class="m">
    <video>
        <source src="${mediaUrl}"/>
    </video>
</div>
<script>
    plyr.setup();
    window.onload = function () {
        initWaterMark();
    }
</script>
</body>
</html>
