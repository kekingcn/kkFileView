<!DOCTYPE html>

<html lang="en" xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>接入说明</title>
    <link rel="icon" href="./favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="css/theme.css"/>
    <script type="text/javascript" src="js/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
</head>

<body>

<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand" href="https://kkview.cn" target='_blank'>kkFileView</a>
        </div>
        <ul class="nav navbar-nav">
            <li><a href="./index">首页</a></li>
            <li class="active"><a href="./integrated">接入说明</a></li>
            <li><a href="./record">版本发布记录</a></li>
            <li><a href="./sponsor">赞助开源</a></li>
        </ul>
    </div>
</nav>

<div class="container theme-showcase" role="main">
    <#--  接入说明  -->
    <div class="page-header">
        <h1>接入说明</h1>
        本文档针对前端项目接入 kkFileView 的说明，并假设 kkFileView 的服务地址为：http://127.0.0.1:8012。
    </div>
    <div class="well">

        <div style="font-size: 16px;">
            【http/https 资源文件预览】如果你的项目需要接入文件预览项目，达到对docx、excel、ppt、jpg等文件的预览效果，那么通过在你的项目中加入下面的代码就可以成功实现：
            <p style="background-color: #2f332a;color: #cccccc;font-size: 14px;padding:10px;margin-top:10px;">
                var url = 'http://127.0.0.1:8080/file/test.txt'; //要预览文件的访问地址 <br>
                window.open('${baseUrl}onlinePreview?url='+encodeURIComponent(base64Encode(url)));
            </p>
        </div>
        <br>
        <div style="font-size: 16px;">
            【http/https 流资源文件预览】很多系统内不是直接暴露文件下载地址，而是请求通过id、code等参数到通过统一的接口，后端通过id或code等参数定位文件，再通过OutputStream输出下载，此时下载url是不带文件后缀名的，预览时需要拿到文件名，传一个参数fullfilename=xxx.xxx来指定文件名，示例如下
            <p style="background-color: #2f332a;color: #cccccc;font-size: 14px;padding:10px;margin-top:10px;">
                var originUrl = 'http://127.0.0.1:8080/filedownload?fileId=1'; //要预览文件的访问地址<br>
                var previewUrl = originUrl + '&fullfilename=test.txt'<br>
                window.open('${baseUrl}onlinePreview?url='+encodeURIComponent(Base64.encode(previewUrl)));
            </p>
        </div>
        <br>
         <div style="font-size: 16px;">
            【ftp 资源文件预览】如果要预览的FTP url是可以匿名访问的（不需要用户名密码），则可以直接通过下载url预览，示例如下
            <p style="background-color: #2f332a;color: #cccccc;font-size: 14px;padding:10px;margin-top:10px;">
                var url = 'ftp://127.0.0.1/file/test.txt'; //要预览文件的访问地址<br>
                window.open('${baseUrl}onlinePreview?url='+encodeURIComponent(Base64.encode(url)));
            </p>
        </div>
        <br>
        <div style="font-size: 16px;">
            【ftp 加密资源文件预览】如果 FTP 需要认证访问服，可以通过在 url 中加入用户名密码等参数预览，示例如下
            <p style="background-color: #2f332a;color: #cccccc;font-size: 14px;padding:10px;margin-top:10px;">
                var originUrl = 'ftp://127.0.0.1/file/test.txt'; //要预览文件的访问地址<br>
                var previewUrl = originUrl + '?ftp.control.port=xx&ftp.username=xx&ftp.password=xx&ftp.control.encoding=(gbk,utf8等)'; //(为了安全强烈建议在配置中设置相关信息)<br>
                window.open('${baseUrl}onlinePreview?url='+encodeURIComponent(Base64.encode(previewUrl)));
            </p>
        </div>
            <div style="font-size: 16px;">
            【Basic 鉴权资源文件预览】如果需要认证访问服，可以通过在url中加入用户名密码等参数预览，示例如下
            <p style="background-color: #2f332a;color: #cccccc;font-size: 14px;padding:10px;margin-top:10px;">
                var originUrl = 'http://127.0.0.1/file/test.txt'; //要预览文件的访问地址<br>
                var previewUrl = originUrl + '?basic.name=admin&basic.pass=123456'; //(为了安全强烈建议在配置中设置相关信息)<br>
                window.open('${baseUrl}onlinePreview?url='+encodeURIComponent(Base64.encode(previewUrl)));
            </p>
        </div>
               <div style="font-size: 16px;">
            AES加密接入方法，示例如下
            <p style="background-color: #2f332a;color: #cccccc;font-size: 14px;padding:10px;margin-top:10px;">
              主要事项：首先引入下面js  在把url转换成AES,注意前后端key必须相同（注意：JS下载到你接入服务器的网址）<br>
            &lt;script src="${baseUrl}js/crypto-js.js"></script><br>
            &lt;script src="${baseUrl}js/aes.js"></script><br>
             function aesEncrypt(encryptString, key) { <br>
             var key = CryptoJS.enc.Utf8.parse(key); <br>
             var srcs = CryptoJS.enc.Utf8.parse(encryptString); <br>
             var encrypted = CryptoJS.AES.encrypt(srcs, key, { mode: CryptoJS.mode.ECB, padding: CryptoJS.pad.Pkcs7 }); <br>
             return encrypted.toString(); <br>
        }<br>
            var key = "1234567890123456"; // AES秘钥16位数字<br>
            var url = "http://127.0.0.1/file/test.txt";<br>
           window.open('${baseUrl}onlinePreview?url='+encodeURIComponent(aesEncrypt(url, key))+'&encryption=aes');
            </p>
        </div>
        
             <div style="font-size: 16px;">
            其他参数，示例如下 
            <p style="background-color: #2f332a;color: #cccccc;font-size: 14px;padding:10px;margin-top:10px;">
            密码参数：&filePassword=加密文件的密码<br>
            页码参数：&page=选择第几页预览<br>
            高亮参数：&highlightall=关键字 突出显示 <br>
            水印参数：&watermarkTxt=你的水印<br>
            重生参数：&forceUpdatedCache=true <br>
            跨域参数：&kkagent=true <br>
            加密缓存：&usePasswordCache=true <br>
            秘钥参数：&key= 访问秘钥 <br>
            主要事项：以上参数是把url转换成base64后面在添加<br>
            var url = 'http://127.0.0.1:8080/file/test.txt'<br>
           window.open('${baseUrl}onlinePreview?url='+encodeURIComponent(base64Encode(url))+'&filePassword=123&page=1&highlightall=kkfileview&watermarkTxt=kkfileview&kkagent=false&key=123');
            </p>
        </div>
    </div>
</div>

</body>
</html>
