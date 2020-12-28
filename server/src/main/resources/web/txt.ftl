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
        var textData = Base64.decode($("#textData").val())
        var textPreData = "<pre style='background-color: #FFFFFF;border:none'>" + textData + "</pre>";

        $("#text").html(textPreData);
    }

</script>

</body>

</html>
