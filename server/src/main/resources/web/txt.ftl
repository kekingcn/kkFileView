<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>${file.name}普通文本预览</title>
    <#include "*/commonHeader.ftl">
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <script src="bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="js/base64.min.js" type="text/javascript"></script>
</head>
<body>
<input hidden id="textData" value="${textData}"/>
<link rel="stylesheet" href="highlight/highlight.css">
<!-- 先加载fenye.js -->
<script src="js/fenye.js" type="text/javascript"></script>
<!-- 改为普通的container，而不是container-fluid -->
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
    // 确保DOM加载完成
    document.addEventListener('DOMContentLoaded', function() {
        // 解码Base64数据
        var base64data = document.getElementById("textData").value;
        var s;
        try {
            s = Base64.decode(base64data);
        } catch(e) {
            console.error("Base64解码失败:", e);
            s = "内容解码失败";
        }
        
        // 获取参数
        var kkkeyword = '${highlightall}';
        var Length = 20000;
        var page = '${page}' || 1;
        var txt = "txt";
        
        console.log("初始化分页，参数:", { 
            contentLength: s.length, 
            kkkeyword: kkkeyword, 
            Length: Length, 
            page: page, 
            txt: txt 
        });
        
        // 初始化分页
        if (typeof DHTMLpagenation === 'function') {
            try {
                DHTMLpagenation(s, kkkeyword, Length, page, txt);
                console.log("分页初始化成功");
            } catch(e) {
                console.error("分页初始化失败:", e);
                document.getElementById("divContent").innerHTML = "分页初始化失败: " + e.message;
            }
        } else {
            console.error("DHTMLpagenation函数未定义");
            document.getElementById("divContent").innerHTML = "分页功能加载失败，请刷新页面重试";
        }
    });
    
    /**
     * 初始化
     */
    window.onload = function () {
        if (typeof initWaterMark === 'function') {
            initWaterMark();
        }
    }
</script>

</body>
</html>