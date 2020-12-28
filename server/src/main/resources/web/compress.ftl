<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <link href="css/zTreeStyle.css" rel="stylesheet" type="text/css">
    <#include "*/commonHeader.ftl">
    <style type="text/css">
        body {
            background-color: #404040;
        }
        h1, h2, h3, h4, h5, h6 {color: #2f332a;font-weight: bold;font-family: Helvetica, Arial, sans-serif;padding-bottom: 5px;}
        h1 {font-size: 24px;line-height: 34px;text-align: center;}
        h2 {font-size: 14px;line-height: 24px;padding-top: 5px;}
        h6 {font-weight: normal;font-size: 12px;letter-spacing: 1px;line-height: 24px;text-align: center;}
        a {color:#3C6E31;text-decoration: underline;}
        a:hover {background-color:#3C6E31;color:white;}
        code {color: #2f332a;}
        div.zTreeDemoBackground {width:600px;text-align:center;margin: 0 auto;background-color: #ffffff;}
    </style>
</head>
<body>

<div class="zTreeDemoBackground left">
    <ul id="treeDemo" class="ztree"></ul>
</div>
<script type="text/javascript" src="js/jquery.ztree.core.js"></script>

<script type="text/javascript">
    const data = JSON.parse('${fileTree}');
    var baseUrl = "${baseUrl}";
    var setting = {
        view: {
            fontCss : {"color":"blue"},
            showLine: true
        },
        data: {
            key: {
                children: 'childList',
                name: 'originName'
            }
        },
        callback:{
            beforeClick:function (treeId, treeNode, clickFlag) {
                console.log("节点参数：treeId-" + treeId + "treeNode-"
                        + JSON.stringify(treeNode) + "clickFlag-" + clickFlag);
            },
            onClick:function (event, treeId, treeNode) {
                if (!treeNode.directory) {
                    /**实现窗口最大化**/
                    var fulls = "left=0,screenX=0,top=0,screenY=0,scrollbars=1";    //定义弹出窗口的参数
                    if (window.screen) {
                        var ah = screen.availHeight - 30;
                        var aw = (screen.availWidth - 10) / 2;
                        fulls += ",height=" + ah;
                        fulls += ",innerHeight=" + ah;
                        fulls += ",width=" + aw;
                        fulls += ",innerWidth=" + aw;
                        fulls += ",resizable"
                    } else {
                        fulls += ",resizable"; // 对于不支持screen属性的浏览器，可以手工进行最大化。 manually
                    }
                    var previewUrl = baseUrl + treeNode.fileName +"?fileKey="+ treeNode.fileKey;
                    window.open("onlinePreview?url=" + encodeURIComponent(Base64.encode(previewUrl)), "_blank",fulls);
                }
            }
        }
    };
    var height = 0;
    $(document).ready(function(){
        var treeObj = $.fn.zTree.init($("#treeDemo"), setting, data);
        treeObj.expandAll(true);
        height = getZtreeDomHeight();
        $(".zTreeDemoBackground").css("height", height);
    });

    /*初始化水印*/
    window.onload = function() {
      initWaterMark();
    }

    /**
     *  计算ztreedom的高度
     */
    function getZtreeDomHeight() {
        return $("#treeDemo").height() > window.document.documentElement.clientHeight - 1
                ? $("#treeDemo").height() : window.document.documentElement.clientHeight - 1;
    }
    /**
     * 页面变化调整高度
     */
    window.onresize = function(){
        height = getZtreeDomHeight();
        $(".zTreeDemoBackground").css("height", height);
    }
    /**
     * 滚动时调整高度
     */
    window.onscroll = function(){
        height = getZtreeDomHeight();
        $(".zTreeDemoBackground").css("height", height);
    }
</script>
</body>
</html>