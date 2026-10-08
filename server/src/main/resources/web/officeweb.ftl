<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>${file.name}预览</title>
    <link rel='stylesheet' href='xlsx/plugins/css/pluginsCss.css' />
    <link rel='stylesheet' href='xlsx/plugins/plugins.css' />
    <link rel='stylesheet' href='xlsx/css/luckysheet.css' />
    <link rel='stylesheet' href='xlsx/assets/iconfont/iconfont.css' />
    <script src="xlsx/plugins/js/plugin.js"></script>
    <script src="xlsx/luckysheet.umd.js"></script>
    <script src="js/watermark.js" type="text/javascript"></script>
    <script src="js/base64.min.js" type="text/javascript"></script>
</head>
<#if pdfUrl?contains("http://") || pdfUrl?contains("https://") || pdfUrl?contains("ftp://")>
    <#assign finalUrl="${pdfUrl}">
<#else>
    <#assign finalUrl="${baseUrl}${pdfUrl}">
</#if>
<script>
    /**
     * 初始化水印
     */
    function initWaterMark() {
        let watermarkTxt = '${watermarkTxt}';
        if (watermarkTxt !== '') {
            watermark.init({
                watermark_txt: '${watermarkTxt}',
                watermark_x: 0,
                watermark_y: 0,
                watermark_rows: 0,
                watermark_cols: 0,
                watermark_x_space: ${watermarkXSpace},
                watermark_y_space: ${watermarkYSpace},
                watermark_font: '${watermarkFont}',
                watermark_fontsize: '${watermarkFontsize}',
                watermark_color: '${watermarkColor}',
                watermark_alpha: ${watermarkAlpha},
                watermark_width: ${watermarkWidth},
                watermark_height: ${watermarkHeight},
                watermark_angle: ${watermarkAngle},
            });
        }
    }

    // 添加加载状态管理
    let isLoading = false;

