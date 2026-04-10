<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>XML预览器</title>
    <#include  "*/commonHeader.ftl">
    <script src="js/jquery-3.7.1.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <script src="bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="css/xmlTreeViewer.css"/>
    <script src="js/xmlTreeViewer.js" type="text/javascript"></script>
    <script src="js/base64.min.js" type="text/javascript"></script>
    <style>
        .view-switcher {
            margin-bottom: 15px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }
        .view-switcher .btn-group {
            float: right;
        }
        .xml-text-view {
            font-family: 'Courier New', monospace;
            font-size: 14px;
            line-height: 1.5;
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
            border: 1px solid #dee2e6;
            overflow-x: auto;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        .xml-tree-view {
            font-family: Arial, sans-serif;
            font-size: 14px;
        }
        .active-view {
            font-weight: bold;
            background-color: #e9ecef;
        }
        .xml-tag {
            color: #007bff;
            font-weight: bold;
        }
        .xml-attr-name {
            color: #28a745;
            font-weight: bold;
        }
        .xml-attr-value {
            color: #dc3545;
        }
        .xml-comment {
            color: #6c757d;
            font-style: italic;
        }
        .xml-text {
            color: #212529;
        }
        .xml-highlight {
            background-color: #fff3cd;
            padding: 2px;
            border-radius: 2px;
        }
        .toggle-btn {
            cursor: pointer;
            color: #007bff;
            margin-right: 10px;
        }
        .toggle-btn:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<input hidden id="textData" value="${textData}"/>
<div class="container">
    <div class="panel panel-default">
        <div class="panel-heading">
            <div class="view-switcher">
                <h4 class="panel-title" style="display: inline-block;">
                    ${file.name}
                </h4>
                <div class="btn-group" role="group">
                    <button type="button" id="treeViewBtn" class="btn btn-primary active">
                        <span class="glyphicon glyphicon-tree-conifer"></span> 树状视图
                    </button>
                    <button type="button" id="textViewBtn" class="btn btn-default">
                        <span class="glyphicon glyphicon-align-left"></span> 文本视图
                    </button>
                </div>
            </div>
        </div>
        <div class="panel-body">
            <div id="treeView" class="xml-tree-view"></div>
            <div id="textView" class="xml-text-view" style="display: none;"></div>
        </div>
    </div>
</div>

<script>
    // XML格式化函数
    function formatXml(xml, indentChars = '  ') {
        let formatted = '';
        let indent = 0;
        const tab = indentChars;
        xml = xml.replace(/(>)(<)(\/*)/g, "$1\n$2$3");
        
        const lines = xml.split('\n');
        
        for (let i = 0; i < lines.length; i++) {
            let line = lines[i].trim();
            
            if (!line) continue;
            
            // 减少缩进级别
            if (line.match(/^<\//) || line.match(/^\/>/)) {
                indent--;
            }
            
            // 添加当前行的缩进
            if (indent > 0) {
                formatted += tab.repeat(indent);
            }
            
            formatted += line + '\n';
            
            // 增加缩进级别（如果不是自闭合标签且不是结束标签）
            if (line.match(/<.*>.*<\/.*>/) || line.match(/\/>/) || 
                line.match(/<!/) || line.match(/\?>/)) {
                // 自闭合标签、注释、处理指令等不增加缩进
            } else if (line.match(/<[^\/?]/) && !line.match(/<\//)) {
                indent++;
            }
        }
        
        return formatted;
    }

    // XML语法高亮函数
    function highlightXml(xml) {
        return xml
            // 处理注释
            .replace(/&lt;!--[\s\S]*?--&gt;/g, '<span class="xml-comment">$&</span>')
            // 处理标签
            .replace(/&lt;(\/?)([a-zA-Z][a-zA-Z0-9:_-]*)/g, '&lt;<span class="xml-tag">$1$2</span>')
            // 处理属性名
            .replace(/\s([a-zA-Z][a-zA-Z0-9:_-]*)="/g, ' <span class="xml-attr-name">$1</span>="')
            // 处理属性值
            .replace(/="([^"]*)"/g, '="<span class="xml-attr-value">$1</span>"')
            // 处理CDATA
            .replace(/&lt;!\[CDATA\[[\s\S]*?\]\]&gt;/g, '<span class="xml-highlight">$&</span>');
    }

    // HTML转义函数

	
	   function htmlEscape(str){
        var s = "";
        if(str.length == 0) return "";
        s = str.replace(/&amp;/g,"&");
        s = str.replace(/&amp;amp;/g,"&");
        s = s.replace(/&lt;/g,"<");
        s = s.replace(/&gt;/g,">");
        s = s.replace(/&nbsp;/g," ");
        s = s.replace(/&#39;/g,"\'");
        s = s.replace(/&quot;/g,"\"");
        s = s.replace(/<script.*?>.*?<\/script>/ig, '');
        s = s.replace(/<script/gi, "&lt;script ");
        s = s.replace(/<iframe/gi, "&lt;iframe ");
        return s;
    }

    /**
     * 初始化
     */
    window.onload = function () {
        initWaterMark();
        loadXmlData();
        
        // 视图切换按钮事件
        $("#treeViewBtn").click(function() {
            $("#treeView").show();
            $("#textView").hide();
            $(this).removeClass('btn-default').addClass('btn-primary active');
            $("#textViewBtn").removeClass('btn-primary active').addClass('btn-default');
        });
        
        $("#textViewBtn").click(function() {
            $("#textView").show();
            $("#treeView").hide();
            $(this).removeClass('btn-default').addClass('btn-primary active');
            $("#treeViewBtn").removeClass('btn-primary active').addClass('btn-default');
        });
    }

    /**
     * 加载XML数据
     */
    function loadXmlData() {
        try {
            // 解码Base64数据
            var textData = Base64.decode($("#textData").val());
            
            // 转义HTML特殊字符
			textData =htmlEscape(textData);
         
            
            // 格式化XML
            var formattedXml = formatXml(textData);
            
            // 应用语法高亮
            var highlightedXml = highlightXml(formattedXml);
            
            // 设置文本视图内容
            $("#textView").html(highlightedXml);
            
            // 解析并显示树状视图
            try {
				
                var xmlNode = xmlTreeViewer.parseXML(textData);
                window.retNode = xmlTreeViewer.getXMLViewerNode(xmlNode.xml);
                $("#treeView").html(window.retNode);
                
                // 为树状视图添加交互功能
                enhanceTreeView();
            } catch (treeError) {
                console.error("树状视图解析错误:", treeError);
                $("#treeView").html(
                    '<div class="alert alert-warning">' +
                    '<strong>警告：</strong>无法生成树状视图，XML格式可能不正确。<br>' +
                    '错误信息：' + treeError.message +
                    '</div>'
                );
            }
            
        } catch (error) {
            console.error("XML处理错误:", error);
            $("#textView").html(
                '<div class="alert alert-danger">' +
                '<strong>错误：</strong>无法解析XML数据。<br>' +
                '请检查XML格式是否正确。<br>' +
                '错误信息：' + error.message +
                '</div>'
            );
            $("#treeView").html(
                '<div class="alert alert-danger">' +
                '<strong>错误：</strong>无法解析XML数据。<br>' +
                '请检查XML格式是否正确。<br>' +
                '错误信息：' + error.message +
                '</div>'
            );
        }
    }

    /**
     * 增强树状视图的交互功能
     */
    function enhanceTreeView() {
        // 为所有可折叠节点添加点击事件
        $(".xml-tree-view .toggle-btn").off('click').on('click', function() {
            $(this).toggleClass('collapsed');
            var target = $(this).data('target');
            if (target) {
                $(target).toggle();
            }
        });
        
        // 添加节点高亮功能
        $(".xml-tree-view .xml-node").hover(
            function() {
                $(this).addClass('xml-highlight');
            },
            function() {
                $(this).removeClass('xml-highlight');
            }
        );
        
        // 双击节点展开/折叠所有子节点
        $(".xml-tree-view .xml-node").off('dblclick').on('dblclick', function() {
            var toggleBtn = $(this).find('.toggle-btn').first();
            if (toggleBtn.length) {
                toggleBtn.click();
            }
        });
    }

    // 页面加载完成后重新绑定事件
    $(document).ready(function() {
        // 如果XML内容很大，显示加载提示
        var textData = $("#textData").val();
        if (textData && textData.length > 100000) { // 大约100KB
            $("#textView").html('<div class="alert alert-info">正在格式化XML内容，请稍候...</div>');
        }
    });
</script>
</body>
</html>