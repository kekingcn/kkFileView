<!DOCTYPE html>

<html lang="en">
<head>
    <link href="css/zTreeStyle.css" rel="stylesheet" type="text/css">
    <style type="text/css">
        html, body, div, span, applet, object, iframe, h1, h2, h3, h4, h5, h6, p, blockquote, pre, a, abbr, acronym, address, big, cite, code, del, dfn, em, font, img, ins, kbd, q, s, samp, small, strike, strong, sub, sup, tt, var, dl, dt, dd, ol, ul, li, fieldset, form, label, legend, table, caption, tbody, tfoot, thead, tr, th, td {
            margin: 0;padding: 0;border: 0;outline: 0;font-weight: inherit;font-style: inherit;font-size: 100%;font-family: inherit;vertical-align: baseline;}
        body {color: #2f332a;font: 15px/21px Arial, Helvetica, simsun, sans-serif;background: #f0f6e4 \9;}
        body{
            margin:0 auto;
            width: 600px;
            background-color: #333333;
            font-size: 4em;
        }
        h1, h2, h3, h4, h5, h6 {color: #2f332a;font-weight: bold;font-family: Helvetica, Arial, sans-serif;padding-bottom: 5px;}
        h1 {font-size: 24px;line-height: 34px;text-align: center;}
        h2 {font-size: 14px;line-height: 24px;padding-top: 5px;}
        h6 {font-weight: normal;font-size: 12px;letter-spacing: 1px;line-height: 24px;text-align: center;}
        a {color:#3C6E31;text-decoration: underline;}
        a:hover {background-color:#3C6E31;color:white;}
        input.radio {margin: 0 2px 0 8px;}
        input.radio.first {margin-left:0;}
        input.empty {color: lightgray;}
        code {color: #2f332a;}
        div.zTreeDemoBackground {width:600px;text-align:center;background-color: #ffffff;}
    </style>
</head>
<body>

<div class="zTreeDemoBackground left">
    <ul id="treeDemo" class="ztree"></ul>
</div>
</body>
<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="js/jquery.ztree.core.js"></script>
<script type="text/javascript">
    var data = JSON.parse('${fileTree}');
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
                    window.open("onlinePreview?url="
                            + encodeURIComponent("${baseUrl}" + treeNode.fileName)+"&fileKey="+treeNode.fileKey, "_blank",fulls);
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
</html>