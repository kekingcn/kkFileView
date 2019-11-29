<!DOCTYPE html>

<html lang="en">
<head>
    <style type="text/css">
        body{
            margin: 0 auto;
            width:900px;
            background-color: #CCB;
        }
        .container{
            width: 700px;
            height: 700px;
            margin: 0 auto;
        }
        img{
            width:auto;
            height:auto;
            max-width:100%;
            max-height:100%;
            padding-bottom: 36px;
        }
        span{
            display: block;
            font-size:20px;
            color:blue;
        }
    </style>
</head>
<body>
<div class="container">
    <img src="images/sorry.jpg" />
    <span>
        该文件类型(${fileType})系统暂时不支持在线预览，<b>说明</b>：
        <p style="color: red;">${msg}</p>
        有任何疑问，请加&nbsp;<a href="https://jq.qq.com/?_wv=1027&k=5c0UAtu">官方QQ群：613025121</a>&nbsp;咨询
    </span>
</div>
</body>

</html>