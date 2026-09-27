<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>图片预览</title>
    <#include "*/commonHeader.ftl">
    <link rel="stylesheet" href="css/viewer.min.css">
    <script src="js/viewer.min.js"></script>
    <script src="js/base64.min.js"></script>
    <style>
        body {
            background-color: #f1f3f5;
        }
        .viewer-container:focus {
            outline: none !important;
        }
        .viewer-container:focus-visible {
            outline: 2px solid rgba(95, 107, 122, 0.65) !important;
            outline-offset: 2px;
            box-shadow: 0 0 0 4px rgba(95, 107, 122, 0.14);
        }
        #image { width: 800px; margin: 0 auto; font-size: 0;}
        #image li {  display: inline-block;width: 50px;height: 50px; margin-left: 1%; padding-top: 1%;}
        /*#dowebok li img { width: 200%;}*/
    </style>
</head>
<body>

<ul id="image">
    <#list imgUrls as img>
    <#if img?contains("http://") || img?contains("https://")|| img?contains("ftp://")|| img?contains("file://")>
    <#assign finalUrl="${img}">
    <#else>
    <#assign finalUrl="${baseUrl}${img}">
    </#if>
    <li><div src="${finalUrl}" data-original-url="${finalUrl}" style="display: none"></li>
    </#list>
</ul>

<script>
    // 获取反代配置
    var kkagent = '${kkagent}';
    // 处理图片URL，如果需要反代则替换URL
    function processImageUrls() {
        var imageElements = document.querySelectorAll('#image li div');
        
        imageElements.forEach(function(imgDiv) {
            var originalUrl = imgDiv.getAttribute('data-original-url');
            var finalUrl = originalUrl;
            
            // 检查是否需要反代
            if (kkagent === 'true') {
                finalUrl = '${baseUrl}' + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(originalUrl));
            }
            
            // 更新src属性
            imgDiv.setAttribute('src', finalUrl);
        });
    }
    
    // 从原始图片 URL 提取文件名（优先用 data-original-url，避免受反代 / CORS 代理 URL 影响）
    function getImageNameFromOriginalUrl(imageElement) {
        var originalUrl = imageElement.getAttribute('data-original-url') || '';
        // 去除查询串与锚点
        var noQuery = originalUrl.split('?')[0].split('#')[0];
        // 取路径最后一段作为文件名（兼容 / 与 \）
        var lastSep = Math.max(noQuery.lastIndexOf('/'), noQuery.lastIndexOf('\\'));
        var name = lastSep >= 0 ? noQuery.substring(lastSep + 1) : noQuery;
        return name || 'image';
    }

    // 初始化图片查看器
    function initImageViewer() {
        var viewer = new Viewer(document.getElementById('image'), {
            url: 'src',
            navbar: false,
            button: false,
            backdrop: false,
            loop: true,
            // #787: Viewer.js 的 title 回调拿到的 `image` 是它内部新建的 <img>（见 viewer.min.js
            // 的 view(): `var image = document.createElement('img')`），并不是原始 <div>。Viewer
            // 在构建缩略图与查看大图时只透传 `inheritedAttributes` 里的属性，而默认值不含
            // data-original-url，所以若不显式加入，getImageNameFromOriginalUrl 在该 <img> 上永远
            // getAttribute('data-original-url') == null，标题会恒为 'image'（修复形同虚设）。
            // 因此必须把 data-original-url 加进 inheritedAttributes，让原始 URL 随缩略图→大图透传。
            inheritedAttributes: ['crossOrigin', 'decoding', 'isMap', 'loading', 'referrerPolicy', 'sizes', 'srcset', 'useMap', 'data-original-url'],
            // 从 data-original-url 派生标题文件名（避免受反代 / CORS 代理 URL 影响）
            title: function (image, imageData) {
                return getImageNameFromOriginalUrl(image);
            }
        });
        viewer.view(0); // 0 是图片的索引，如果你想点击第一张图片，索引为 0
    }
    
    // 页面加载完成后初始化
    document.addEventListener('DOMContentLoaded', function () {
        // 先处理图片URL
        processImageUrls();
        
        // 然后初始化图片查看器
        initImageViewer();
    });
    
    /*初始化水印*/
    window.onload = function() {
        initWaterMark();
    }
</script>
</body>
</html>
