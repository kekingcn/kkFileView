<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8" />
    <title>多媒体文件预览</title>
    <link rel="stylesheet" href="plyr/plyr.css" />
    <script type="text/javascript" src="plyr/plyr.js"></script>
    <script type="text/javascript" src="js/watermark.js"></script>
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
</head>
<body>
<div class="m">
    <video>
        <source src="${mediaUrl}" />
    </video>
</div>
<script>
    plyr.setup();
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