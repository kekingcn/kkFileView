<!DOCTYPE html>
<html>
<head>
    <title>CADViewer - 中文界面</title>
    <meta charset="utf-8">
       <#include "*/commonHeader.ftl">
    <!-- 核心样式 - 精简版本 -->
    <link href="cadviewer/app/css/cadviewer-core-styles.css" media="screen" rel="stylesheet" type="text/css" />
    <link href="cadviewer/app/css/font-awesome.min.css" media="screen" rel="stylesheet" type="text/css" />
    <link href="cadviewer/app/css/cadviewer-bootstrap.css" media="screen" rel="stylesheet" type="text/css" />
    <link href="cadviewer/app/css/jquery-ui-1.13.2.min.css" media="screen" rel="stylesheet" type="text/css" />
    
    <!-- 核心脚本 - 最小化依赖 -->
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="cadviewer/app/js/jquery-ui-1.13.2.min.js" type="text/javascript"></script>
    <script src="cadviewer/app/js/eve.js" type="text/javascript"></script>
    <script src="cadviewer/app/js/xml2json.min.js" type="text/javascript"></script>
	<script src="cadviewer/app/js/list.js" type="text/javascript"></script>
    
    <!-- CADViewer 核心库 -->
    <script src="cadviewer/app/cv/cv-pro/cadviewer.min.js" type="text/javascript"></script>
      <#if currentUrl?contains("http://") || currentUrl?contains("https://") || currentUrl?contains("file://")|| currentUrl?contains("ftp://")>
        <#assign finalUrl="${currentUrl}">
    <#else>
        <#assign finalUrl="${baseUrl}${currentUrl}">
    </#if>
    <!-- 必需的第三方库 -->
    <script src="cadviewer/app/js/jscolor.js" type="text/javascript"></script>
    <script src="cadviewer/app/js/snap.svg-min.js" type="text/javascript"></script>
    
    <script type="text/javascript">
        // 基本配置
        var ServerUrl = '${baseUrl}' + "cadviewer/";
        
        // 图纸文件路径
        var FileName = '${finalUrl}'+"?Type=svgz";

        $(document).ready(function() {
            console.log("正在初始化CADViewer...");
            
            try {
                // 启用CADViewer专业版
                if (typeof cvjs_CADViewerPro === 'function') {
                    cvjs_CADViewerPro(true);
                }
                
                // 设置调试模式
                if (typeof cvjs_debugMode === 'function') {
                    cvjs_debugMode(true);
                }
                
                // 设置服务器路径和处理程序 - 简化版本
                if (typeof cvjs_setAllServerPaths_and_Handlers === 'function') {
                    cvjs_setAllServerPaths_and_Handlers(ServerUrl, ServerUrl, "", "PHP", "JavaScript", "floorPlan");
                }
                
                // 设置语言为简体中文 - 使用正确的方法名
                if (typeof cvjs_loadCADViewerLanguage === 'function') {
                    cvjs_loadCADViewerLanguage("Chinese-Simplified");
                }
                
                // 设置皮肤 - 暂时不设置，避免错误
                // if (typeof cvjs_setCADViewerSkin === 'function') {
                //     cvjs_setCADViewerSkin("light-skin");
                // }
                
                // 初始化CADViewer - 使用最简化的版本
                if (typeof cvjs_InitCADViewer === 'function') {
                    cvjs_InitCADViewer("floorPlan", ServerUrl + "app/images/", ServerUrl + "app/");
                }
                
                // 设置许可证路径
                if (typeof cvjs_setLicenseKeyPath === 'function') {
                    cvjs_setLicenseKeyPath(ServerUrl + "/app/cv/");
                }
                
                // 清空转换参数并设置新参数
                if (typeof cvjs_conversion_clearAXconversionParameters === 'function') {
                    cvjs_conversion_clearAXconversionParameters();
                    cvjs_conversion_addAXconversionParameter("last", "");
                    cvjs_conversion_addAXconversionParameter("extents", "");
                }
                
                // 加载图纸
                if (typeof cvjs_LoadDrawing === 'function') {
                    cvjs_LoadDrawing("floorPlan", FileName);
                }
                
                // 调整画布大小为全屏
                if (typeof cvjs_resizeWindow_position === 'function') {
                    cvjs_resizeWindow_position("floorPlan");
                }
                
                console.log("CADViewer初始化完成");
            } catch (error) {
                console.error("初始化CADViewer时出错:", error);
                // 尝试基本初始化
                try {
                    if (typeof cvjs_InitCADViewer === 'function') {
                        cvjs_InitCADViewer("floorPlan", ServerUrl + "app/images/", ServerUrl + "app/");
                        cvjs_LoadDrawing("floorPlan", FileName);
                    }
                } catch (e2) {
                    console.error("基本初始化也失败:", e2);
                }
            }
        });

        $(window).resize(function() {
            if (typeof cvjs_resizeWindow_position === 'function') {
                cvjs_resizeWindow_position("floorPlan");
            }
        });

        // 图纸加载完成回调
        function cvjs_OnLoadEnd() {
            console.log("图纸加载完成");
            try {
                if (typeof cvjs_resetZoomPan === 'function') {
                    cvjs_resetZoomPan("floorPlan");
                }
                
               
                
                console.log("OnLoadEnd完成");
            } catch (error) {
                console.error("OnLoadEnd中出错:", error);
            }
        }

        // 批注加载完成回调
        function cvjs_OnLoadEndRedlines() {
            console.log("批注加载完成");
            // 空实现
        }

        // 必须的其他回调函数
        function cvjs_change_space() {}
        function cvjs_ObjectSelected(rmid) {}
        function cvjs_graphicalObjectCreated(graphicalObject) {}
        function cvjs_popupTitleClick(graphicalObject) {}
        function cvjs_graphicalObjectOnChange(type, graphicalObject, spaceID, evt) {}
        function cvjs_mousedown(id, handle, entity) {}
        function cvjs_click(id, handle, entity) {}
        function cvjs_dblclick(id, handle, entity) {}
        function cvjs_mouseout(id, handle, entity) {}
        function cvjs_mouseover(id, handle, entity) {}
        function cvjs_mouseleave(id, handle, entity) {}
        function cvjs_mouseenter(id, handle, entity) {}
        
        // 保存批注函数
        function cvjs_saveStickyNotesRedlinesUser() {
            try {
                if (typeof cvjs_openRedlineSaveModal === 'function') {
                    cvjs_openRedlineSaveModal("floorPlan");
                }
            } catch (error) {
                console.error("保存批注时出错:", error);
            }
        }
        
        // 加载批注函数
        function cvjs_loadStickyNotesRedlinesUser() {
            try {
                if (typeof cvjs_openRedlineLoadModal === 'function') {
                    cvjs_openRedlineLoadModal("floorPlan");
                }
            } catch (error) {
                console.error("加载批注时出错:", error);
            }
        }
		 /*初始化水印*/
    window.onload = function () {
        initWaterMark();
    }
    </script>
</head>
<body style="margin:0; height:100vh; overflow:hidden;">
    <!-- CADViewer 显示容器 -->
    <div id="floorPlan" class="cadviewer-bootstrap cadviewer-core-styles" style="width:100%; height:100%;"></div>
</body>
</html>