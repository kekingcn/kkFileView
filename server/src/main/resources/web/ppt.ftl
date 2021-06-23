<#if RequestParameters['name']??> 
{
	"code": 1,
	"name": "pptx",
	"totalSize": 0,
	"curPage": 1,
	"totalPage": 1,
	"pageSize": 10,
	"titles": null,
	"data": [
<#assign index = 0>
<#list imgurls as img>
<#if index != 0>,</#if>{
		"uuid": null,
		"title": null,
		"content": null,
		"text": null,
		"url": "${img}",
		"destFile": null,
		"viewCount": 0,
		"downloadCount": 0,
		"ctime": null,
		"thumbUrl": "${img}",
		"largeUrl": null,
		"ratio": 0.5625,
		"note": null
	}<#assign index = index + 1>
</#list>],
	"desc": "Success"
}

<#else/>
<!DOCTYPE html>
<html lang="en">
<head>
<#if "${file.suffix?html}" == "ppt" || "${file.suffix?html}" == "pptx">
 <!DOCTYPE html>

<html lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    
    <title>ppt预览</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
   

    <!-- BOOTSTRAP STYLE start -->
    <!-- Le styles -->
    
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<link href="/pptx/bootstrap.min.css" rel="stylesheet">

        <link href="/pptx/idocv_common.min.css" rel="stylesheet">

    <link href="/pptx/jquery.contextMenu.css" rel="stylesheet">

    <!-- BOOTSTRAP STYLE end -->
    
    <script type="text/javascript">
      var windowWidth = document.documentElement.clientWidth;
      var searchStr = window.location.search.substr(1);
      if ((windowWidth < 768 || (/micromessenger/.test(navigator.userAgent.toLowerCase()))) && (!searchStr || searchStr.indexOf('type=') < 0)) {
          var redirectUrl = window.location.pathname + '?type=mobile' + (!!searchStr ? ('&' + searchStr) : '');
          window.location.replace(redirectUrl);
      }
    </script>

    <style type="text/css">
      .thumbnail{
        /*
        max-width: 200px;
        */
        cursor: pointer;
      }
    </style>
    
    <!--[if lt IE 9]>
      <script src="/static/bootstrap/js/html5shiv.js"></script>
    <![endif]-->

  </head>

  <body onload="resetImgSize();" class="ppt-body">
    
<div class="loading-mask" style="display: block;">
    <div class="loading-zone">
        <div class="text"><img src="/img/loader_indicator_lite.gif">加载中...</div>
    </div>
  
</div>

    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <!-- FILE NAME HERE -->
          <!-- SIGN UP & SIGN IN -->
          
          <div class="nav-collapse collapse">
            <p class="navbar-text pull-right">
              <a href="#" title="全屏" class="fullscreen-link"><i class="icon-fullscreen icon-white"></i></a>
            </p>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>

    <div class="container-fluid" style="max-height: 100%;">
      <div class="row-fluid">
        <div class="span2 hidden-phone" style="position: fixed; top: 60px; left: 20px; bottom: 20px; padding-right: 10px; border-right: 3px solid #c8c8c8; max-height: 100%; overflow: auto; text-align: center;">
          <!--Sidebar content-->
          <!-- 
          <div class="thumbnail">
            <img src="">
          </div>
          1/20<br />
          -->
        </div>
        <div class="span9 offset2">
          <div class="slide-img-container">
            <div class="ppt-turn-left-mask"></div>
            <div class="ppt-turn-right-mask"></div>
            <!-- 
            <img src="" class="img-polaroid" style="max-height: 100%;">
             -->
          </div>
          <!-- ONLY AVAILABLE ON MOBILE -->
          <div class="span12 visible-phone text-center" style="position: fixed; bottom: 10px; left: 0px; z-index: 1000;">
            <select class="select-page-selector span1" style="width: 80px; margin-top: 10px;">
              <!-- PAGE NUMBERS HERE -->
            </select>
          </div>
        </div>
      </div>
    </div>
    
    <div class="progress progress-striped active bottom-paging-progress">
      <div class="bar" style="width: 0%;"></div>
    </div>
    <!-- JavaSript
    ================================================== -->
    
