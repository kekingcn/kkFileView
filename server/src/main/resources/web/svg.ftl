<!DOCTYPE HTML>
<html>
<head>
    <title>${file.name}文件预览</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <#include "*/commonHeader.ftl">
    <script src="js/jquery-3.6.1.min.js" type="text/javascript"></script>
    <script src="js/svg-pan-zoom.js"></script>
    <script src="js/base64.min.js"></script>
    <#if currentUrl?contains("http://") || currentUrl?contains("https://") || currentUrl?contains("ftp://")>
        <#assign finalUrl="${currentUrl}">
    <#else>
        <#assign finalUrl="${baseUrl}${currentUrl}">
    </#if>
</head>
<body>
<div id="container">
</div>
<script type="text/javascript">

	var url = '${finalUrl}';
    var baseUrl = '${baseUrl}'.endsWith('/') ? '${baseUrl}' : '${baseUrl}' + '/';
    if (!url.startsWith(baseUrl)) {
        url = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(url));
    }

      function createNewEmbed(src){
	  var lastEventListener = null;
	  var gaodu1 =$(document).height();
	  var gaodu=gaodu1-5;
          var embed = document.createElement('embed');
          embed.setAttribute('style', 'width: 99%; height: '+gaodu+'px; border:1px solid black;');
          embed.setAttribute('type', 'image/svg+xml');
          embed.setAttribute('src', src);
		  $('#container').html(embed);
         lastEventListener = function(){
            svgPanZoom(embed, {
              zoomEnabled: true,
              controlIconsEnabled: true
            });
          }
          embed.addEventListener('load', lastEventListener)
          return embed;
        }
		createNewEmbed(url);
  /*初始化水印*/
    window.onload = function () {
        initWaterMark();
    }
</script>
</body>
</html>
