<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>多媒体文件预览</title>
    <script src="js/flv.min.js"type="text/javascript"></script>
    <script src="js/watermark.js" type="text/javascript"></script>
</head>
<style>
    * {
        margin: 0;
        padding: 0;
    }
    html, body {
        height: 100%;
        width: 100%;
    }
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
        var watermarkTxt = '${watermarkTxt}';
        if (watermarkTxt !== '') {
            watermark.init({
                watermark_txt: '${watermarkTxt}',
                watermark_x: 0,
                watermark_y: 0,
                watermark_rows: 0,
                watermark_cols: 0,
                watermark_x_space: ${watermarkXSpace},
                watermark_y_space: ${watermarkYSpace},
                watermark_font: '${watermarkFont}',
                watermark_fontsize: '${watermarkFontsize}',
                watermark_color:'${watermarkColor}',
                watermark_alpha: ${watermarkAlpha},
                watermark_width: ${watermarkWidth},
                watermark_height: ${watermarkHeight},
                watermark_angle: ${watermarkAngle},
            });
        }
    }
</script>
</body>

</html>