<script src="/pptx/jquery-3.5.1.min.js"></script>
  <script src="/pptx/jquery.contextMenu.js?v=11.2.5_20210128"></script>
        <script src="/pptx/idocv_common.min.js"></script>

<script>
    var contextPath = '';
    var version = '12';
    // var urlObj = $.url($.url().attr('source').replace(contextPath, ''));
    var id = window.location.pathname.replace(contextPath, '').split('/')[2];
    var uuid = id;
    var params = getAllUrlParams(window.location.href); // 如果用urlObj.param()方法获取则被非正常解码
    // var queryStr = urlObj.attr('query'); // 参数被decode，IE下如果有中文参数则报错，需要获取原生参数
    var queryStr = window.location.search.slice(1);
    uuid = !!'' ? '' : uuid;
    var name = 'pptx';
    if (!!name) {
        params.name = name;
    }
    var reqUrl = '';
    var reqUrlMd5 = '';
    var authMap = '{}';
    var authMapStr = 'null';
    if (!!reqUrlMd5 && !!authMapStr) {
        authMap = JSON.parse(authMapStr);
    }
</script>
<!-- 客户自定义JS -->
    <script src="/pptx/jquery.mobile-events.min.js"></script>
    <script src="/pptx/ppt.js"></script>
</body>
</html>
<#else/>

  <meta charset="utf-8" />
    <title>图片预览</title>
	 <link rel="stylesheet" href="css/viewer.min.css">
	 <script src="js/lazyload.js"></script>
	 <script src="js/viewer.min.js"></script>
    <#include "*/commonHeader.ftl">
   <style>
        body {
            background-color: #404040;
        }
        #image { width: 800px; margin: 0 auto; font-size: 0;}
        #image li {  display: inline-block;width: 50px;height: 50px; margin-left: 1%; padding-top: 1%;}
        /*#dowebok li img { width: 200%;}*/
    </style>
</head>
<body>
<div class="container">
<ul id="image">
    <#list imgurls as img>
        <div class="img-area">
            <li><img id="${img}"  url="${img}" src="${img}" width="1px" height="1px"></li>
        </div>
    </#list>
	</ul>
</div>



<script>
    var viewer = new Viewer(document.getElementById('image'), {
        url: 'src',
        navbar: false,
        button: false,
        backdrop: false,
        loop : true
    });
    document.getElementById("${currentUrl}").click();
 // 修改下一页按钮的样式和位置
    $(function () {
        var outHandler = function(){
            $(this).css('background-color','rgba(0, 0, 0, 0)');
        };
        var overHandler = function(){
            $(this).css('background-color','rgba(0, 0, 0, .5)');
        };
        var next = $("li[data-action=next]");
        var prev = $("li[data-action=prev]");
        var viewerToolBar = $(".viewer-footer");
        // 覆盖按钮父类原始样式
        viewerToolBar.css("overflow", "visible");
        // 获取文档高度、宽度
        var clientHeight = window.innerHeight;
        var clientWidth = window.innerWidth;
        // 调整样式
        var styleCss = {},nextCss={},prevCss={};
        styleCss.position = "absolute";
        styleCss.top = -clientHeight;
        styleCss.width = clientWidth*0.1;
        styleCss.height = clientHeight + 52;
        // 覆盖原始样式
        styleCss.backgroundColor='rgba(0, 0, 0, 0)';
        styleCss.borderRadius='inherit';
        nextCss.right = "0";
        prevCss.left = "0";
        next.css($.extend(nextCss, styleCss));
        prev.css($.extend(prevCss, styleCss));
        next.on('mouseout',outHandler);
        next.on('mouseover',overHandler);
        prev.on('mouseout',outHandler);
        prev.on('mouseover',overHandler);
    });
    /*初始化水印*/
    window.onload = function() {
        initWaterMark();
    }
</script>

</#if>
</body>
</html>
</#if>
