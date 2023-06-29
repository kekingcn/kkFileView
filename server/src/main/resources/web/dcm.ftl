<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>DCM预览</title>
    <#include "*/commonHeader.ftl">
     <script src="js/base64.min.js" type="text/javascript"></script>
</head>
	<style>
     .container{
		width: 100%; 
		height: 98%;
		max-width: 98%;
		margin: auto;
         position: absolute;
        top: 0;
       left: 0;
       bottom: 0;
       right: 0;
     background-color: green;
			}
		</style>
<body>
<#if currentUrl?contains("http://") || currentUrl?contains("https://")>
    <#assign finalUrl="${currentUrl}">
<#else>
    <#assign finalUrl="${baseUrl}${currentUrl}">
</#if>
    <div class="container" id="cornerstoneViewport">

        </div>
        <script src="dcm/cornerstone.js"></script>
        <script src="dcm/cornerstoneMath.js"></script>
        <script src="dcm/cornerstoneTools.js"></script>
        <script src="dcm/dicomParser.js"></script>
        <script src="dcm/cornerstoneWADOImageLoader.bundle.min.js"></script>
        <script src="dcm/hammer.min.js"></script>
        <script src="dcm/initCornerstone.js"></script>
        <script  src="dcm/react.development.js" ></script>
        <script src="dcm/react-dom.development.js"></script>
        <script>
            "use strict";

            var process = {
                env: {
                    NODE_ENV: "production"
                }
            };

            window.process = process;
        </script>
        <script src="dcm/index.umd.js"></script>

        <script>
          var url = '${finalUrl}';
    var baseUrl = '${baseUrl}'.endsWith('/') ? '${baseUrl}' : '${baseUrl}' + '/';
    if (!url.startsWith(baseUrl)) {
        url = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(url));
    }
            "use strict";
         
            var imageNames = [];
            for (var i = 1; i < 546; i++) {
                imageNames.push(url);
            }
          //  console.log(url);
            var imageIds = imageNames.map(name => {
                 return 'dicomweb:'+url+'';
            });
            var imagePromises = imageIds.map(imageId => {
                return cornerstone.loadAndCacheImage(imageId);
            });
         
            var exampleData = {
                stack: {
                    currentImageIdIndex: 0,
                    imageIds: imageIds
                }
            };

            var CornerstoneViewport = window["react-cornerstone-viewport"];
            var props = {
                viewportData: exampleData,
                cornerstone,
                cornerstoneTools,
                activeTool: "Brush"
            };

            var app = React.createElement(CornerstoneViewport, props, null);

            ReactDOM.render(
                app,
                document.getElementById("cornerstoneViewport")
            );
             /*初始化水印*/
    window.onload = function () {
        initWaterMark();
    }
        </script>
</body>

</html>
