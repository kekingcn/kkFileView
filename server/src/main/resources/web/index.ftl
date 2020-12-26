<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0" />
    <title>kkFileView演示首页</title>
    <link rel="stylesheet" href="css/viewer.min.css" />
    <link rel="stylesheet" href="css/loading.css" />
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="bootstrap-table/bootstrap-table.min.css" />
    <link rel="stylesheet" href="gitalk/gitalk.css" />
    <script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
    <script type="text/javascript" src="js/jquery.form.min.js"></script>
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="bootstrap-table/bootstrap-table.min.js"></script>
    <script type="text/javascript" src="gitalk/gitalk.min.js"></script>
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
var url = 'http://127.0.0.1:8080/file/test.txt'; //要预览文件的访问地址
window.open('http://127.0.0.1:8012/onlinePreview?url='+encodeURIComponent(url));
                    </pre>
                </div>
                <div>
                    新增多图片同时预览功能，接口如下：
                    <pre style="background-color: #2f332a;color: #cccccc">
var fileUrl =url1+"|"+"url2";//多文件使用“|”字符隔开
window.open('http://127.0.0.1:8012/picturesPreview?urls='+encodeURIComponent(fileUrl));
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
    <div class="panel panel-default">
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
                    2020年05月20日 ：<br>
                        1. 新增支持全局水印，并支持通过参数动态改变水印内容<br>
                        2. 新增支持CAD文件预览<br>
                        3. 新增base.url配置，支持使用nginx反向代理和使用context-path<br>
                        4. 支持所有配置项支持从环境变量里读取，方便Docker镜像部署和集群中大规模使用<br>
                        5. 支持配置限信任站点（只能预览来自信任点的文件源），保护预览服务不被滥用<br>
                        6. 支持配置自定义缓存清理时间（cron表达式）<br>
                        7. 全部能识别的纯文本直接预览，不用再转跳下载，如.md .java .py等<br>
                        8. 支持配置限制转换后的PDF文件下载<br>
                        9. 优化maven打包配置，解决 .sh 脚本可能出现换行符问题<br>
                        10. 将前端所有CDN依赖放到本地，方便没有外网连接的用户使用<br>
                        11. 首页评论服务由搜狐畅言切换到Gitalk<br>
                        12. 修复url中包含特殊字符可能会引起的预览异常<br>
                        13. 修复转换文件队列addTask异常<br>
                        14. 修复其他已经问题<br>
                        15. 官网建设：<a href="https://kkfileview.keking.cn">https://kkfileview.keking.cn</a><br>
                        16. 官方Docker镜像仓库建设：<a href="https://hub.docker.com/r/keking/kkfileview">https://hub.docker.com/r/keking/kkfileview</a><br><br>

                    2019年06月18日 ：<br>
                        1. 支持自动清理缓存及预览文件<br>
                        2. 支持http/https下载流url文件预览<br>
                        3. 支持FTP url文件预览<br>
                        4. 加入Docker构建<br><br>

                    2019年04月08日 ：<br>
                        1. 缓存及队列实现抽象，提供JDK和REDIS两种实现(REDIS成为可选依赖)<br>
                        2. 打包方式提供zip和tar.gz包，并提供一键启动脚本<br><br>

                    2018年01月19日 ：<br>
                        1. 大文件入队提前处理<br>
                        1. 新增addTask文件转换入队接口<br>
                        1. 采用redis队列，支持kkFIleView接口和异构系统入队两种方式<br><br>

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
                        1.项目gitee开源:<a href="https://gitee.com/kekingcn/file-online-preview" target="_blank">https://gitee.com/kekingcn/file-online-preview</a><br>
                        2.项目github开源:<a href="https://github.com/kekingcn/kkFileView" target="_blank">https://github.com/kekingcn/kkFileView</a>
                </div>
            </div>
        </div>
        <div class="panel-body">
            <div id = "comments"></div>
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
            url: '${baseUrl}deleteFile?fileName=' + encodeURIComponent(fileName),
            success: function (data) {
                // 删除完成，刷新table
                if (1 == data.code) {
                    alert(data.msg);
                } else{
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
                item.action = "<a class='btn btn-default' target='_blank' href='${baseUrl}onlinePreview?url="+ encodeURIComponent('${baseUrl}' + item.fileName) +"'>预览</a>" +
                    "<a class='btn btn-default' href='javascript:void(0);' onclick='deleteFile(\""+item.fileName+"\")'>删除</a>";
            });
            return data;
        }).on('post-body.bs.table', function (e,data) {
            return data;
        });


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
                    } else {
                        $('#table').bootstrapTable('refresh', {});
                    }
                    $(".loading_container").hide();
                },
                error: function () {
                    alert('上传失败，请联系管理员');
                    $(".loading_container").hide();
                },
                url: 'fileUpload', /*设置post提交到的页面*/
                type: "post", /*设置表单以post方法提交*/
                dataType: "json" /*设置返回值类型为文本*/
            });
        });
        var gitalk = new Gitalk({
            clientID: '525d7f16e17aab08cef5',
            clientSecret: 'd1154e3aee5c8f1cbdc918b5c97a4f4157e0bfd9',
            repo: 'kkFileView',
            owner: 'kekingcn',
            admin: ['kekingcn,klboke,gitchenjh'],
            language: 'zh-CN',
            id: location.pathname,
            distractionFreeMode: false
        })
        gitalk.render((document.getElementById('comments')))
    });
</script>
</body>
</html>