</script>
<style>
    * {
        margin: 0;
        padding: 0;
    }

    html, body {
        height: 100%;
        width: 100%;
        overflow: hidden;
    }

    #loading-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(255, 255, 255, 0.95);
        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: column;
        z-index: 9999;
        transition: opacity 0.3s ease;
    }

    #loading-progress {
        width: 300px;
        height: 20px;
        background: #f0f0f0;
        border-radius: 10px;
        margin-top: 20px;
        overflow: hidden;
    }

    #loading-bar {
        width: 0%;
        height: 100%;
        background: linear-gradient(90deg, #4CAF50, #8BC34A);
        transition: width 0.3s ease;
        border-radius: 10px;
    }

    .spinner {
        width: 50px;
        height: 50px;
        border: 5px solid #f3f3f3;
        border-top: 5px solid #4CAF50;
        border-radius: 50%;
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    .loading-text {
        margin-top: 20px;
        font-size: 16px;
        color: #666;
    }

    .error-message {
        display: none;
        background: #ffebee;
        border: 1px solid #ffcdd2;
        border-radius: 4px;
        padding: 20px;
        margin: 20px;
        text-align: center;
    }

</style>
<body>
<!-- 添加加载遮罩层 -->
<div id="loading-overlay">
    <div class="spinner"></div>
    <div class="loading-text">正在加载Excel文件...</div>
    <div id="loading-progress">
        <div id="loading-bar"></div>
    </div>
</div>

<!-- 错误提示 -->
<div id="error-message" class="error-message">
    <h3>加载失败</h3>
    <p id="error-detail"></p>
    <button onclick="retryLoad()" style="margin-top: 10px; padding: 8px 16px;">重试</button>
</div>

<div id="lucky-mask-demo" style="position: absolute;z-index: 1000000;left: 0px;top: 0px;bottom: 0px;right: 0px; background: rgba(255, 255, 255, 0.8); text-align: center;font-size: 40px;align-items:center;justify-content: center;display: none;">加载中</div>

<p style="text-align:center;">
<div id="button-area" style="display: none;">
    <label><button onclick="tiaozhuan()">跳转HTML预览</button></label>
    <button id="confirm-button" onclick="print()">打印</button>
</div>
<div id="luckysheet" style="margin:0px;padding:0px;position:absolute;width:100%;left: 0px;top: 20px;bottom: 0px;outline: none;"></div>

<script src="xlsx/luckyexcel.umd.js"></script>
<script>
    function tiaozhuan(){
        var test = window.location.href;
        test = test.replace(new RegExp("&officePreviewType=xlsx",("gm")),"");
        test = test+'&officePreviewType=html';
        window.location.href=test;
    }

    var url = '${finalUrl?js_string}';
   	var kkagent = '${kkagent}';
    var baseUrl = '${baseUrl}'.endsWith('/') ? '${baseUrl}' : '${baseUrl}' + '/';
    if (kkagent === 'true' || !url.startsWith(baseUrl)) {
        url = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(url))+ "&key=${kkkey}";
    }

    let mask = document.getElementById("lucky-mask-demo");
    let loadingOverlay = document.getElementById("loading-overlay");
    let loadingBar = document.getElementById("loading-bar");
    let errorMessage = document.getElementById("error-message");

    // 更新加载进度
    function updateProgress(percent) {
        if (loadingBar) {
            loadingBar.style.width = percent + '%';
        }
    }

    // 显示错误信息
    function showError(message) {
        hideLoading();
        errorMessage.style.display = 'block';
        document.getElementById('error-detail').textContent = message;
    }

    // 隐藏加载动画
    function hideLoading() {
        if (loadingOverlay) {
            loadingOverlay.style.opacity = '0';
            setTimeout(() => {
                loadingOverlay.style.display = 'none';
                document.getElementById('button-area').style.display = 'block';
            }, 300);
        }
    }

    // 重试加载
    function retryLoad() {
        errorMessage.style.display = 'none';
        loadingOverlay.style.display = 'flex';
        loadingOverlay.style.opacity = '1';
        loadTextAsync();
    }

    // 异步加载Excel文件
    async function loadTextAsync() {
        if (isLoading) return;

        isLoading = true;
        updateProgress(10);

        try {
            initWaterMark();

            const value = url;
            const name = '${file.name}';

            if (!value) {
                showError('文件URL为空');
                return;
            }

            updateProgress(30);

            // 使用异步方式加载
            await new Promise(resolve => setTimeout(resolve, 100)); // 给UI更新一点时间

            const exportJson = await transformWithWorker(value, name);

            updateProgress(80);

            await createLuckysheet(exportJson);

            updateProgress(100);

            // 延迟隐藏加载界面，让用户看到加载完成
            setTimeout(() => {
                hideLoading();
                isLoading = false;
            }, 500);

        } catch (error) {
            console.error('加载Excel失败:', error);
            showError('加载失败: ' + error.message);
            isLoading = false;
        }
    }

    function transformWithWorker(value, name) {
        return new Promise((resolve, reject) => {
            updateProgress(50);

            if (!window.Worker) {
                transformOnMainThread(value, name, resolve, reject);
                return;
            }

            let worker;
            try {
                worker = new Worker('xlsx/luckyexcel-worker.js');
            } catch (error) {
                transformOnMainThread(value, name, resolve, reject);
                return;
            }

            let settled = false;
            const fallbackToMainThread = function(error) {
                if (settled) {
                    return;
                }
                settled = true;
                worker.terminate();
                if (error) {
                    console.warn('Excel Worker转换失败，回退主线程转换:', error);
                }
                transformOnMainThread(value, name, resolve, reject);
            };

            worker.onmessage = function(event) {
                const data = event.data || {};

                if (data.type === 'success') {
                    settled = true;
                    worker.terminate();
                    resolve(data.exportJson);
                    return;
                }

                if (data.type === 'error') {
                    fallbackToMainThread(data.message || 'Excel转换失败');
                }
            };

            worker.onerror = function(error) {
                fallbackToMainThread(error && error.message ? error.message : error);
            };

            worker.postMessage({
                url: value,
                name: name
            });
        });
    }

    function transformOnMainThread(value, name, resolve, reject) {
        try {
            LuckyExcel.transformExcelToLuckyByUrl(value, name, function(exportJson, luckysheetfile) {
                if (!exportJson || !exportJson.sheets || exportJson.sheets.length === 0) {
                    reject(new Error("读取excel文件内容失败!"));
                    return;
                }

                resolve(exportJson);
            }, function(error) {
                reject(error);
            });
        } catch (error) {
            reject(error);
        }
    }

    function createLuckysheet(exportJson) {
        return new Promise((resolve, reject) => {
            requestAnimationFrame(() => {
                try {
                    window.luckysheet.destroy();
                    window.luckysheet.create({
                        container: 'luckysheet',
                        lang: "zh",
                        showtoolbarConfig:{
                            image: true,
                            print: true,
                            exportXlsx: true,
                        },
                        allowCopy: true, // 是否允许拷贝
                showtoolbar:  ${xlsxshowtoolbar?string('true','false')},  // 是否显示工具栏
                showinfobar: true, // 是否显示顶部信息栏
                // myFolderUrl: "/",//作用：左上角<返回按钮的链接
                showsheetbar: true, // 是否显示底部sheet页按钮
                showstatisticBar: true, // 是否显示底部计数栏
                sheetBottomConfig: true, // sheet页下方的添加行按钮和回到顶部按钮配置
                allowEdit: ${(xlsxallowEdit!false)?string('true','false')},// 是否允许前台编辑
                enableAddRow: false, // 允许增加行
                enableAddCol: false, // 允许增加列
                userInfo: false, // 右上角的用户信息展示样式
                showRowBar: true, // 是否显示行号区域
                showColumnBar: false, // 是否显示列号区域
                sheetFormulaBar: false, // 是否显示公式栏
                enableAddBackTop: true,//返回头部按钮
                forceCalculation: false, //下面是导出插件 默认关闭
                        data: exportJson.sheets,
                        title: exportJson.info.name,
                        userInfo: exportJson.info.name.creator,
                        // 添加加载完成的回调
                        hook: {
                            workbookCreateAfter: function() {
                                resolve();
                            }
                        }
                    });

                    updateProgress(90);

                } catch (err) {
                    reject(err);
                }
            });
        });
    }

    // 页面加载完成后开始异步加载
    document.addEventListener('DOMContentLoaded', function() {
        // 延迟一点时间开始加载，确保DOM完全加载
        setTimeout(() => {
            loadTextAsync();
        }, 100);
    });

    // 添加取消加载的功能（按ESC键）
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && isLoading) {
            // 可以在这里添加取消加载的逻辑
            console.log('用户取消了加载');
        }
    });
</script>
</body>
</html>
