<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>${file.name}普通文本预览</title>
    <#include "*/commonHeader.ftl">
    <script src="js/jquery-3.6.1.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <script src="bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="js/base64.min.js" type="text/javascript"></script>
</head>
<body>
<input hidden id="textData" value="${textData}"/>
<#if "${file.suffix?html}" == "txt" || "${file.suffix?html}" == "log"  || "${file.suffix?html}" == "TXT"  || "${file.suffix?html}" == "LOG">
  <style type="text/css">
DIV.black {
 line-height:25px;
PADDING-RIGHT: 1px; PADDING-LEFT: 1px; FONT-SIZE: 100%;
  MARGIN: 1px; COLOR: #fff;
 BACKGROUND-COLOR: #000; TEXT-ALIGN: left ;
}
DIV.black A {
BORDER-RIGHT: #909090 1px solid; PADDING-RIGHT: 5px;
BACKGROUND-POSITION: 50% bottom; BORDER-TOP: #909090 1px solid;
 PADDING-LEFT: 5px; BACKGROUND-IMAGE: url(); PADDING-BOTTOM: 2px;
 BORDER-LEFT: #909090 1px solid; COLOR: #fff; MARGIN-RIGHT: 3px;
 PADDING-TOP: 2px; BORDER-BOTTOM: #909090 1px solid; TEXT-DECORATION: none
}
DIV.black A:hover {
BORDER-RIGHT: #f0f0f0 1px solid; BORDER-TOP: #f0f0f0 1px solid;
 BACKGROUND-IMAGE: BORDER-LEFT: #f0f0f0 1px solid;
 COLOR: #ffffff; BORDER-BOTTOM: #f0f0f0 1px solid; BACKGROUND-COLOR: #404040
}
DIV.black A:active {
BORDER-RIGHT: #f0f0f0 1px solid; BORDER-TOP: #f0f0f0 1px solid;
BACKGROUND-IMAGE: BORDER-LEFT: #f0f0f0 1px solid;
COLOR: #ffffff; BORDER-BOTTOM: #f0f0f0 1px solid; BACKGROUND-COLOR: #404040
}
.divContent
 {
color:#fff;
font-size：30px；
line-height：30px；
 font-family：“SimHei”；
 text-indent:2em;
 padding-bottom:10px;
 white-space: pre-wrap; /*css-3*/
	white-space: -moz-pre-wrap; /*Mozilla,since1999*/
	white-space: -pre-wrap; /*Opera4-6*/
	white-space: -o-pre-wrap; /*Opera7*/
	word-wrap: break-word; /*InternetExplorer5.5+*/
  background-color: #000;
        }
    </style>


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
          <div id="divPagenation" class="black" >

    </div>
        <div id="divContent" class="panel-body">
           </div>
        </div>
    </div>
