<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>多媒体文件预览</title>
</head>
<style>
    body{background-color: #262626}
    .m{ margin-left: auto; margin-right: auto; width:1024px; margin-top: 100px; }
</style>
<body>
<div class="m">
    <video width="1024" id="videoElement"></video>
</div>
<script src="js/flv.min.js"></script>
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
</script>
</body>

</html>
