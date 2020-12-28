<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>普通文本预览</title>
</head>
<body>
<input hidden id="textType" value="${textType}"/>
<input hidden id="textData" value="${textData}"/>

<div class="container">
    <#if textType?? && textType == "markdown">
        <div class="panel panel-default">
            <div id="markdown_btn" class="panel-heading">
                <h4 class="panel-title">
                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                        切换markdown
                    </a>
                </h4>
            </div>
            <div id="text_btn" class="panel-heading">
                <h4 class="panel-title">
                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                        切换text
                    </a>
                </h4>
            </div>
            <div class="panel-body">
                <div id="markdown"></div>
            </div>
        </div>
    <#elseif textType?? && textType == "xml" >
        <div id="xml" style="padding: 18px;"></div>
    <#else>
        <div id="text"></div>
    </#if>
</div>

<link rel="stylesheet" href="css/xmlTreeViewer.css"/>
<link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>

<script src="js/jquery-3.0.0.min.js" type="text/javascript"></script>
<script src="js/jquery.form.min.js" type="text/javascript"></script>
<script src="bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script src="js/watermark.js" type="text/javascript"></script>
<script src="js/marked.min.js" type="text/javascript"></script>
<script src="js/xmlTreeViewer.js" type="text/javascript"></script>
<script src="js/base64.min.js" type="text/javascript"></script>

<script>
    /**
     * 初始化
     */
    window.onload = function () {
        $("#markdown_btn").hide()
        initWaterMark();
        fetchData();
        loadText();
        loadXmlData()
        loadMarkdown();
    }

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

    /**
     * 获取文本数据
     */
    function fetchData() {
        window.textData = Base64.decode($("#textData").val())
        window.textPreData = "<pre style='background-color: #FFFFFF;border:none'>" + window.textData + "</pre>";
    }

    /**
     *加载普通文本
     */
    function loadText() {
        $("#text").html(window.textPreData);
    }

    /**
     * 加载markdown
     */
    function loadMarkdown() {
        if ($("#textType").val() === "markdown") {
            window.textMarkdownData = marked(window.textData);
            $("#markdown").html(window.textMarkdownData);
        }
    }

    /**
     * 加载xml数据
     */
    function loadXmlData() {
        if ($("#textType").val() === "xml") {
            var xmlNode = xmlTreeViewer.parseXML(window.textData);
            var retNode = xmlTreeViewer.getXMLViewerNode(xmlNode.xml);
            $("#xml").html(retNode);
        }
    }

    $(function () {
        $("#markdown_btn").click(function () {
            $("#markdown").html(window.textMarkdownData);
            $("#text_btn").show()
            $("#markdown_btn").hide()
        });

        $("#text_btn").click(function () {
            $("#markdown_btn").show()
            $("#text_btn").hide();
            $("#markdown").html(window.textPreData);
        });
    });

</script>
<style>
    * {
        margin: 0;
        padding: 0;
    }

    html, body {
        height: 100%;
        width: 100%;
    }

</style>
</body>

</html>
