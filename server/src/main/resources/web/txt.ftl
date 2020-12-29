<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>普通文本预览</title>
    <#include  "*/commonHeader.ftl">
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
            <div id="text"></div>
        </div>
    </div>
</div>


<script>
    /**
     * 初始化
     */
    window.onload = function () {
        initWaterMark();
        loadText();
    }

    /**
     *加载普通文本
     */
    function loadText() {
        var base64data = $("#textData").val()
        var textData = Base64.decode(base64data);
        var textPreData = "<xmp style='background-color: #FFFFFF;overflow-y: scroll;border:none'>" + textData + "</xmp>";
        $("#text").append(textPreData);
    }

</script>

</body>

</html>
