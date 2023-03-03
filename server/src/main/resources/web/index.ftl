<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0"/>
    <title>kkFileView演示首页</title>
    <link rel="icon" href="./favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="css/viewer.min.css"/>
    <link rel="stylesheet" href="css/loading.css"/>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css"/>
    <link rel="stylesheet" href="bootstrap-table/bootstrap-table.min.css"/>
    <link rel="stylesheet" href="css/theme.css"/>
    <script type="text/javascript" src="js/jquery-3.6.1.min.js"></script>
    <script type="text/javascript" src="js/jquery.form.min.js"></script>
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="bootstrap-table/bootstrap-table.min.js"></script>
    <script type="text/javascript" src="js/base64.min.js"></script>
    <style>
        .alert{
            width: 50%;
        }
    </style>
</head>

<body>

    <!-- Fixed navbar -->
    <nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="https://kkview.cn" target='_blank'>kkFileView</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li class="active"><a href="./index">首页</a></li>
            <li><a href="./record">版本发布记录</a></li>
            <li><a href="./comment">相关交流</a></li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container theme-showcase" role="main">
      <#--  接入说明  -->
      <div class="page-header">
        <h1>接入说明</h1>
      </div>
      <div class="well">
        <div style="font-size: 16px;">
            如果你的项目需要接入文件预览项目，达到对docx、excel、ppt、jpg等文件的预览效果，那么通过在你的项目中加入下面的代码就可以成功实现：
            <p style="background-color: #2f332a;color: #cccccc;font-size: 14px;padding:10px;margin-top:10px;">
                var url = 'http://127.0.0.1:8080/file/test.txt'; //要预览文件的访问地址 <br>
                window.open('http://127.0.0.1:8012/onlinePreview?url='+encodeURIComponent(base64Encode(url)));
            </p>
        </div>
        <div style="font-size: 16px;">
            新增多图片同时预览功能，接口如下：
            <p style="background-color: #2f332a;color: #cccccc;font-size: 14px;padding:10px;margin-top:10px;">
                var fileUrl =url1+'|'+url2;//多url使用'|'字符隔开 <br>
                window.open('http://127.0.0.1:8012/picturesPreview?urls='+encodeURIComponent(base64Encode(fileUrl)));
            </p>
        </div>
      </div>
      <#--  输入下载地址预览文件  -->
      <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">输入下载地址预览文件</h3>
        </div>
        <div class="panel-body">
            <form>
                <div class="form-group">
                    <label>文件下载地址</label>
                    <input type="url" class="form-control" id="_url" placeholder="请输入下载地址">
                </div>
                <div class="alert alert-danger alert-dismissable hide" role="alert" id="previewCheckAlert">
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <strong>请输入正确的url</strong>
                </div>
                <button id="previewByUrl" type="button" class="btn btn-success">预览</button>
            </form>
        </div>
      </div>
    <#--  预览测试  -->
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">预览测试</h3>
        </div>
        <div class="panel-body">
            <#if fileUploadDisable == false>
                <div style="padding: 10px">
                    <form enctype="multipart/form-data" id="fileUpload">
                        <div class="form-group">
                            <p id="fileName"></p>
                            <button type="button" class="btn btn-default" id="fileSelectBtn" style="margin-bottom:8px">
                                <span class="glyphicon glyphicon-cloud-upload" aria-hidden="true"></span> 选择文件
                            </button>
                            <input type="file" name="file" style="display: none" id="fileSelect" onchange="onFileSelected()"/>
                            <div class="alert alert-danger alert-dismissable hide" role="alert" id="postFileAlert">
                                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                                <strong>请选择需要上传的文件！</strong>
                            </div>
                         </div>
                         <button id="btnSubmit" type="button" class="btn btn-success">上 传</button>
                    </form>
                </div>
            </#if>
            <div>
                <table id="table" data-pagination="true"></table>
            </div>
        </div>
    </div>
</div>

<div class="loading_container">
    <div class="spinner">
        <div class="spinner-container container1">
            <div class="circle1"></div>
            <div class="circle2"></div>
            <div class="circle3"></div>
            <div class="circle4"></div>
        </div>
        <div class="spinner-container container2">
            <div class="circle1"></div>
            <div class="circle2"></div>
            <div class="circle3"></div>
            <div class="circle4"></div>
        </div>
        <div class="spinner-container container3">
            <div class="circle1"></div>
            <div class="circle2"></div>
            <div class="circle3"></div>
            <div class="circle4"></div>
        </div>
    </div>
