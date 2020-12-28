<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>xml文本预览</title>
    <#include  "*/commonHeader.ftl">
    <link rel="stylesheet" href="css/xmlTreeViewer.css"/>
    <script src="js/xmlTreeViewer.js" type="text/javascript"></script>
</head>
<body>

<input hidden id="textData" value="${textData}"/>
<div class="container">
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                     ${file.name}
                </a>
            </h4>
        </div>
        <div class="panel-body">
            <div id="xml"></div>
        </div>
    </div>
</div>

<script>
    /**
     * 初始化
     */
    window.onload = function () {
        initWaterMark();
        loadXmlData()
    }

    /**
     * 加载xml数据
     */
    function loadXmlData() {
        var textData = Base64.decode($("#textData").val())
        var xmlNode = xmlTreeViewer.parseXML(textData);
        var retNode = xmlTreeViewer.getXMLViewerNode(xmlNode.xml);
        $("#xml").html(retNode);
    }

</script>
</body>

</html>