</div>


 <script type="text/javascript">
        var base64data = $("#textData").val()
        var s = Base64.decode(base64data);
	  // s=s.replace(/。/g,"。<br>");
           // $("#xml").hide()
         //对img标签进行匹配
         var imgReg = /(<img\s+src='\S+'\s*(\/)?>)/gi;
         matchContent = s.match(imgReg);
         imgContent = s;
         if(imgReg.test(s))
         {
            //将img标签替换为❈
            imgContent =  s.replace(imgReg,"❈");
         }

        // 封装DHTMLpagenation
        function DHTMLpagenation(content)
        {
            this.content=content; // 内容
            this.contentLength=imgContent.length; // 内容长度
            this.pageSizeCount; // 总页数
            this.perpageLength= 20000; //default perpage byte length.
            this.currentPage=1; // 起始页为第1页
            //this.regularExp=/.+[\?\&]{1}page=(\d+)/;
            this.regularExp=/\d+/; // 建立正则表达式，匹配数字型字符串。

            this.divDisplayContent;
            this.contentStyle=null;
            this.strDisplayContent="";
            this.divDisplayPagenation;
            this.strDisplayPagenation="";

            // 把第二个参数赋给perpageLength;
            arguments.length==2 ? perpageLength = arguments[1] : '';

            try {
                //创建要显示的DIV
                divExecuteTime=document.createElement("DIV");
                document.body.appendChild(divExecuteTime);
            }
            catch(e)
            {
            }

            // 得到divPagenation容器。
            if(document.getElementById("divPagenation"))
            {
                divDisplayPagenation=document.getElementById("divPagenation");
            }
            else
            {
                try
                {
                    //创建分页信息
                    divDisplayPagenation=document.createElement("DIV");
                    divDisplayPagenation.id="divPagenation";
                    document.body.appendChild(divDisplayPagenation);
                }
                catch(e)
                {
                    return false;
                }
            }

            // 得到divContent容器
            if(document.getElementById("divContent"))
            {
                divDisplayContent=document.getElementById("divContent");
            }
            else
            {
                try
                {
                    //创建每页显示内容的消息的DIV
                    divDisplayContent=document.createElement("DIV");
                    divDisplayContent.id="divContent";
                    document.body.appendChild(divDisplayContent);
                }
                catch(e)
                {
                    return false;
                }
            }

            DHTMLpagenation.initialize();
            return this;

        };

        //初始化分页；
        //包括把加入CSS，检查是否需要分页
        DHTMLpagenation.initialize=function()
        {

            divDisplayContent.className= contentStyle != null ? contentStyle : "divContent";

            if(contentLength<=perpageLength)
            {
                strDisplayContent=content;
                divDisplayContent.innerHTML=strDisplayContent;
                return null;
            }

            pageSizeCount=Math.ceil((contentLength/perpageLength));

            DHTMLpagenation.goto(currentPage);

            DHTMLpagenation.displayContent();
        };

        //显示分页栏
        DHTMLpagenation.displayPage=function()
        {

            strDisplayPagenation="";

            if(currentPage && currentPage !=1)
            {
                strDisplayPagenation+='<a href="javascript:void(0)" onclick="DHTMLpagenation.previous()">上一页</a>  ';
            }
            else
            {
                strDisplayPagenation+="上一页  ";
            }

            for(var i=1;i<=pageSizeCount;i++)
            {
                if(i!=currentPage)
                {
                    strDisplayPagenation+='<a href="javascript:void(0)" onclick="DHTMLpagenation.goto('+i+');">'+i+'</a>  ';
                }
                else
                {
                    strDisplayPagenation+=i+"  ";
                }
            }

            if(currentPage && currentPage!=pageSizeCount)
            {
                strDisplayPagenation+='<a href="javascript:void(0)" onclick="DHTMLpagenation.next()">下一页</a>  ';
            }
            else
            {
                strDisplayPagenation+="下一页  ";
            }

            strDisplayPagenation+="共 " + pageSizeCount + " 页。<br>每页" + perpageLength + " 字符，调整字符数：<input type='text' value='"+perpageLength+"' id='ctlPerpageLength' /><input type='button' value='确定' onclick='DHTMLpagenation.change()' />";

            divDisplayPagenation.innerHTML=strDisplayPagenation;


         };

        //上一页
        DHTMLpagenation.previous=function()
        {
            DHTMLpagenation.goto(currentPage-1);
        };

        //下一页
        DHTMLpagenation.next=function()
        {

            DHTMLpagenation.goto(currentPage+1);
        };

        //跳转至某一页
        DHTMLpagenation.goto=function(iCurrentPage)
        {
            startime=new Date();
            if(regularExp.test(iCurrentPage))
            {
                currentPage=iCurrentPage;

                var tempContent = "";

                //获取当前的内容 里面包含 ❈
                var currentContent = imgContent.substr((currentPage-1)*perpageLength,perpageLength);

                tempContent = currentContent;

                //当前页是否有 ❈ 获取最后一个 ❈ 的位置
                var indexOf = currentContent.indexOf("❈");

                if(indexOf >= 0)
                {
                      //获取从开始位置到当前页位置的内容
                      var beginToEndContent = imgContent.substr(0,currentPage*perpageLength);

                      //获取开始到当前页位置的内容 中的 * 的最后的下标
                      var reCount = beginToEndContent.split("❈").length - 1;

                      var contentArray = currentContent.split("❈");

                      tempContent = replaceStr(contentArray,reCount,matchContent);

                }
//                else
//                {
//                    tempContent=imgContent.substr((currentPage-1)*perpageLength,perpageLength);
//                }

                strDisplayContent=tempContent;
            }
            else
            {
                alert("页面参数错误");
            }
            DHTMLpagenation.displayPage();
            DHTMLpagenation.displayContent();
        };
        //显示当前页内容
        DHTMLpagenation.displayContent=function()
        {
            divDisplayContent.innerHTML=strDisplayContent;
        };

        //改变每页的字节数
        DHTMLpagenation.change=function()
        {

            var iPerpageLength = document.getElementById("ctlPerpageLength").value;
            if(regularExp.test(iPerpageLength))
            {

//                DHTMLpagenation.perpageLength=iPerpageLength;
//                DHTMLpagenation.currentPage=1;
//                DHTMLpagenation.initialize();

                DHTMLpagenation(s,iPerpageLength);
            }
            else
            {
                alert("请输入数字");
            }
        };

        /*  currentArray:当前页以 * 分割后的数组
            replaceCount:从开始内容到当前页的内容 * 的个数
            matchArray ： img标签的匹配的内容
        */
        function replaceStr(currentArray,replaceCount,matchArray)
        {

            var result = "";
            for(var i=currentArray.length -1,j = replaceCount-1 ;i>=1; i--)
            {

               var temp = (matchArray[j] + currentArray[i]);

               result = temp + result;

               j--;
            }

            result = currentArray[0] + result ;

            return result;
        }


        DHTMLpagenation(s,20000);


		   /**
     * 初始化
     */
    window.onload = function () {
        initWaterMark();
    }
    </script>


 <#else/>

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
     *加载普通文本
     */
    function loadText() {
        var base64data = $("#textData").val()
        var textData = Base64.decode(base64data);
        var textPreData = "<xmp style='background-color: #FFFFFF;overflow-y: scroll;border:none'>" + textData + "</xmp>";
        $("#text").append(textPreData);
    }
   /**
     * 初始化
     */
    window.onload = function () {
        initWaterMark();
        loadText();
    }
</script>
	 </#if>


</body>

</html>
