<!DOCTYPE HTML>
<html>
<head>
<title>${file.name}文件预览</title>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
<#include "*/commonHeader.ftl">
<script src="js/base64.min.js" type="text/javascript"></script>
<#if currentUrl?contains("http://") || currentUrl?contains("https://")>
    <#assign finalUrl="${currentUrl}">
    <#elseif currentUrl?contains("ftp://") >
   <#assign finalUrl="${currentUrl}">
<#else>
    <#assign finalUrl="${baseUrl}${currentUrl}">
</#if>
</head>
<body>
<div id="mount">
</div>

<script src="xmind/xmind.js"></script>
<script type="text/javascript">
    var url = '${finalUrl}';
    var baseUrl = '${baseUrl}'.endsWith('/') ? '${baseUrl}' : '${baseUrl}' + '/';
    if (!url.startsWith(baseUrl)) {
         url = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(url));
    }
  const init = async () => {
	var windowWidth = document.documentElement.clientWidth || document.body.clientWidth;
    	var windowHeight = document.documentElement.clientHeight || document.body.clientHeight;
	       windowWidth = windowWidth-30;
           windowHeight = windowHeight-30;
	      windowWidth =windowWidth+"px";
	    windowHeight =windowHeight+"px";
    const res = await fetch(url)
    const viewer = new XMindEmbedViewer({
      el: '#mount',
      file: await res.arrayBuffer(),
      styles: {
        'height': windowHeight,
        'width': windowWidth
      }
    })
  }
  init()
   		 /*初始化水印*/
 if (!!window.ActiveXObject || "ActiveXObject" in window)
{
}else{
 initWaterMark();
}
</script>
</body>
</html>