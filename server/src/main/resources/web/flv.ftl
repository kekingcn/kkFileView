<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>多媒体文件预览</title>
    <#include "*/commonHeader.ftl">
    <script src="js/flv.min.js" type="text/javascript"></script>
</head>
<style>
    body {
        background-color: #404040;
    }
    .m {
        width: 1024px;
        margin: 0 auto;
    }
</style>
<body>
<div class="m">
    <video width="1024" id="videoElement"></video>
</div>
<script>
    if (flvjs.isSupported()) {
        var videoElement = document.getElementById('videoElement');
        var flvPlayer = flvjs.createPlayer({
            type: 'flv',
            url: '${mediaUrl}'
        });
        flvPlayer.attachMediaElement(videoElement);
        flvPlayer.load();
        flvPlayer.play();
    }
    /*初始化水印*/
    window.onload = function() {
      initWaterMark();
    }
</script>
</body>

</html>
