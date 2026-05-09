<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>${file.name} - 3D智能预览</title>
    <script src="js/base64.min.js" type="text/javascript"></script>
    <#include "*/commonHeader.ftl">
    <script src="js/jquery-3.6.1.min.js"></script>
    <link rel="stylesheet" type="text/css" href="website/build/website_dev/o3dv.website.min.css">
    <base href="website/">
    <script type="text/javascript" src="build/website_dev/o3dv.website.min.js"></script>
    <style>
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
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            pointer-events: none;
        }
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.6);
            z-index: 20000;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-size: 16px;
            backdrop-filter: blur(4px);
            flex-direction: column;
            gap: 12px;
        }
        .spinner {
            width: 40px;
            height: 40px;
            border: 4px solid rgba(255,255,255,0.3);
            border-top: 4px solid white;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<#-- 原始路径计算（不在这里做代理包装，代理逻辑统一在JS中处理） -->
<#if currentUrl?contains("http://") || currentUrl?contains("https://") || currentUrl?contains("file://")>
    <#assign rawModelUrl="${currentUrl}">
<#elseif currentUrl?contains("ftp://") >
    <#assign rawModelUrl="${currentUrl}">
<#else>
    <#assign rawModelUrl="${baseUrl}${currentUrl}">
</#if>

<body>
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
        (function($) {
            // ========== 后端注入变量 ==========
            var RAW_MODEL_URL = '${rawModelUrl}';          // 可能是单个URL，也可能是逗号分隔的多个URL
            var BASE_URL = '${baseUrl}'.endsWith('/') ? '${baseUrl}' : '${baseUrl}' + '/';
            var KK_AGENT = '${kkagent}' === 'true';
            var KK_KEY = '${kkkey}';
            var MODEL_FILENAME = '${file.name}';
            
            // ========== 代理方法 ==========
            function getProxiedUrl(originalUrl) {
                if (KK_AGENT || !originalUrl.startsWith(BASE_URL)) {
                    return BASE_URL + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(originalUrl)) + "&key=" + KK_KEY;
                }
                return originalUrl;
            }
            
            // 获取模型的实际下载URL（主文件）—— 仅当RAW_MODEL_URL为单个URL时有效
            var MODEL_URL = (RAW_MODEL_URL.indexOf(',') === -1) ? getProxiedUrl(RAW_MODEL_URL) : null;
            
            // ========== UI辅助 ==========
            var loadingOverlay = null;
            function showMessage(msg, isError, duration) {
                duration = duration || 3500;
                var toast = $('<div class="toast">' + msg + '</div>');
                if (isError) toast.css('background', '#d32f2f');
                $('body').append(toast);
                setTimeout(function() { toast.fadeOut(300, function() { toast.remove(); }); }, duration);
            }
            
            function showLoading(msg) {
                if (loadingOverlay) hideLoading();
                loadingOverlay = $('<div class="loading-overlay"><div class="spinner"></div><div>' + msg + '</div></div>');
                $('body').append(loadingOverlay);
            }
            
            function hideLoading() {
                if (loadingOverlay) {
                    loadingOverlay.fadeOut(200, function() { $(this).remove(); });
                    loadingOverlay = null;
                }
            }
            
            // ========== 依赖解析函数（用于单文件智能加载） ==========
            function getDependencyUrl(relativePath, baseModelUrl) {
                var baseDir = "";
                if (baseModelUrl) {
                    var lastSlash = baseModelUrl.lastIndexOf('/');
                    baseDir = lastSlash !== -1 ? baseModelUrl.substring(0, lastSlash + 1) : "";
                } else {
                    var rawLast = RAW_MODEL_URL.lastIndexOf('/');
                    baseDir = rawLast !== -1 ? RAW_MODEL_URL.substring(0, rawLast + 1) : "";
                }
                var fullUrl = relativePath;
                if (!fullUrl.startsWith('http://') && !fullUrl.startsWith('https://')) {
                    fullUrl = baseDir + fullUrl;
                }
                return getProxiedUrl(fullUrl);
            }
            
            function extractMtlFromObj(content) {
                var regex = /mtllib\s+([^\s\\]+(?:\.mtl)?)/i;
                var match = regex.exec(content);
                return match ? match[1].trim() : null;
            }
            
            function extractTexturesFromMtl(content) {
                var textures = [];
                var regex = /map_(?:Kd|Ks|Bump|bump|d|Ka|Ns|refl)\s+([^\s\\]+(?:\.(?:png|jpg|jpeg|tga|bmp|dds|tif|tiff))?)/gi;
                var match;
                while ((match = regex.exec(content)) !== null) {
                    var texFile = match[1].trim();
                    if (texFile && !textures.includes(texFile)) textures.push(texFile);
                }
                return textures;
            }
            
            function extractGltfDeps(content) {
                var deps = [];
                try {
                    var json = JSON.parse(content);
                    if (json.buffers) {
                        for (var i = 0; i < json.buffers.length; i++) {
                            var buf = json.buffers[i];
                            if (buf.uri && !buf.uri.startsWith('data:')) deps.push(buf.uri);
                        }
                    }
                    if (json.images) {
                        for (var j = 0; j < json.images.length; j++) {
                            var img = json.images[j];
                            if (img.uri && !img.uri.startsWith('data:')) deps.push(img.uri);
                        }
                    }
                } catch(e) { console.warn("gltf解析失败", e); }
                return deps;
            }
            
            // ========== 将文件列表导入查看器 ==========
            async function importFilesToViewer(filesArray) {
                if (!filesArray || filesArray.length === 0) throw new Error("没有文件可导入");
                var dataTransfer = new DataTransfer();
                for (var i = 0; i < filesArray.length; i++) dataTransfer.items.add(filesArray[i]);
                var fileList = dataTransfer.files;
                var imported = false;
                if (OV.Website && typeof OV.Website.ImportFiles === 'function') {
                    OV.Website.ImportFiles(fileList);
                    imported = true;
                } else if (OV.Website && typeof OV.Website.LoadFiles === 'function') {
                    OV.Website.LoadFiles(fileList);
                    imported = true;
                } else {
                    var viewer = null;
                    if (OV.ViewerManager && typeof OV.ViewerManager.getViewer === 'function') {
                        viewer = OV.ViewerManager.getViewer();
                    } else {
                        var viewerElem = document.getElementById('main_viewer');
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
                    var fileInput = document.getElementById('open_file');
                    if (fileInput) {
                        var dt = new DataTransfer();
                        for (var k = 0; k < filesArray.length; k++) dt.items.add(filesArray[k]);
                        fileInput.files = dt.files;
                        fileInput.dispatchEvent(new Event('change', { bubbles: true }));
                        imported = true;
                    }
                }
                if (!imported) throw new Error("无法将文件传递给3D查看器");
                return true;
            }
            
            // ========== 多文件加载（直接下载所有指定的URL，不自动补充依赖） ==========
            async function loadMultipleModelsFromUrls(urlsArray) {
                showLoading("正在获取模型文件列表...");
                var allFiles = [];
                var processedUrls = new Set();
                
                for (var url of urlsArray) {
                    if (processedUrls.has(url)) continue;
                    processedUrls.add(url);
                    try {
                        var proxiedUrl = getProxiedUrl(url);
                        var resp = await fetch(proxiedUrl, { mode: 'cors', credentials: 'same-origin' });
                        if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
                        var blob = await resp.blob();
                        var fileName = url.split('/').pop().split('?')[0] || 'file';
                        var fileObj = new File([blob], fileName, { type: blob.type || 'application/octet-stream' });
                        allFiles.push(fileObj);
                    } catch(e) {
                        console.warn(`下载失败: ${url}`, e);
                        showMessage(`警告: 无法下载 ${url}`, true, 2000);
                    }
                }
                
                if (allFiles.length === 0) throw new Error("没有成功下载任何文件");
                
                hideLoading();
                await importFilesToViewer(allFiles);
                showMessage(`✅ 已加载 ${allFiles.length} 个文件（多文件模式）`);
            }
            
            // ========== 单文件智能加载（自动解析OBJ/MTL/GLTF依赖） ==========
            async function smartLoadModel() {
                showLoading("正在获取主模型文件...");
                try {
                    var mainResp = await fetch(MODEL_URL, { mode: 'cors', credentials: 'same-origin' });
                    if (!mainResp.ok) throw new Error("主文件下载失败 HTTP " + mainResp.status);
                    var mainBlob = await mainResp.blob();
                    var ext = MODEL_FILENAME.split('.').pop().toLowerCase();
                    var mainFile = new File([mainBlob], MODEL_FILENAME, { type: mainBlob.type || 'application/octet-stream' });
                    var allFiles = [mainFile];
                    
                    // OBJ 多文件处理
                    if (ext === 'obj') {
                        showLoading("解析 OBJ 依赖...");
                        var objText = await mainBlob.text();
                        var mtlName = extractMtlFromObj(objText);
                        if (mtlName) {
                            var mtlUrl = getDependencyUrl(mtlName, RAW_MODEL_URL);
                            var mtlResp = await fetch(mtlUrl, { mode: 'cors' });
                            if (mtlResp.ok) {
                                var mtlBlob = await mtlResp.blob();
                                var mtlFile = new File([mtlBlob], mtlName, { type: 'text/plain' });
                                allFiles.push(mtlFile);
                                var mtlText = await mtlBlob.text();
                                var textures = extractTexturesFromMtl(mtlText);
                                if (textures.length) {
                                    showLoading("加载纹理贴图 (" + textures.length + "个)...");
                                    for (var t = 0; t < textures.length; t++) {
                                        var texName = textures[t];
                                        try {
                                            var texUrl = getDependencyUrl(texName, RAW_MODEL_URL);
                                            var texResp = await fetch(texUrl);
                                            if (texResp.ok) {
                                                var texBlob = await texResp.blob();
                                                var texFile = new File([texBlob], texName.split('/').pop(), { type: texBlob.type || 'image/png' });
                                                allFiles.push(texFile);
                                            }
                                        } catch(e) { console.warn("纹理跳过", texName); }
                                    }
                                }
                            } else {
                                console.warn("MTL文件下载失败:", mtlName);
                            }
                        }
                    }
                    // GLTF 多文件处理
                    else if (ext === 'gltf') {
                        showLoading("解析 GLTF 依赖...");
                        var gltfText = await mainBlob.text();
                        var deps = extractGltfDeps(gltfText);
                        if (deps.length) {
                            showLoading("加载 GLTF 依赖 (" + deps.length + "个)...");
                            for (var d = 0; d < deps.length; d++) {
                                var dep = deps[d];
                                try {
                                    var depUrl = getDependencyUrl(dep, RAW_MODEL_URL);
                                    var depResp = await fetch(depUrl);
                                    if (depResp.ok) {
                                        var depBlob = await depResp.blob();
                                        var depFile = new File([depBlob], dep.split('/').pop(), { type: depBlob.type });
                                        allFiles.push(depFile);
                                    }
                                } catch(e) { console.warn("GLTF依赖异常", dep); }
                            }
                        }
                    }
                    
                    hideLoading();
                    await importFilesToViewer(allFiles);
                    var depCount = allFiles.length - 1;
                    showMessage("✅ 已加载 " + MODEL_FILENAME + (depCount > 0 ? " 及 " + depCount + " 个依赖文件" : ""));
                } catch (err) {
                    hideLoading();
                    console.error(err);
                    showMessage("❌ 加载失败: " + err.message, true);
                }
            }
            
            // ========== 判断RAW_MODEL_URL是否为多文件 ==========
            function isMultipleUrls(urlString) {
                if (!urlString || typeof urlString !== 'string') return false;
                return urlString.indexOf(',') !== -1;
            }
            
            function parseMultipleUrls(urlString) {
                if (!isMultipleUrls(urlString)) return null;
                var urls = urlString.split(',').map(s => s.trim()).filter(s => s.length > 0);
                return urls.length > 0 ? urls : null;
            }
            
            // ========== 等待查看器就绪 ==========
            function waitForViewerReady() {
                return new Promise(function(resolve) {
                    if (window._viewerReady) { resolve(); return; }
                    var interval = setInterval(function() {
                        if (window._viewerReady || (OV.ViewerManager && OV.ViewerManager.getViewer())) {
                            clearInterval(interval);
                            window._viewerReady = true;
                            resolve();
                        }
                    }, 200);
                    setTimeout(function() {
                        clearInterval(interval);
                        if (!window._viewerReady) {
                            window._viewerReady = true;
                            resolve();
                        }
                    }, 5000);
                });
            }
            
            // ========== 启动 ==========
            $(window).on('load', async function() {
                await waitForViewerReady();
                setTimeout(async function() {
                    // 优先处理多文件模式（逗号分隔）
                    var multipleUrls = parseMultipleUrls(RAW_MODEL_URL);
                    if (multipleUrls && multipleUrls.length > 0) {
                        await loadMultipleModelsFromUrls(multipleUrls).catch(e => {
                            showMessage("多文件加载失败: " + e.message, true);
                        });
                        return;
                    }
                    
                    // 单文件模式（智能解析依赖）
                    if (MODEL_URL) {
                        await smartLoadModel().catch(e => {
                            showMessage("加载失败: " + e.message, true);
                        });
                    } else {
                        showMessage("❌ 模型地址为空", true);
                    }
                }, 300);
            });
        })(jQuery);
    </script>
    
    <script type="text/javascript">
        OV.StartWebsite();
        setTimeout(function() { window._viewerReady = true; }, 500);
    </script>
    
    <script type="text/javascript">
        if (!(!!window.ActiveXObject || "ActiveXObject" in window)) {
            if (typeof initWaterMark === 'function') initWaterMark();
        }
    </script>
</body>
</html>