<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <style type="text/css">
        body {
            margin: 0 auto;
            width: 900px;
            background-color: #CCB;
        }

        .container {
            width: 700px;
            height: 700px;
            margin: 0 auto;
        }

        img {
            width: auto;
            height: auto;
            max-width: 100%;
            max-height: 100%;
            padding-bottom: 36px;
        }

        span {
            display: block;
            font-size: 20px;
            color: blue;
        }
    </style>
</head>

<body>
<div class="container">
    <img src="images/sorry.jpg"/>
    <span>
        该(${fileType})文件，系统暂不支持在线预览，具体原因如下：
        <p style="color: red;">${msg}</p>
    </span>
</div>
<script>
    console.log(`有任何疑问，请加：<a href="https://jq.qq.com/?_wv=1027&k=5c0UAtu">官方QQ群：613025121</a> 咨询`);
</script>
</body>
</html>