</div>
<script>
    function deleteFile(fileName) {
        $.ajax({
            url: '${baseUrl}deleteFile?fileName=' + fileName,
            success: function (data) {
                // 删除完成，刷新table
                if (1 === data.code) {
                    alert(data.msg);
                } else {
                    $('#table').bootstrapTable('refresh', {});
                }
            },
            error: function (data) {
                console.log(data);
            }
        })
    }

    function showLoadingDiv() {
        var height = window.document.documentElement.clientHeight - 1;
        $(".loading_container").css("height", height).show();
    }

    function onFileSelected(){
        var file = $("#fileSelect").val();
        $("#fileName").text(file);
    }

    function checkUrl(url){
        //url= 协议://(ftp的登录信息)[IP|域名](:端口号)(/或?请求参数)
        var strRegex = '^((https|http|ftp)://)'//(https或http或ftp)
            + '(([\\w_!~*\'()\\.&=+$%-]+: )?[\\w_!~*\'()\\.&=+$%-]+@)?' //ftp的user@  可有可无
            + '(([0-9]{1,3}\\.){3}[0-9]{1,3}' // IP形式的URL- 3位数字.3位数字.3位数字.3位数字
            + '|' // 允许IP和DOMAIN（域名）
            + '(localhost)|'	//匹配localhost
            + '([\\w_!~*\'()-]+\\.)*' // 域名- 至少一个[英文或数字_!~*\'()-]加上.
            + '\\w+\\.' // 一级域名 -英文或数字  加上.
            + '[a-zA-Z]{1,6})' // 顶级域名- 1-6位英文
            + '(:[0-9]{1,5})?' // 端口- :80 ,1-5位数字
            + '((/?)|' // url无参数结尾 - 斜杆或这没有
            + '(/[\\w_!~*\'()\\.;?:@&=+$,%#-]+)+/?)$';//请求参数结尾- 英文或数字和[]内的各种字符
        var re = new RegExp(strRegex,'i');//i不区分大小写
        //将url做uri转码后再匹配，解除请求参数中的中文和空字符影响
        if (re.test(encodeURI(url))) {
            return (true);
        } else {
            return (false);
        }
    }

    $(function () {
        $('#table').bootstrapTable({
            url: 'listFiles',
            columns: [{
                field: 'fileName',
                title: '文件名'
            }, {
                field: 'action',
                title: '操作'
            }]
        }).on('pre-body.bs.table', function (e, data) {
            // 每个data添加一列用来操作
            $(data).each(function (index, item) {
                item.action = "<a class='btn btn-success' target='_blank' href='${baseUrl}onlinePreview?url=" + encodeURIComponent(Base64.encode('${baseUrl}' + item.fileName)) + "'>预览</a>" +
                "<a class='btn btn-danger' style='margin-left:10px;' href='javascript:void(0);' onclick='deleteFile(\"" +  encodeURIComponent(Base64.encode('${baseUrl}' + item.fileName)) + "\")'>删除</a>";
            });
            return data;
        }).on('post-body.bs.table', function (e, data) {
            return data;
        });

        $('#previewByUrl').on('click',function() {
            var _url = $("#_url").val();
            if (!checkUrl(_url)) {
                $("#previewCheckAlert").addClass("show");
                window.setTimeout(function(){
                    $("#previewCheckAlert").removeClass("show");
                },3000);//显示的时间
                return false;
            }

            var b64Encoded = Base64.encode(_url);

            window.open('${baseUrl}onlinePreview?url='+encodeURIComponent(b64Encoded));
        });

        $('#fileSelectBtn').on('click',function() {
            $('#fileSelect').click();
        });

        $("#btnSubmit").click(function () {
            var _fileName = $("#fileName").text()
            var index= _fileName.lastIndexOf(".");
            //获取后缀
            var ext = _fileName.substr(index+1);
             if (!ext || ext == "dll"|| ext == "exe"|| ext == "msi" ){
             window.alert(ext+"不支持上传")
            return ;
        }
            if(!_fileName){
                $("#postFileAlert").addClass("show");
                window.setTimeout(function(){
                    $("#postFileAlert").removeClass("show");
                },3000);//显示的时间
                return;
            }
            showLoadingDiv();
            $("#fileUpload").ajaxSubmit({
                success: function (data) {
                    // 上传完成，刷新table
                    if (1 === data.code) {
                        alert(data.msg);
                    } else {
                        $('#table').bootstrapTable('refresh', {});
                    }
                    $("#fileName").text("");
                    $(".loading_container").hide();
                },
                error: function () {
                    alert('上传失败，请联系管理员');
                    $("#fileName").text("");
                    $(".loading_container").hide();
                },
                url: 'fileUpload', /*设置post提交到的页面*/
                type: "post", /*设置表单以post方法提交*/
                dataType: "json" /*设置返回值类型为文本*/
            });
        });
    });
</script>
</body>
</html>
