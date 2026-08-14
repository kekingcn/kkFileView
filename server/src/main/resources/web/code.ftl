<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>${file.name}代码预览</title>
    <#include  "*/commonHeader.ftl">
    <script src="js/jquery-3.6.1.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <script src="bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="highlight/default.min.css">
    <link rel="stylesheet" href="highlight/highlight.css">
    <script src="highlight/highlight.min.js" type="text/javascript"></script>
    <script src="js/fenye.js" type="text/javascript"></script>
    <#if "${file.suffix?lower_case}" == "js" > 
    <script src="js/jsformat.js" type="text/javascript"></script>
    </#if>
    <script src="js/base64.min.js" type="text/javascript"></script>
    <style>
        #htmlPreviewFrame {
            width: 100%;
            min-height: 65vh;
            border: 0;
            background: #fff;
        }
        #htmlSource {
            min-height: 65vh;
            overflow: auto;
            border: 0;
            background: #fff;
            white-space: pre-wrap;
            word-break: break-word;
        }
    </style>
</head>
<body>
<input hidden id="textData" value="${textData}"/>
<#if isHtmlFile>
<!-- HTML文件预览模式 -->
<div class="container">
    <div class="panel panel-default">
        <div class="panel-heading"> 
            <h4 class="panel-title"> 
                <strong><font color="red"><input class="GLOkBtn" type="button" value="在沙箱中运行html" onclick="loadXmlData();" /></font></strong>
                <a data-toggle="collapse" data-parent="#accordion" onclick="loadText();">
                    ${file.name}   
                </a>
            </h4> 
        </div>
        <div class="panel-body">
            <div id="text"></div>
        </div>
    </div>
</div>
<script>
    // 将Freemarker的布尔值传递给JavaScript
    var scriptjs = ${scriptjs?c}; // ?c 将布尔值转换为字符串true/false

    function decodePreviewText() {
        var escapedText = Base64.decode($("#textData").val());
        var decoder = document.createElement("textarea");
        decoder.innerHTML = escapedText;
        return decoder.value;
    }

    function replacePreviewContent(element) {
        var container = document.getElementById("text");
        while (container.firstChild) {
            container.removeChild(container.firstChild);
        }
        container.appendChild(element);
    }
    
    /**
     *加载普通文本
     */
    function loadText() {
        var source = document.createElement("pre");
        source.id = "htmlSource";
        source.textContent = decodePreviewText();
        replacePreviewContent(source);
    }
    
    /**
     *加载运行
     */
    function loadXmlData() {
        var frame = document.createElement("iframe");
        frame.id = "htmlPreviewFrame";
        frame.title = "HTML sandbox preview";
        frame.setAttribute("sandbox", scriptjs ? "allow-scripts" : "");
        frame.setAttribute("referrerpolicy", "no-referrer");
        frame.srcdoc = decodePreviewText();
        replacePreviewContent(frame);
    }
    
    /**
     * 初始化
     */
    window.onload = function () {
        initWaterMark();
        loadText();
    }
</script>
<#else>
<!-- 其他代码文件预览模式 -->
<div class="container">
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                    ${file.name}
                </a>
            </h4>
        </div>
        <div id="divPagenation" class="black" >
        </div>
        <div id="divContent" class="panel-body">
        </div>
      
    </div>
</div>
<script type="text/javascript">
    var base64data = $("#textData").val()
    var s = Base64.decode(base64data);
    var kkkeyword = '${highlightall}';
    var Length = 20000;
    var page = '${page}';
    <#if "${file.suffix?lower_case}" == "js" > 
    var txt = "js";
    <#else>
    var txt = "code";
    </#if>
    DHTMLpagenation(s, kkkeyword, Length, page, txt);
    
    /**
     * 初始化
     */
    window.onload = function () {
        initWaterMark();
    }
</script>
</#if>
</body>
</html>
