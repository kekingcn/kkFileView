<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>${file.name}3D预览</title>
    <script src="js/base64.min.js" type="text/javascript"></script>
    <#include "*/commonHeader.ftl">
    <!-- 引入 jQuery 和 3D Viewer 核心样式/脚本 -->
    <script src="js/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="website/build/website_dev/o3dv.website.min.css">
    <script type="text/javascript" src="website/build/website_dev/o3dv.website.min.js"></script>
    <style>
        /* 提示样式 */
        .toast {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: #323232;
            color: #fff;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 12px;
            z-index: 10001;
            font-family: monospace;
        }
    </style>
</head>
<#-- 根据变量计算最终模型 URL（与原有逻辑保持一致） -->
<#if currentUrl?contains("http://") || currentUrl?contains("https://") || currentUrl?contains("file://")>
    <#assign finalUrl="${currentUrl}">
<#elseif currentUrl?contains("ftp://") >
    <#assign finalUrl="${currentUrl}">
<#else>
    <#assign finalUrl="${baseUrl}${currentUrl}">
</#if>

<body>
    <!-- 3D Viewer 的 DOM 结构（从原示例中精简，保留核心容器） -->
    <input type="file" id="open_file" style="display:none;" multiple>
    <div class="header" id="header">
        <div class="title">
            <div class="title_left"></div>
            <div class="title_right" id="header_buttons"></div>
            <div class="main_file_name only_full_width" id="main_file_name"></div>
        </div>
        <div class="toolbar" id="toolbar"></div>
    </div>
    <div class="main" id="main">
        <div class="main_left_container only_full_width" id="main_left_container">
            <div class="main_navigator ov_panel_set_container" id="main_navigator"></div>
            <div class="main_splitter" id="main_navigator_splitter"></div>
        </div>
        <div class="main_viewer" id="main_viewer"></div>
        <div class="main_right_container only_full_width" id="main_right_container">
            <div class="main_splitter" id="main_sidebar_splitter"></div>
            <div class="main_sidebar ov_panel_set_right_container" id="main_sidebar"></div>
        </div>
    </div>
    <div class="intro ov_thin_scrollbar" id="intro">
        <div class="intro_content" id="intro_content">
            <div class="intro_formats">
                <div class="intro_formats_title" id="intro_formats_title"></div>
           
            </div>
        </div>
    </div>

    <script type="text/javascript">
  
        // 自定义加载逻辑（使用 fetch + Blob + ImportFiles）
        (function($) {
            // 从后端变量获取模型最终地址
           var MODEL_URL = '${finalUrl}';
		   var kkagent = '${kkagent}';
		   var baseUrl = '${baseUrl}'.endsWith('/') ? '${baseUrl}' : '${baseUrl}' + '/';
          if (kkagent === 'true' || !MODEL_URL.startsWith(baseUrl)) {
           MODEL_URL = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(MODEL_URL))+ "&key=${kkkey}" + "&fullfilename=/${file.name}";
      }
            
            function showMessage(msg, isError = false) {
                let toast = $('<div class="toast">' + msg + '</div>');
                if (isError) toast.css('background', '#d32f2f');
                $('body').append(toast);
                setTimeout(() => toast.fadeOut(300, () => toast.remove()), 3000);
            }
            
            async function loadModelFromUrl(modelUrl) {
              
                try {
                    const response = await fetch(modelUrl, { mode: 'cors', credentials: 'same-origin' });
                    if (!response.ok) throw new Error(`HTTP ${response.status}`);
                    const blob = await response.blob();
                    const fileName = modelUrl.split('/').pop() || 'model.bin';
                    const file = new File([blob], fileName, { type: blob.type || 'application/octet-stream' });
                    
                    const dataTransfer = new DataTransfer();
                    dataTransfer.items.add(file);
                    const fileList = dataTransfer.files;
                    
                    let imported = false;
                    if (OV.Website && typeof OV.Website.ImportFiles === 'function') {
                        OV.Website.ImportFiles(fileList);
                        imported = true;
                    } else if (OV.Website && typeof OV.Website.LoadFiles === 'function') {
                        OV.Website.LoadFiles(fileList);
                        imported = true;
                    } else {
                        let viewer = null;
                        if (OV.ViewerManager && typeof OV.ViewerManager.getViewer === 'function') {
                            viewer = OV.ViewerManager.getViewer();
                        } else {
                            const viewerElem = document.getElementById('main_viewer');
                            if (viewerElem && viewerElem.__viewer) viewer = viewerElem.__viewer;
                        }
                        if (viewer && typeof viewer.ImportFiles === 'function') {
                            viewer.ImportFiles(fileList);
                            imported = true;
                        } else if (viewer && typeof viewer.LoadFiles === 'function') {
                            viewer.LoadFiles(fileList);
                            imported = true;
                        }
                    }
                    
                    if (!imported) {
                        const fileInput = document.getElementById('open_file');
                        if (fileInput) {
                            const dt = new DataTransfer();
                            dt.items.add(file);
                            fileInput.files = dt.files;
                            fileInput.dispatchEvent(new Event('change', { bubbles: true }));
                            imported = true;
                        }
                    }
                    
                    if (imported) {
                        showMessage(`✅ 已加载: ${fileName}`);
                    } else {
                        throw new Error('无法将文件传递给查看器');
                    }
                } catch (err) {
                    console.error(err);
                    showMessage(`❌ 加载失败: ${err.message}`, true);
                }
            }
            
            $(window).on('load', function() {
                // 等待查看器核心初始化完成后再加载模型
                setTimeout(() => {
                    if (MODEL_URL && MODEL_URL !== '') {
                        loadModelFromUrl(MODEL_URL);
                    } else {
                        showMessage('❌ 模型地址为空', true);
                    }
                }, 600);
            });
        })(jQuery);
    </script>
    
    <script type="text/javascript">
        // 启动 3D Viewer（注意：必须在 DOM 加载后执行，但脚本位置已在 body 底部）
        OV.StartWebsite();
    </script>

    <script type="text/javascript">
        /* 初始化水印（保留原逻辑） */
        if (!!window.ActiveXObject || "ActiveXObject" in window) {
            // IE 不支持水印
        } else {
            initWaterMark();
        }
       
    </script>
</body>
</html>