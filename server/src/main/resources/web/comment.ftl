<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0"/>
    <title>kkFileView相关交流</title>
    <link rel="icon" href="./favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="css/viewer.min.css"/>
    <link rel="stylesheet" href="css/loading.css"/>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css"/>
    <link rel="stylesheet" href="css/theme.css"/>
    <link rel="stylesheet" href="gitalk/gitalk.css"/>
    <script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
    <script type="text/javascript" src="js/jquery.form.min.js"></script>
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="gitalk/gitalk.min.js"></script>
</head>

<body>

    <!-- Fixed navbar -->
    <nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="https://kkfileview.keking.cn" target='_blank'>kkFileView</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li><a href="./index">首页</a></li>
            <li><a href="./record">版本发布记录</a></li>
            <li class="active"><a href="./comment">相关交流</a></li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container theme-showcase" role="main">
        <#--  相关交流  -->
        <div class="page-header">
            <h1>相关交流</h1>
        </div>

        <div class="panel-body">
            <div id="comments"></div>
        </div>
    </div>

     <div class="loading_container">
        <div class="spinner">
            <div class="spinner-container container1">
                <div class="circle1"></div>
                <div class="circle2"></div>
                <div class="circle3"></div>
                <div class="circle4"></div>
            </div>
            <div class="spinner-container container2">
                <div class="circle1"></div>
                <div class="circle2"></div>
                <div class="circle3"></div>
                <div class="circle4"></div>
            </div>
            <div class="spinner-container container3">
                <div class="circle1"></div>
                <div class="circle2"></div>
                <div class="circle3"></div>
                <div class="circle4"></div>
            </div>
        </div>
    </div>
<script>
    $(function () {
        var gitalk = new Gitalk({
            clientID: '525d7f16e17aab08cef5',
            clientSecret: 'd1154e3aee5c8f1cbdc918b5c97a4f4157e0bfd9',
            repo: 'kkFileView',
            owner: 'kekingcn',
            admin: ['kekingcn,klboke,gitchenjh'],
            language: 'zh-CN',
            id: location.pathname,
            distractionFreeMode: false
        })
        gitalk.render((document.getElementById('comments')))
    });
</script>
</body>
</html>
