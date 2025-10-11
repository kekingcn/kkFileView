<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>JSON文件预览</title>
    <#include "*/commonHeader.ftl">
    <script src="js/jquery-3.6.1.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <script src="bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="js/base64.min.js" type="text/javascript"></script>
    <style>
        body {
            font-family: 'Courier New', Courier, monospace;
        }
        .container {
            max-width: 100%;
            padding: 20px;
        }
        #json {
            padding: 0;
            overflow-x: auto;
        }
        pre {
            padding: 20px;
            padding-left: 65px; /* 为行号留出空间 */
            white-space: pre-wrap;
            word-wrap: break-word;
            font-size: 14px;
            line-height: 1.6;
            position: relative;
        }
        .json-key {
            color: #881391;
            font-weight: bold;
        }
        .json-string {
            color: #1A1AA6;
        }
        .json-number {
            color: #1C00CF;
        }
        .json-boolean {
            color: #0D22FF;
            font-weight: bold;
        }
        .json-null {
            color: #808080;
            font-weight: bold;
        }
        .json-toggle {
            cursor: pointer;
            color: #666;
            user-select: none;
            display: inline-block;
            width: 16px;
            font-weight: bold;
        }
        .json-toggle:hover {
            color: #333;
        }
        .json-node {
            display: block;
        }
        .line-number {
            position: absolute;
            left: 0;
            width: 55px;
            color: #999;
            font-size: 12px;
            user-select: none;
            text-align: right;
            padding-right: 10px;
            border-right: 1px solid #ddd;
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>

<input hidden id="textData" value="${textData}"/>
<div class="container">
    <div class="panel panel-default">
        <div id="formatted_btn" class="panel-heading">
            <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                    ${file.name}
                </a>
            </h4>
        </div>
        <div id="raw_btn" class="panel-heading">
            <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                    ${file.name}
                </a>
            </h4>
        </div>
        <div id="json" class="panel-body">
        </div>
    </div>
</div>

<script>
    /**
     * 初始化
     */
    window.onload = function () {
        $("#formatted_btn").hide();
        initWaterMark();
        loadJsonData();
    }

    /**
     * HTML 反转义（用于还原后端转义的内容）
     * 使用浏览器的 DOM 来正确解码所有 HTML 实体
     */
    function htmlUnescape(str) {
        if (!str || str.length === 0) return "";
        var textarea = document.createElement('textarea');
        textarea.innerHTML = str;
        return textarea.value;
    }

    /**
     * HTML 转义（用于安全显示）
     */
    function htmlEscape(str) {
        if (!str || str.length === 0) return "";
        var s = str;
        s = s.replace(/&/g, "&amp;");
        s = s.replace(/</g, "&lt;");
        s = s.replace(/>/g, "&gt;");
        s = s.replace(/"/g, "&quot;");
        s = s.replace(/'/g, "&#39;");
        return s;
    }

    /**
     * 移除 BOM (Byte Order Mark)
     */
    function removeBOM(str) {
        if (str.charCodeAt(0) === 0xFEFF) {
            return str.substring(1);
        }
        return str;
    }

    // 全局行号计数器
    var lineNumber = 1;

    /**
     * 构建可展开/收起的 JSON 树形结构
     */
    function buildJsonTree(obj, indent, skipLineNumber) {
        indent = indent || 0;
        skipLineNumber = skipLineNumber || false;
        var html = '';
        var indentStr = '  '.repeat(indent);

        if (obj === null) {
            return '<span class="json-null">null</span>';
        }

        if (typeof obj !== 'object') {
            if (typeof obj === 'string') {
                // 转义特殊字符，避免换行和制表符破坏布局
                var escapedStr = obj
                    .replace(/\\/g, '\\\\')
                    .replace(/\n/g, '\\n')
                    .replace(/\r/g, '\\r')
                    .replace(/\t/g, '\\t')
                    .replace(/"/g, '\\"');
                return '<span class="json-string">"' + htmlEscape(escapedStr) + '"</span>';
            } else if (typeof obj === 'number') {
                return '<span class="json-number">' + obj + '</span>';
            } else if (typeof obj === 'boolean') {
                return '<span class="json-boolean">' + obj + '</span>';
            }
            return htmlEscape(String(obj));
        }

        var isArray = Array.isArray(obj);
        var entries = isArray ? obj : Object.keys(obj);
        var openBracket = isArray ? '[' : '{';
        var closeBracket = isArray ? ']' : '}';

        if (entries.length === 0) {
            return openBracket + closeBracket;
        }

        var nodeId = 'node_' + Math.random().toString(36).substr(2, 9);

        // 如果不跳过行号，说明是新的一行
        if (!skipLineNumber) {
            html += '<span class="line-number">' + lineNumber++ + '</span>';
        }

        html += '<span class="json-toggle" onclick="toggleJsonNode(\'' + nodeId + '\')">▼</span> ';
        html += openBracket + '\n';
        html += '<div id="' + nodeId + '" class="json-node">';

        for (var i = 0; i < entries.length; i++) {
            var key = isArray ? i : entries[i];
            var value = isArray ? entries[i] : obj[entries[i]];

            html += '<span class="line-number">' + lineNumber++ + '</span>';
            html += indentStr + '  ';
            if (!isArray) {
                html += '<span class="json-key">"' + htmlEscape(key) + '"</span>: ';
            }

            // 如果值是对象或数组，跳过它的行号（因为已经在上面添加了）
            html += buildJsonTree(value, indent + 1, true);

            if (i < entries.length - 1) {
                html += ',';
            }
            html += '\n';
        }

        html += '</div>';
        html += '<span class="line-number">' + lineNumber++ + '</span>';
        html += indentStr + closeBracket;

        return html;
    }

    /**
     * 切换 JSON 节点展开/收起
     */
    function toggleJsonNode(nodeId) {
        var node = document.getElementById(nodeId);
        var toggle = event.target;

        if (node.style.display === 'none') {
            node.style.display = 'block';
            toggle.textContent = '▼';
        } else {
            node.style.display = 'none';
            toggle.textContent = '▶';
        }
    }

    /**
     * 全部展开
     */
    function expandAll() {
        var nodes = document.querySelectorAll('.json-node');
        var toggles = document.querySelectorAll('.json-toggle');
        nodes.forEach(function(node) {
            node.style.display = 'block';
        });
        toggles.forEach(function(toggle) {
            toggle.textContent = '▼';
        });
    }

    /**
     * 全部收起
     */
    function collapseAll() {
        var nodes = document.querySelectorAll('.json-node');
        var toggles = document.querySelectorAll('.json-toggle');
        nodes.forEach(function(node) {
            node.style.display = 'none';
        });
        toggles.forEach(function(toggle) {
            toggle.textContent = '▶';
        });
    }

    /**
     * JSON 语法高亮（简单版本，用于原始文本视图）
     */
    function syntaxHighlight(json) {
        json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
            var cls = 'json-number';
            if (/^"/.test(match)) {
                if (/:$/.test(match)) {
                    cls = 'json-key';
                } else {
                    cls = 'json-string';
                }
            } else if (/true|false/.test(match)) {
                cls = 'json-boolean';
            } else if (/null/.test(match)) {
                cls = 'json-null';
            }
            return '<span class="' + cls + '">' + match + '</span>';
        });
    }

    /**
     * UTF-8 解码 Base64（正确处理中文等 UTF-8 字符）
     */
    function decodeBase64UTF8(base64Str) {
        try {
            // 方法1：使用现代浏览器的 TextDecoder API（推荐）
            if (typeof TextDecoder !== 'undefined') {
                var binaryString = window.atob(base64Str);
                var bytes = new Uint8Array(binaryString.length);
                for (var i = 0; i < binaryString.length; i++) {
                    bytes[i] = binaryString.charCodeAt(i);
                }
                return new TextDecoder('utf-8').decode(bytes);
            }

            // 方法2：降级方案
            return decodeURIComponent(escape(window.atob(base64Str)));
        } catch (e) {
            console.error('Base64 decode error:', e);
            // 最后降级到 Base64.js 库
            return Base64.decode(base64Str);
        }
    }

    /**
     * 加载 JSON 数据
     */
    function loadJsonData() {
        try {
            var textData = decodeBase64UTF8($("#textData").val());

            // 1. 先反转义 HTML 实体（因为后端已经转义过）
            textData = htmlUnescape(textData);

            // 2. 移除 BOM
            textData = removeBOM(textData);

            // 保存原始文本（用于显示时再次转义以保证安全）
            window.rawText = "<pre style='background-color: #FFFFFF; border: none; margin: 0;'>" + htmlEscape(textData) + "</pre>";

            // 尝试解析并格式化 JSON
            try {
                var jsonObj = JSON.parse(textData);

                // 重置行号计数器
                lineNumber = 1;

                // 构建树形视图
                var treeHtml = '<div style="padding: 20px;">';
                treeHtml += '<div style="margin-bottom: 10px;">';
                treeHtml += '<button onclick="expandAll()" class="btn btn-sm btn-default" style="margin-right: 5px;">全部展开</button>';
                treeHtml += '<button onclick="collapseAll()" class="btn btn-sm btn-default">全部收起</button>';
                treeHtml += '</div>';
                treeHtml += '<pre style="background-color: #f8f9fa; border: none; margin: 0;">';
                treeHtml += buildJsonTree(jsonObj, 0);
                treeHtml += '</pre></div>';
                window.formattedJson = treeHtml;

                // 默认显示树形视图
                $("#json").html(window.formattedJson);
            } catch (e) {
                // 如果不是有效的 JSON，显示错误并回退到原始文本
                window.formattedJson = "<div class='alert alert-warning'>JSON 解析失败: " + htmlEscape(e.message) + "</div>" + window.rawText;
                $("#json").html(window.formattedJson);
            }

        } catch (e) {
            $("#json").html("<div class='alert alert-danger'>文件加载失败: " + htmlEscape(e.message) + "</div>");
        }
    }

    /**
     * 按钮点击事件
     */
    $(function () {
        $("#formatted_btn").click(function () {
            $("#json").html(window.formattedJson);
            $("#raw_btn").show();
            $("#formatted_btn").hide();
        });

        $("#raw_btn").click(function () {
            $("#json").html(window.rawText);
            $("#formatted_btn").show();
            $("#raw_btn").hide();
        });
    });
</script>
</body>

</html>
