<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>Tiff 图片预览</title>
    <link rel="stylesheet" href="css/viewer.min.css">
    <script src="js/tiff.min.js"></script>
    <#include "*/commonHeader.ftl">
    <style>
        body {
            background-color: #404040;
        }

        #tiff {
            position: fixed;
            top:50%;
            left:50%;
            transform: translate(-50%,-50%);
        }

        /*#dowebok li img { width: 200%;}*/
    </style>
</head>
<body>
<input hidden id="currentUrl" value="${currentUrl}"/>
<div id="tiff">
</div>

<script>
    var xhr = new XMLHttpRequest();
    xhr.responseType = 'arraybuffer';
    xhr.open('GET', $("#currentUrl").val());
    var config = {};
    config.TOTAL_MEMORY = ${initializeMemorySize};
    Tiff.initialize(config)
    xhr.onload = function (e) {
        var tiff = new Tiff({buffer: xhr.response});
        var canvas = tiff.toCanvas();
        $("#tiff").append(canvas)
    };
    xhr.send();

    /*初始化水印*/
    window.onload = function () {
        initWaterMark();
    }
</script>
</body>

</html>
