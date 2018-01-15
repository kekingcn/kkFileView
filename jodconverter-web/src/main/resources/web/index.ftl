<!DOCTYPE html>

<html lang="en">
<head>
    <title>图片预览图</title>
    <link rel="stylesheet" href="css/viewer.min.css">
    <link rel="stylesheet" href="css/loading.css">
    <link rel="stylesheet" href="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.11.1/bootstrap-table.css" />
    <style type="text/css">
    </style>
</head>

<body>
<h1>文件预览项目接入和测试界面</h1>
<div class="panel-group" id="accordion">
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="#accordion"
                   href="#collapseOne">
                    接入说明
                </a>
            </h4>
        </div>
        <div id="collapseOne" class="panel-collapse collapse">
            <div class="panel-body">
                <div>
                    如果你的项目需要接入文件预览项目，达到对docx、excel、ppt、jpg等文件的预览效果，那么通过在你的项目中加入下面的代码就可以
                    成功实现：
                    <pre style="background-color: #2f332a;color: #cccccc">
                        $scope.openWin = function (fileUrl) {
                            var url = configuration.previewUrl + encodeURIComponent(fileUrl);
                            var winHeight = window.document.documentElement.clientHeight-10;
                            $window.open(url, "_blank", "height=" + winHeight
                                + ",top=80,left=80,toolbar=no, menubar=no, scrollbars=yes, resizable=yes");
                        };
                    </pre>
                </div>
                <div>
                    新增多图片同时预览功能，接口如下：
                    <pre style="background-color: #2f332a;color: #cccccc">
                        var fileUrl =url1+"|"+"url2";//多文件使用“|”字符隔开
                        var url = "http://localhost:8012/picturesPreview?urls" + encodeURIComponent(fileUrl);
                        var winHeight = window.document.documentElement.clientHeight-10;
                        $window.open(url, "_blank", "height=" + winHeight
                                + ",top=80,left=80,toolbar=no, menubar=no, scrollbars=yes, resizable=yes");
                    </pre>
                </div>
            </div>
        </div>
    </div>
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="#accordion"
                   href="#collapseTwo">
                    预览测试
                </a>
            </h4>
        </div>
        <div id="collapseTwo" class="panel-collapse collapse">
            <div class="panel-body">
                <p style="color: red;">因为是测试所以一种文件只允许上传一个</p>
                <div style="padding: 10px">
                    <form enctype="multipart/form-data" id="fileUpload">
                        <input type="file" name="file" />
                        <input type="button" id="btnsubmit" value=" 上 传 " />
                    </form>
                </div>
                <div>
                    <table id="table" data-pagination="true"></table>
                </div>
            </div>
        </div>
    </div>
    <div class="panel">
        <div class="panel-heading">
            <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="#accordion"
                   href="#collapseThree">
                    更新记录
                </a>
            </h4>
        </div>
        <div id="collapseThree" class="panel-collapse collapse in">
            <div class="panel-body">
                <div>
                    2018年01月15日 ：<br>
                    1.首页新增社会化评论框<br><br>

                    2018年01月12日 ：<br>
                        1.新增多图片同时预览<br>
                        2.支持压缩包内图片轮番预览<br><br>

                    2018年01月02日 ：<br>
                        1.修复txt等文本编码问题导致预览乱码<br>
                        2.修复项目模块依赖引入不到的问题<br>
                        3.新增spring boot profile，支持多环境配置<br>
                        4.引入pdf.js预览doc等文件，支持doc标题生成pdf预览菜单，支持手机端预览<br><br>

                    2017年12月12日：<br>
                        1.项目osc开源:<a href="https://gitee.com/kekingcn/file-online-preview" target="_blank">https://gitee.com/kekingcn/file-online-preview</a><br>
                        2.项目github开源:<a href="https://github.com/kekingcn/kkFileView" target="_blank">https://github.com/kekingcn/kkFileView</a>
                </div>
            </div>
        </div>
        <div class="panel-body">
            <div>
                <!-- UY BEGIN -->
                <div id="uyan_frame"></div>
                <script type="text/javascript" src="http://v2.uyan.cc/code/uyan.js?uid=2155152"></script>
                <!-- UY END -->
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
<script src="js/jquery-3.0.0.min.js" type="text/javascript"></script>
<script src="https://cdn.bootcss.com/jquery.form/3.09/jquery.form.min.js" type="text/javascript"></script>
<script src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.11.1/bootstrap-table.js"></script>
<script>
    function deleteFile(fileName) {
        $.ajax({
            url: '${baseUrl}deleteFile?fileName=' + encodeURIComponent(fileName),
            success: function (data) {
                // 删除完成，刷新table
                if (1 == data.code) {
                    alert(data.msg);
                }else{
                    $('#table').bootstrapTable('refresh', {});
                }
            },
            error: function (data) {
                console.log(data);
            }
        })
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
            },]
        }).on('pre-body.bs.table', function (e,data) {
            // 每个data添加一列用来操作
            $(data).each(function (index, item) {
                item.action = "<a class='btn btn-default' target='_blank' href='${baseUrl}onlinePreview?url="
                    + encodeURIComponent('${baseUrl}' + item.fileName ) +"'>预览</a>" +
                    "<a class='btn btn-default' target='_blank' href='javascript:void(0);' onclick='deleteFile(\""+item.fileName+"\")'>删除</a>";
            });
            return data;
        }).on('post-body.bs.table', function (e,data) {
            return data;
        });

        /**
         *
         */
        function showLoadingDiv() {
            var height = window.document.documentElement.clientHeight - 1;
            $(".loading_container").css("height", height).show();
        }

        $("#btnsubmit").click(function () {
            showLoadingDiv();
            $("#fileUpload").ajaxSubmit({
                success: function (data) {
                    // 上传完成，刷新table
                    if (1 == data.code) {
                        alert(data.msg);
                    }else{
                        $('#table').bootstrapTable('refresh', {});
                    }
                    $(".loading_container").hide();
                },
                error: function (error) { alert(error); $(".loading_container").hide();},
                url: 'fileUpload', /*设置post提交到的页面*/
                type: "post", /*设置表单以post方法提交*/
                dataType: "json" /*设置返回值类型为文本*/
            });
        });
    });
</script>
</body>
</html>