<!DOCTYPE HTML>
<html>
<head>
    <title><#if file.name??>${file.name}<#else>文件预览</#if></title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <#include "*/commonHeader.ftl">
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/base64.min.js"></script>
    <style>
        #container {
            width: 100%;
            height: 100vh;
            overflow: hidden;
            position: relative;
            background: #f5f5f5;
        }
        
        #svg-container {
            position: absolute;
            top: 0;
            left: 0;
            transition: transform 0.3s ease;
        }
        
        #svg-container svg {
            display: block;
            max-width: 100%;
            max-height: 100%;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .controls {
            position: fixed;
            bottom: 20px;
            right: 20px;
            display: flex;
            gap: 10px;
            z-index: 1000;
            background: rgba(255, 255, 255, 0.9);
            padding: 10px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .control-btn {
            width: 40px;
            height: 40px;
            border: none;
            border-radius: 50%;
            background: #007bff;
            color: white;
            font-size: 18px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }
        
        .control-btn:hover {
            background: #0056b3;
            transform: scale(1.1);
        }
        
        .control-btn:active {
            transform: scale(0.95);
        }
        
        .control-btn.reset {
            background: #6c757d;
        }
        
        .control-btn.reset:hover {
            background: #545b62;
        }
        
        .zoom-display {
            position: fixed;
            top: 20px;
            right: 20px;
            background: rgba(255, 255, 255, 0.9);
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            z-index: 1000;
        }
        
        .loading {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 18px;
            color: #666;
        }
    </style>
	   <#if currentUrl?contains("http://") || currentUrl?contains("https://") || currentUrl?contains("file://")|| currentUrl?contains("ftp://")>
        <#assign finalUrl="${currentUrl}">
    <#else>
        <#assign finalUrl="${baseUrl}${currentUrl}">
    </#if>
</head>
<body>
<div id="container">
    <div id="svg-container"></div>
    <div class="zoom-display">缩放: 100%</div>
    <div class="loading">正在加载SVG...</div>
    <div class="controls">
        <button class="control-btn" onclick="zoomIn()" title="放大">+</button>
        <button class="control-btn" onclick="zoomOut()" title="缩小">-</button>
        <button class="control-btn" onclick="rotateLeft()" title="向左旋转">↶</button>
        <button class="control-btn" onclick="rotateRight()" title="向右旋转">↷</button>
        <button class="control-btn reset" onclick="resetView()" title="重置视图">⟳</button>
    </div>
</div>

<script type="text/javascript">
    // 初始化变量
    let svgElement = null;
    let svgContainer = document.getElementById('svg-container');
    let container = document.getElementById('container');
    let zoomLevel = 1;
    let rotationAngle = 0;
    let minZoom = 0.1;
    let maxZoom = 10;
    let zoomStep = 0.2;
    let isDragging = false;
    let startX, startY, startTranslateX, startTranslateY;
    let panStartX, panStartY;
	var url = '${finalUrl}';
	var kkagent = '${kkagent}';
    var baseUrl = '${baseUrl}'.endsWith('/') ? '${baseUrl}' : '${baseUrl}' + '/';
    if (kkagent === 'true' || !url.startsWith(baseUrl)) {
        url = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(url))+ "&key=${kkkey}";
    }

    // 加载并显示SVG
    function loadSVG() {
        if (!url) {
            showError('URL参数缺失');
            return;
        }
        
        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error('网络响应不正常');
                }
                return response.text();
            })
            .then(svgText => {
                document.querySelector('.loading').style.display = 'none';
                svgContainer.innerHTML = svgText;
                svgElement = svgContainer.querySelector('svg');
                
                if (svgElement) {
                    // 设置初始属性
                    svgElement.style.transformOrigin = 'center center';
                    svgElement.style.width = '100%';
                    svgElement.style.height = '100%';
                    
                    // 重置视图
                    resetView();
                    
                    // 添加拖拽功能
                    setupDragAndDrop();
                    
                    // 添加鼠标滚轮缩放
                    setupWheelZoom();
                    
                    // 添加键盘快捷键
                    setupKeyboardShortcuts();
                    
                    // 添加触摸事件支持
                    setupTouchEvents();
                    
                    // 初始更新显示
                    updateDisplay();
                } else {
                    showError('SVG解析失败');
                }
            })
            .catch(error => {
                console.error('加载SVG失败:', error);
                showError('加载SVG文件失败: ' + error.message);
            });
    }

    // 显示错误信息
    function showError(message) {
        document.querySelector('.loading').style.display = 'none';
        svgContainer.innerHTML = '<div style="color: red; text-align: center; padding: 50px; font-size: 16px;">' + message + '</div>';
    }

    // 设置拖拽功能
    function setupDragAndDrop() {
        svgContainer.addEventListener('mousedown', startDrag);
        document.addEventListener('mousemove', drag);
        document.addEventListener('mouseup', stopDrag);
    }

    // 设置触摸事件
    function setupTouchEvents() {
        svgContainer.addEventListener('touchstart', handleTouchStart, { passive: false });
        svgContainer.addEventListener('touchmove', handleTouchMove, { passive: false });
        svgContainer.addEventListener('touchend', handleTouchEnd);
    }

    // 处理触摸开始
    function handleTouchStart(e) {
        if (e.touches.length === 1) {
            isDragging = true;
            panStartX = e.touches[0].clientX;
            panStartY = e.touches[0].clientY;
            
            const transform = svgContainer.style.transform;
            const match = transform.match(/translate\(([^)]+)\)/);
            if (match) {
                const parts = match[1].split(',');
                startTranslateX = parseFloat(parts[0]) || 0;
                startTranslateY = parseFloat(parts[1]) || 0;
            } else {
                startTranslateX = 0;
                startTranslateY = 0;
            }
            
            e.preventDefault();
        } else if (e.touches.length === 2) {
            e.preventDefault();
        }
    }

    // 处理触摸移动
    function handleTouchMove(e) {
        if (!isDragging || e.touches.length !== 1) return;
        
        const dx = e.touches[0].clientX - panStartX;
        const dy = e.touches[0].clientY - panStartY;
        
        updateTransform(startTranslateX + dx, startTranslateY + dy);
        e.preventDefault();
    }

    // 处理触摸结束
    function handleTouchEnd(e) {
        isDragging = false;
    }

    // 鼠标拖拽开始
    function startDrag(e) {
        isDragging = true;
        startX = e.clientX;
        startY = e.clientY;
        
        const transform = svgContainer.style.transform;
        const match = transform.match(/translate\(([^)]+)\)/);
        if (match) {
            const parts = match[1].split(',');
            startTranslateX = parseFloat(parts[0]) || 0;
            startTranslateY = parseFloat(parts[1]) || 0;
        } else {
            startTranslateX = 0;
            startTranslateY = 0;
        }
        
        svgContainer.style.cursor = 'grabbing';
    }

    // 拖拽中
    function drag(e) {
        if (!isDragging) return;
        
        const dx = e.clientX - startX;
        const dy = e.clientY - startY;
        
        updateTransform(startTranslateX + dx, startTranslateY + dy);
    }

    // 停止拖拽
    function stopDrag() {
        isDragging = false;
        svgContainer.style.cursor = 'grab';
    }

    // 设置鼠标滚轮缩放
    function setupWheelZoom() {
        svgContainer.addEventListener('wheel', function(e) {
            e.preventDefault();
            
            const rect = svgContainer.getBoundingClientRect();
            const mouseX = e.clientX - rect.left;
            const mouseY = e.clientY - rect.top;
            
            const delta = e.deltaY > 0 ? -zoomStep : zoomStep;
            const newZoom = Math.min(maxZoom, Math.max(minZoom, zoomLevel + delta));
            
            // 获取当前变换
            const transform = svgContainer.style.transform;
            let translateX = 0, translateY = 0;
            const match = transform.match(/translate\(([^)]+)\)/);
            if (match) {
                const parts = match[1].split(',');
                translateX = parseFloat(parts[0]) || 0;
                translateY = parseFloat(parts[1]) || 0;
            }
            
            // 计算缩放中心点相对于容器中心的位置
            const centerX = rect.width / 2;
            const centerY = rect.height / 2;
            const offsetX = mouseX - centerX;
            const offsetY = mouseY - centerY;
            
            // 更新缩放级别
            const zoomChange = newZoom / zoomLevel;
            zoomLevel = newZoom;
            
            // 调整位置以保持鼠标点位置不变
            translateX = translateX - offsetX * (zoomChange - 1);
            translateY = translateY - offsetY * (zoomChange - 1);
            
            updateTransform(translateX, translateY);
            updateDisplay();
        });
    }

    // 设置键盘快捷键
    function setupKeyboardShortcuts() {
        document.addEventListener('keydown', function(e) {
            // 避免在输入框中触发快捷键
            if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;
            
            switch(e.key) {
                case '+':
                case '=':
                    if (e.ctrlKey || e.metaKey) {
                        e.preventDefault();
                        zoomIn();
                    }
                    break;
                case '-':
                case '_':
                    if (e.ctrlKey || e.metaKey) {
                        e.preventDefault();
                        zoomOut();
                    }
                    break;
                case '0':
                    if (e.ctrlKey || e.metaKey) {
                        e.preventDefault();
                        resetView();
                    }
                    break;
                case '[':
                    if (e.ctrlKey || e.metaKey) {
                        e.preventDefault();
                        rotateLeft();
                    }
                    break;
                case ']':
                    if (e.ctrlKey || e.metaKey) {
                        e.preventDefault();
                        rotateRight();
                    }
                    break;
            }
        });
    }

    // 放大
    function zoomIn() {
        zoomLevel = Math.min(maxZoom, zoomLevel + zoomStep);
        updateTransform();
        updateDisplay();
    }

    // 缩小
    function zoomOut() {
        zoomLevel = Math.max(minZoom, zoomLevel - zoomStep);
        updateTransform();
        updateDisplay();
    }

    // 向左旋转
    function rotateLeft() {
        rotationAngle -= 90;
        updateTransform();
    }

    // 向右旋转
    function rotateRight() {
        rotationAngle += 90;
        updateTransform();
    }

    // 重置视图
    function resetView() {
        zoomLevel = 1;
        rotationAngle = 0;
        
        // 计算居中位置
        const containerRect = container.getBoundingClientRect();
        if (svgElement) {
            const svgRect = svgContainer.getBoundingClientRect();
            const translateX = (containerRect.width - svgRect.width) / 2;
            const translateY = (containerRect.height - svgRect.height) / 2;
            updateTransform(translateX, translateY);
        } else {
            updateTransform(0, 0);
        }
        
        updateDisplay();
    }

    // 更新变换
    function updateTransform(translateX, translateY) {
        let transform = '';
        
        // 如果有传入的平移值，使用它
        if (translateX !== undefined && translateY !== undefined) {
            transform += 'translate(' + translateX + 'px, ' + translateY + 'px)';
        } else {
            // 否则保持当前的平移
            const currentTransform = svgContainer.style.transform;
            const match = currentTransform.match(/translate\(([^)]+)\)/);
            if (match) {
                transform += match[0];
            } else {
                transform += 'translate(0px, 0px)';
            }
        }
        
        // 应用缩放
        if (zoomLevel !== 1) {
            transform += ' scale(' + zoomLevel + ')';
        }
        
        // 应用旋转
        if (rotationAngle !== 0) {
            transform += ' rotate(' + rotationAngle + 'deg)';
        }
        
        svgContainer.style.transform = transform;
    }

    // 更新显示
    function updateDisplay() {
        var zoomDisplay = document.querySelector('.zoom-display');
        if (zoomDisplay) {
            var displayText = '缩放: ' + Math.round(zoomLevel * 100) + '%';
            if (rotationAngle !== 0) {
                // 将角度规范到0-360度
                var normalizedAngle = ((rotationAngle % 360) + 360) % 360;
                displayText += ' | 旋转: ' + normalizedAngle + '°';
            }
            zoomDisplay.textContent = displayText;
        }
    }

    // 页面加载完成后初始化
    window.onload = function () {
        // 设置初始光标
        svgContainer.style.cursor = 'grab';
        
        // 加载SVG
        loadSVG();
        
        // 如果有水印初始化函数，调用它
        if (typeof initWaterMark === 'function') {
            initWaterMark();
        }
    }
</script>
</body>
</html>