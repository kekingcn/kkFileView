<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>office图片预览</title>
    <script src="js/lazyload.js"></script>
    <style>
        .container{
            width:100%;
        }
        .img-area{
            text-align: center
        }

    </style>
</head>
<body>
<div class="container">
    <#list imgurls as img>
        <div class="img-area">
            <img class="my-photo" alt="loading" data-src="${img}" src="images/loading.gif">
        </div>
    </#list>
</div>
<img src="images/left.png" style="position: fixed; cursor: pointer; top: 40%; left: 50px; z-index: 999;" alt="PDF预览" onclick="goForPdf()"/>
<script>
    window.onload=checkImgs;
    window.onscroll = throttle(checkImgs);
    function goForPdf() {
        var url = window.location.href;
        if (url.indexOf("officePreviewType=image") != -1) {
            url = url.replace("officePreviewType=image", "officePreviewType=pdf");
        } else {
            url = url + "&officePreviewType=pdf";
        }
        window.location.href=url;
    }
</script>
</body>
</html>