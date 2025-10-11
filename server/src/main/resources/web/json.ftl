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
        .panel-body {
            padding: 0;
        }
        #json {
            padding: 20px;
            background-color: #f8f9fa;
            overflow-x: auto;
        }
        #text_view {
            padding: 20px;
            background-color: #ffffff;
            overflow-x: auto;
        }
        pre {
            margin: 0;
            white-space: pre-wrap;
            word-wrap: break-word;
            font-size: 14px;
            line-height: 1.6;
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
        .btn-group {
            margin-bottom: 10px;
        }
        .view-mode-btn {
            min-width: 100px;
        }
    </style>
</head>
<body>

<input hidden id="textData" value="${textData}"/>
<div class="container">
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title">
                ${file.name}
            </h4>
            <div class="btn-group" role="group">
                <button type="button" class="btn btn-primary view-mode-btn" id="formatted_btn">格式化视图</button>
                <button type="button" class="btn btn-default view-mode-btn" id="raw_btn">原始文本</button>
            </div>
        </div>
        <div class="panel-body">
            <div id="json"></div>
            <div id="text_view" style="display:none;"></div>
        </div>
    </div>
</div>

<script>
    /**
     * 初始化
     */
    window.onload = function () {
        initWaterMark();
        loadJsonData();
    }

    /**
     * HTML 反转义（用于还原后端转义的内容）
     */
    function htmlUnescape(str) {
        if (!str || str.length === 0) return "";
        var s = str;
        s = s.replace(/&quot;/g, '"');
        s = s.replace(/&#39;/g, "'");
        s = s.replace(/&lt;/g, "<");
        s = s.replace(/&gt;/g, ">");
        s = s.replace(/&amp;/g, "&");
        return s;
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

    /**
     * JSON 语法高亮
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
     * 加载 JSON 数据
     */
    function loadJsonData() {
        try {
            var textData = Base64.decode($("#textData").val());

            // 1. 先反转义 HTML 实体（因为后端已经转义过）
            textData = htmlUnescape(textData);

            // 2. 移除 BOM
            textData = removeBOM(textData);

            // 保存原始文本（用于显示时再次转义以保证安全）
            window.rawText = "<pre>" + htmlEscape(textData) + "</pre>";

            // 尝试解析并格式化 JSON
            try {
                var jsonObj = JSON.parse(textData);
                var formattedJson = JSON.stringify(jsonObj, null, 4);
                window.formattedJson = "<pre>" + syntaxHighlight(formattedJson) + "</pre>";

                // 默认显示格式化视图
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
            $("#json").show();
            $("#text_view").hide();
            $("#json").html(window.formattedJson);
            $("#formatted_btn").removeClass("btn-default").addClass("btn-primary");
            $("#raw_btn").removeClass("btn-primary").addClass("btn-default");
        });

        $("#raw_btn").click(function () {
            $("#json").hide();
            $("#text_view").show();
            $("#text_view").html(window.rawText);
            $("#raw_btn").removeClass("btn-default").addClass("btn-primary");
            $("#formatted_btn").removeClass("btn-primary").addClass("btn-default");
        });
    });
</script>
</body>

</html>
