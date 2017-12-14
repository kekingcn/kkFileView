<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>图片预览图</title>
    <link rel="stylesheet" href="css/viewer.min.css">
    <style>
        * { margin: 0; padding: 0;}
        #dowebok { width: 800px; margin: 0 auto; font-size: 0;}
        #dowebok li { display: inline-block; width: 32%; margin-left: 1%; padding-top: 1%;}
        /*#dowebok li img { width: 200%;}*/
    </style>
</head>
<body>
<h1>如果图片质量很好，首次加载图片时间可能会有点长，请耐心等待</h1>

<ul id="dowebok">
    <li><img id="Imgbox" src="#" width="800px" height="auto"></li>
</ul>
<script src="js/viewer.min.js"></script>
<script>
    //初始化图片地址
    window.onload = function () {
//        document.getElementById("Imgbox").src = getParameter("imgurl");
        document.getElementById("Imgbox").src =document.getElementById("url").value;
    }
    var viewer = new Viewer(document.getElementById('dowebok'), {url: 'src'});
    viewer.show();
</script>
<input name="url" value="${imgurl}" type="hidden" id="url" >
</body>

</html>
