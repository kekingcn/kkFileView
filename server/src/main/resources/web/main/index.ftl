<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>kkFileView演示首页</title>
    <link rel="icon" href="./favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="css/loading.css"/>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="bootstrap-table/bootstrap-table.min.css"/>
    <link rel="stylesheet" href="css/theme.css"/>
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery.form.min.js"></script>
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="bootstrap-table/bootstrap-table.min.js"></script>
    <script type="text/javascript" src="js/base64.min.js"></script>
    <script type="text/javascript" src="js/crypto-js.js"></script>
    <script type="text/javascript" src="js/aes.js"></script>
    <style>
        <#-- 删除文件密码弹窗居中 -->
        .alert {
            width: 50%;
        }
        <#-- 删除文件验证码弹窗居中 -->
        .modal {
            width:100%;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            -ms-transform: translate(-50%, -50%);
        }
        
        /* 分页样式调整 */
        .fixed-table-pagination {
            padding: 15px 0;
            border-top: 1px solid #e7eaec;
            margin-top: 15px;
        }
        .pagination > li > a,
        .pagination > li > span {
            margin: 0 3px;
            border-radius: 3px;
            color: #337ab7;
        }
        .pagination > .active > a,
        .pagination > .active > a:hover,
        .pagination > .active > span,
        .pagination > .active > span:hover {
            background-color: #337ab7;
            border-color: #337ab7;
        }
        
        /* 目录导航样式 */
        .breadcrumb {
            background-color: #f8f9fa;
            padding: 10px 20px;
            margin-bottom: 15px;
            border-radius: 4px;
            border: 1px solid #e7eaec;
        }
        .breadcrumb > li + li:before {
            content: ">";
            padding: 0 8px;
            color: #6c757d;
        }
        .file-icon {
            margin-right: 8px;
            font-size: 14px;
        }
        
        /* 表格行样式 */
        .folder-row {
            background-color: #f8f9fa;
            font-weight: 500;
        }
        .folder-row:hover {
            background-color: #e9ecef;
        }
        .file-row:hover {
            background-color: #f5f5f5;
        }
        
        /* 修正URL链接颜色 */
        .breadcrumb a, 
        .breadcrumb a:hover {
            color: #333 !important;
            text-decoration: none;
        }
        #table a:not(.btn) {
            color: #333 !important;
            text-decoration: none;
        }
        #table a:not(.btn):hover {
            color: #0275d8 !important;
            text-decoration: underline;
        }
        
        /* 按钮样式优化 */
        .btn {
            border-radius: 3px;
            padding: 5px 12px;
        }
        .btn-sm {
            padding: 3px 8px;
            font-size: 12px;
        }
        .btn-success {
            background-color: #5cb85c;
            border-color: #4cae4c;
        }
        .btn-success:hover {
            background-color: #449d44;
            border-color: #398439;
        }
        .btn-primary {
            background-color: #337ab7;
            border-color: #2e6da4;
        }
        .btn-primary:hover {
            background-color: #286090;
            border-color: #204d74;
        }
        .btn-danger {
            background-color: #d9534f;
            border-color: #d43f3a;
        }
        .btn-danger:hover {
            background-color: #c9302c;
            border-color: #ac2925;
        }
        .btn-info {
            background-color: #5bc0de;
            border-color: #46b8da;
        }
        .btn-info:hover {
            background-color: #31b0d5;
            border-color: #269abc;
        }
        
        /* 输入框和表单样式 */
        .form-control {
            border-radius: 3px;
            border: 1px solid #ccc;
            box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
            transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
        }
        .form-control:focus {
            border-color: #66afe9;
            outline: 0;
            box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(102,175,233,.6);
        }
        
        /* 地址预览区域优化 - 保持一行 */
        .preview-form-row {
            display: flex;
            flex-wrap: nowrap;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }
        .preview-form-row .form-group {
            margin-bottom: 0;
            flex-shrink: 0;
        }
        .preview-form-row #_url {
            flex-grow: 1;
            min-width: 300px;
        }
        .preview-form-row .checkbox-inline {
            margin-right: 10px;
            white-space: nowrap;
        }
        .preview-form-row .form-control {
            display: inline-block;
            width: auto;
            min-width: 70px;
        }
        .preview-form-row .form-control#filePassword {
            min-width: 80px;
        }
        .preview-form-row .form-control#watermarkTxt {
            min-width: 100px;
        }
        .preview-form-row .form-control#kkkey {
            min-width: 100px;
        }
        .preview-form-row .btn-success {
            white-space: nowrap;
        }
        
        /* 搜索框优化 */
        .input-group {
            width: 100%;
        }
        .input-group-btn .btn {
            border-radius: 0 3px 3px 0;
        }
        #searchInput {
            border-radius: 3px 0 0 3px;
        }
        
        /* 上传区域优化 */
        #file {
            padding: 6px;
        }
        .input-group-btn .btn {
            margin-left: 5px;
        }
        
        /* 表格样式优化 */
        #table {
            border: 1px solid #e7eaec;
            border-radius: 4px;
            margin-top: 15px;
        }
        .fixed-table-container {
            border: none;
        }
        .table > thead > tr > th {
            border-bottom: 2px solid #e7eaec;
            background-color: #f8f9fa;
            font-weight: 600;
        }
        .table > tbody > tr > td {
            border-top: 1px solid #e7eaec;
            padding: 12px 8px;
            vertical-align: middle;
        }
        
        /* 模态框优化 */
        .modal-content {
            border-radius: 5px;
            box-shadow: 0 5px 15px rgba(0,0,0,.5);
        }
        .modal-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #e7eaec;
            border-radius: 5px 5px 0 0;
        }
        .modal-footer {
            background-color: #f8f9fa;
            border-top: 1px solid #e7eaec;
            border-radius: 0 0 5px 5px;
        }
        
        /* 操作按钮间距 */
        .btn + .btn {
            margin-left: 5px;
        }
        
        /* 高亮搜索结果 */
        .text-danger[style*="background-color: yellow"] {
            padding: 0 2px;
            font-weight: bold;
        }
        
        /* 禁用状态样式 */
        .disabled-upload {
            opacity: 0.6;
            pointer-events: none;
        }
        .disabled-upload .btn {
            cursor: not-allowed;
        }
        .disabled-upload .alert {
            margin-bottom: 0;
        }
        
        /* 响应式调整 */
        @media (max-width: 1200px) {
            .preview-form-row {
                flex-wrap: wrap;
            }
            .preview-form-row #_url {
                min-width: 200px;
            }
        }
    </style>
</head>

<body>

<#-- 删除文件验证码弹窗  -->
<#if deleteCaptcha >
<div id="deleteCaptchaModal" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-sm" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">删除文件</h4>
            </div>
            <br>
            <input type="text" id="deleteCaptchaFileName" style="display: none">
            <div class="modal-body input-group">
                <span style="display: table-cell; vertical-align: middle;">
                    <img id="deleteCaptchaImg" alt="deleteCaptchaImg" src="">
                    &nbsp;&nbsp;&nbsp;&nbsp;
                </span>
                <input type="text" id="deleteCaptchaText" class="form-control" placeholder="请输入验证码">
            </div>
            <div class="modal-footer" style="text-align: center">
                <button type="button" id="deleteCaptchaConfirmBtn" class="btn btn-danger">确认删除</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>
</#if>

<!-- Fixed navbar -->
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand" href="https://kkview.cn" target='_blank'>kkFileView</a>
        </div>
        <ul class="nav navbar-nav">
            <li class="active"><a href="./index">首页</a></li>
            <li><a href="./integrated">接入说明</a></li>
            <li><a href="./record">版本发布记录</a></li>
            <li><a href="./sponsor">赞助开源</a></li>
        </ul>
    </div>
</nav>

<div class="container theme-showcase" role="main">
    <#--  接入说明  -->
    <div class="page-header">
        <h1>支持的文件类型</h1>
        我们一直在扩展支持的文件类型，不断优化预览的效果，如果您有什么建议，欢迎在kk开源社区留言反馈：<a target='_blank' href="https://t.zsxq.com/09ZHSXbsQ">https://t.zsxq.com/09ZHSXbsQ</a>。
    </div>
    <div>
        <ol>
            <li>支持 doc, docx, xls, xlsx, xlsm, ppt, pptx, csv, tsv, dotm, xlt, xltm, dot, dotx, xlam, xla, pages 等 Office 办公文档</li>
            <li>支持 wps, dps, et, ett, wpt 等国产 WPS Office 办公文档</li>
            <li>支持 odt, ods, ots, odp, otp, six, ott, fodt, fods 等OpenOffice、LibreOffice 办公文档</li>
            <li>支持 vsd, vsdx 等 Visio 流程图文件</li>
            <li>支持 wmf, emf 等 Windows 系统图像文件</li>
            <li>支持 psd, eps 等 Photoshop 软件模型文件</li>
            <li>支持 pdf, ofd, rtf 等文档</li>
            <li>支持 xmind 软件模型文件</li>
            <li>支持 bpmn 工作流文件</li>
            <li>支持 eml, msg邮件文件</li>
            <li>支持 epub 图书文档</li>
            <li>支持 obj, 3ds, stl, ply, gltf, glb, off, 3dm, fbx, dae, wrl, 3mf, ifc, brep, step, iges, fcstd, bim 等 3D 模型文件</li>
            <li>支持 dwg, dxf, dwf, iges , igs, dwt, dng, ifc, dwfx, stl, cf2, plt  等 CAD 模型文件</li>
            <li>支持 txt, xml(渲染), md(渲染), java, php, py, js, css 等所有纯文本</li>
            <li>支持 zip, rar, jar, tar, gzip, 7z 等压缩包</li>
            <li>支持 jpg, jpeg, png, gif, bmp, ico, jfif, webp, heic 等图片预览（翻转，缩放，镜像）</li>
            <li>支持 tif, tiff 图信息模型文件（翻转，缩放）</li>
            <li>支持 tga 图像格式文件</li>
            <li>支持 svg 矢量图像格式文件 （翻转，缩放）</li>
            <li>支持 mp3,wav,mp4,flv 等音视频格式文件</li>
            <li>支持 avi,mov,rm,webm,ts,rm,mkv,mpeg,ogg,mpg,rmvb,wmv,3gp,ts,swf 等视频格式转码预览</li>
            <li>支持 dcm 等医疗数位影像预览</li>
            <li>支持 drawio 绘图预览</li>
        </ol>
    </div>
     <#--  输入下载地址预览文件  -->
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">输入下载地址预览</h3>
            跨域说明: 跨域是指你接入的URL默认支持跨域 不需要KK在进行反代了 <br>
            <#if "${kkkey}" != "false" >
                程序已经启用秘钥功能接入访问需要输入秘钥,获取秘钥请联系管理员！ <br>
            </#if>
            <#if isshowkey>
                <#if "${kkkey}" != "false" >
                    接入秘钥是：${kkkey}
                </#if>
            </#if>
        </div>
        <div class="panel-body">
            <div class="row">
                <label>&nbsp; &nbsp; <input type="text" id="_url" placeholder="请输入预览文件 url" style="min-width:35em"/></label>
                <form action="${baseUrl}onlinePreview" target="_blank" id="previewByUrl" style="display: inline-block">
                    <input type="hidden" name="url"/>
                    <label><input type="checkbox" name="forceUpdatedCache" value="true"/>更新</label>
                    <label><input type="checkbox" name="kkagent" value="true"/>跨域</label>
                    <label><input type="checkbox" id="encryption" name="encryption" value="aes"/>AES</label>
                    <input type="text" id="filePassword" name="filePassword" placeholder="密码" style="width:50px;">
                    <input type="text" id="page" name="page" placeholder="页码" style="width:50px;">
                    <input type="text" id="highlightall" name="highlightall" placeholder="高亮显示" style="width:60px;">
                    <input type="text" id="watermarkTxt" name="watermarkTxt" placeholder="插入水印" style="width:60px;">
                    <#if isshowkey>
                        <input type="text" id="kkkey" name="key" placeholder="KK秘钥" style="width:60px;">
                    </#if>

                    <input type="submit" value="预览" class="btn btn-success">
                </form>
            </div>
            <div class="alert alert-danger alert-dismissable hide" role="alert" id="previewCheckAlert">
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <strong>请输入正确的url</strong>
            </div>
        </div>
    </div>

    <#--  预览测试  -->
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">上传本地文件预览</h3>
        </div>
        <div class="panel-body">
            <#-- 目录导航 -->
            <nav aria-label="文件路径">
                <ol class="breadcrumb" id="pathBreadcrumb">
                    <li><a href="javascript:void(0);" onclick="changeDirectory('')">根目录</a></li>
                </ol>
            </nav>
            
            <#-- 操作区域 -->
            <div class="row" style="margin-bottom: 15px;">
                <div class="col-md-6">
                    <#-- 上传区域 -->
                    <#if fileUploadDisable == false>
                        <form enctype="multipart/form-data" id="fileUpload" class="form-inline">
                            <div class="input-group" style="width: 100%;">
                                <input type="file" id="file" name="file" class="form-control" style="flex: 1;"/>
                                <span class="input-group-btn">
                                    <input type="button" id="fileUploadBtn" class="btn btn-success" value="上传文件"/>
                                    <input type="button" id="newFolderBtn" class="btn btn-primary" style="margin-left:5px;" value="新建文件夹"/>
                                </span>
                            </div>
                        </form>
                    <#else>
                        <div class="disabled-upload">
                            <div class="alert alert-warning" style="margin-top: 10px; padding: 8px; font-size: 13px;">
                                <span class="glyphicon glyphicon-info-sign"></span>
                                文件上传功能已禁用。如需开启，请修改配置文件或联系管理员。
                            </div>
                        </div>
                    </#if>
                </div>
                <div class="col-md-6">
                    <#-- 搜索框 -->
                    <div class="input-group">
                        <input type="text" id="searchInput" class="form-control" placeholder="搜索文件名..." value="${searchText!''}">
                        <span class="input-group-btn">
                            <button class="btn btn-primary" type="button" onclick="performSearch()">
                                <span class="glyphicon glyphicon-search"></span> 搜索
                            </button>
                            <button class="btn btn-default" type="button" onclick="clearSearch()">
                                <span class="glyphicon glyphicon-remove"></span> 清除
                            </button>
                        </span>
                    </div>
                </div>
            </div>
            
            <#-- 新建文件夹对话框 -->
            <div class="modal fade" id="newFolderModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                            <h4 class="modal-title">新建文件夹</h4>
                        </div>
                        <div class="modal-body">
                            <input type="text" id="newFolderName" class="form-control" placeholder="请输入文件夹名称"/>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary" onclick="createNewFolder()">创建</button>
                            <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                        </div>
                    </div>
                </div>
            </div>
            
            <#-- 文件列表表格 -->
            <table id="table" data-pagination="true"></table>
        </div>
    </div>
</div>

<div class="loading_container" style="position: fixed;">
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
<#if beian?? && beian != "default">
    <div style="display: grid; place-items: center;">
        <div>
            <a target="_blank" href="https://beian.miit.gov.cn/">${beian}</a>
        </div>
    </div>
</#if>
<script>
    // 全局变量
    var currentPath = '';
    var currentSearchText = '';
    
    <#if deleteCaptcha >
        $("#deleteCaptchaImg").click(function() {
            $("#deleteCaptchaImg").attr("src","${baseUrl}deleteFile/captcha?timestamp=" + new Date().getTime());
        });
        $("#deleteCaptchaConfirmBtn").click(function() {
            var fileName = $("#deleteCaptchaFileName").val();
            var deleteCaptchaText = $("#deleteCaptchaText").val();
            $.get('${baseUrl}deleteFile?fileName=' + fileName +'&password=' + deleteCaptchaText, function(data){
                if ("删除文件失败，密码错误！" === data.msg) {
                    alert(data.msg);
                } else {
                    $('#table').bootstrapTable("refresh", {});
                    $("#deleteCaptchaText").val("");
                    $("#deleteCaptchaModal").modal("hide");
                }
            });
        });
        function deleteFile(fileName, isFolder) {
            var message = isFolder ? '你确定要删除这个文件夹吗？（包含所有子文件）' : '你确定要删除这个文件吗？';
            if (window.confirm(message)) {
                $("#deleteCaptchaImg").click();
                $("#deleteCaptchaFileName").val(fileName);
                $("#deleteCaptchaText").val("");
                $("#deleteCaptchaModal").modal("show");
            }
        }
    <#else>
        function deleteFile(fileName, isFolder) {
            var message = isFolder ? '你确定要删除这个文件夹吗？（包含所有子文件）' : '你确定要删除这个文件吗？';
            if (window.confirm(message)) {
                password = prompt("请输入默认密码:123456");
                $.ajax({
                    url: '${baseUrl}deleteFile?fileName=' + fileName +'&password='+password,
                    success: function (data) {
                        if ("删除文件失败，密码错误！" === data.msg) {
                            alert(data.msg);
                        } else {
                            $("#table").bootstrapTable("refresh", {});
                        }
                    }
                });
            } else {
                return false;
            }
        }
    </#if>

    function showLoadingDiv() {
        var height = window.document.documentElement.clientHeight - 1;
        $(".loading_container").css("height", height).show();
    }

    function checkUrl(url) {
        <#if "${kkkey}" != "false" >
            var kkkey = document.getElementById("kkkey");
            if (!kkkey || kkkey.value == "") {
                alert("程序需要秘钥接入，请输入秘钥:<#if isshowkey><#if "${kkkey}" != "false" >${kkkey}</#if><#else>,联系系统管理员获取</#if>");
                return false;
            }
        </#if>
        //url= 协议://(ftp的登录信息)[IP|域名](:端口号)(/或?请求参数)
        var strRegex = '^((https|http|ftp|file)://)'//(https或http或ftp或file)
        var re = new RegExp(strRegex, 'i');//i不区分大小写
        //将url做uri转码后再匹配，解除请求参数中的中文和空字符影响
        return re.test(encodeURI(url));
    }

    $(function () {
        // 初始化面包屑导航
        updateBreadcrumb('');
        
        // 初始化表格
        initTable();
        
        // 新建文件夹按钮事件
        $('#newFolderBtn').click(function() {
            $('#newFolderName').val('');
            $('#newFolderModal').modal('show');
        });
        
        // 上传文件按钮事件
        $("#fileUploadBtn").click(function () {
            uploadFile();
        });
        
        // 预览表单提交处理
        $('#previewByUrl').submit(function(e) {
            e.preventDefault(); // 阻止默认提交行为
            handlePreview();
            return false;
        });
        
        // 搜索框回车键事件
        $('#searchInput').keypress(function(e) {
            if (e.which == 13) {
                performSearch();
                return false;
            }
        });
    });
    

    function initTable() {
        $('#table').bootstrapTable({
            url: 'listFiles',
            method: 'POST',
            contentType: "application/x-www-form-urlencoded",
            queryParams: function(params) {
                return {
                    path: currentPath,
                    searchText: currentSearchText,
                    page: params.offset / params.limit,
                    size: params.limit,
                    sort: params.sort,
                    order: params.order
                };
            },
            responseHandler: function(res) {
                return {
                    rows: res.data,
                    total: res.total
                };
            },
            sidePagination: 'server',
            pagination: true,
            pageSize: ${homePageSize},
            pageNumber: ${homePageNumber}, // 初始化加载页
            pageList: [5, 10, 20, 30, 50, 100],
            search: false,
            searchOnEnterKey: false,
            showSearchButton: false,
            showRefresh: true,
            showColumns: true,
            clickToSelect: true,
            locale: 'zh-CN',
            columns: [{
                field: 'name',
                title: '名称',
                sortable: true,
                width: '40%',
                formatter: function(value, row, index) {
                    var iconClass = row.isDirectory ? 'glyphicon glyphicon-folder-open' : 'glyphicon glyphicon-file';
                    var iconColor = row.isDirectory ? '#f0ad4e' : '#337ab7';
                    
                    // 高亮显示搜索关键词
                    var displayName = value;
                    if (currentSearchText && currentSearchText.trim() !== '') {
                        var regex = new RegExp(currentSearchText, 'gi');
                        displayName = value.replace(regex, function(match) {
                            return '<span class="text-danger" style="background-color: yellow;">' + match + '</span>';
                        });
                    }
                    
                    if (row.isDirectory) {
                        return '<span class="' + iconClass + ' file-icon" style="color:' + iconColor + '"></span>' +
                               '<a href="javascript:void(0)" onclick="changeDirectory(\'' + row.fullPath + '\')" style="color: #333;">' + displayName + '</a>';
                    } else {
                        // 构建预览URL
                        var previewUrl = buildFilePreviewUrl(row);
                        return '<span class="' + iconClass + ' file-icon" style="color:' + iconColor + '"></span>' +
                               '<a target="_blank" href="' + previewUrl + '" style="color: #333;">' + displayName + '</a>';
                    }
                }
            }, {
                field: 'isDirectory',
                title: '类型',
                sortable: true,
                width: '10%',
                align: 'center',
                formatter: function(value) {
                    return value ? '<span class="label label-warning">文件夹</span>' : '<span class="label label-primary">文件</span>';
                }
            }, {
                field: 'lastModified',
                title: '修改时间',
                sortable: true,
                width: '20%',
                formatter: function(value) {
                    if (value) {
                        return new Date(value).toLocaleString();
                    }
                    return '';
                }
            }, {
                field: 'size',
                title: '大小',
                sortable: true,
                width: '10%',
                align: 'right',
                formatter: function(value, row) {
                    if (row.isDirectory) {
                        return '<span class="text-muted">-</span>';
                    }
                    if (value) {
                        if (value < 1024) {
                            return value + ' B';
                        } else if (value < 1024 * 1024) {
                            return (value / 1024).toFixed(2) + ' KB';
                        } else {
                            return (value / (1024 * 1024)).toFixed(2) + ' MB';
                        }
                    }
                    return '';
                }
            }, {
                field: 'action',
                title: '操作',
                align: 'center',
                width: '20%',
                events: {
                    'click .btn-info': function(e, value, row, index) {
                        if (row.isDirectory) {
                            changeDirectory(row.fullPath);
                        }
                    },
                    'click .btn-success': function(e, value, row, index) {
                        // 预览链接会自动在新窗口打开，这里不需要额外处理
                    },
                    'click .btn-danger': function(e, value, row, index) {
                        if (row.isDirectory) {
                            deleteFile(encodeURIComponent(Base64.encode("http://"+row.fullPath)), true);
                        } else {
                            deleteFile(encodeURIComponent(Base64.encode("http://"+row.relativePath)), false);
                        }
                    }
                },
                formatter: function(value, row, index) {
                    if (row.isDirectory) {
                        return '<button class="btn btn-info btn-sm">进入</button>' +
                               '<button class="btn btn-danger btn-sm" style="margin-left:5px;">删除</button>';
                    } else {
                        var previewUrl = buildFilePreviewUrl(row);
                        return '<a class="btn btn-success btn-sm" target="_blank" href="' + previewUrl + '">预览</a>' +
                               '<button class="btn btn-danger btn-sm" style="margin-left:5px;">删除</button>';
                    }
                }
            }],
            rowStyle: function(row, index) {
                return {
                    classes: row.isDirectory ? 'folder-row' : 'file-row'
                };
            },
            onPostBody: function() {
                // 表格渲染完成后，调整表头对齐方式
                $('.fixed-table-header th').css('vertical-align', 'middle');
            }
        }).on('load-success.bs.table', function (e, data) {
            console.log('表格数据加载成功');
        }).on('load-error.bs.table', function (e, status) {
            console.error('表格数据加载失败:', status);
        });
    }
    
    // 构建文件预览URL
    function buildFilePreviewUrl(row) {
        // 构建预览URL
        var previewUrl = '${baseUrl}onlinePreview?url=' + encodeURIComponent(Base64.encode('${baseUrl}' + row.relativePath));
        <#if "${kkkey}" != "false">
            <#if isshowkey>
                previewUrl += '&key=${kkkey}';
            </#if>
        </#if>
        return previewUrl;
    }
    
    // 切换目录
    function changeDirectory(path) {
        currentPath = path;
        currentSearchText = ''; // 切换目录时清空搜索
        $('#searchInput').val('');
        updateBreadcrumb(path);
        $('#table').bootstrapTable('refresh', {
            silent: true
        });
    }
    
    // 更新面包屑导航
    function updateBreadcrumb(path) {
        var breadcrumb = $('#pathBreadcrumb');
        breadcrumb.empty();
        
        // 添加根目录
        breadcrumb.append('<li><a href="javascript:void(0);" onclick="changeDirectory(\'\')" style="color: #333;">根目录</a></li>');
        
        if (path) {
            var parts = path.split('/').filter(Boolean);
            var currentPath = '';
            
            parts.forEach(function(part, index) {
                currentPath += (currentPath ? '/' : '') + part;
                if (index < parts.length - 1) {
                    breadcrumb.append('<li><a href="javascript:void(0);" onclick="changeDirectory(\'' + currentPath + '\')" style="color: #333;">' + part + '</a></li>');
                } else {
                    breadcrumb.append('<li class="active" style="color: #333;">' + part + '</li>');
                }
            });
        } else {
            breadcrumb.append('<li class="active" style="color: #333;">根目录</li>');
        }
    }
    
    // 执行搜索
    function performSearch() {
        currentSearchText = $('#searchInput').val().trim();
        $('#table').bootstrapTable('refresh', {
            silent: true
        });
    }
    
    // 清除搜索
    function clearSearch() {
        currentSearchText = '';
        $('#searchInput').val('');
        $('#table').bootstrapTable('refresh', {
            silent: true
        });
    }
    
    // 创建新文件夹
    function createNewFolder() {
        var folderName = $('#newFolderName').val();
        if (!folderName) {
            alert('请输入文件夹名称');
            return;
        }
        
        // 验证文件夹名称合法性
        if (/[<>:"/\\|?*]/.test(folderName)) {
            alert('文件夹名称不能包含以下字符: < > : " / \\ | ? *');
            return;
        }
        
        $.ajax({
            url: 'createFolder',
            type: 'POST',
            data: {
                path: currentPath,
                folderName: folderName
            },
            success: function(response) {
                if (response.code === 0) {
                    $('#newFolderModal').modal('hide');
                    $('#table').bootstrapTable('refresh');
                } else {
                    alert('创建文件夹失败: ' + response.msg);
                }
            },
            error: function() {
                alert('创建文件夹失败，请重试');
            }
        });
    }
    
    // 上传文件
    function uploadFile() {
        var filepath = $("#file").val();
        if(!checkFileSize(filepath)) {
            return false;
        }
        
        // 检查是否选择了文件
        if (!filepath) {
            alert('请选择要上传的文件');
            return false;
        }
        
        showLoadingDiv();
        
        // 创建FormData对象
        var formData = new FormData();
        var file = $('#file')[0].files[0];
        formData.append('file', file);
        formData.append('path', currentPath);
        
        $.ajax({
            url: 'fileUpload',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (data) {
                if (data.code === 0) {
                    $('#table').bootstrapTable('refresh');
                    $("#file").val(''); // 清空文件选择
                } else {
                    alert('上传失败: ' + data.msg);
                }
                $(".loading_container").hide();
            },
            error: function () {
                alert('上传失败，请联系管理员');
                $(".loading_container").hide();
            }
        });
    }
    
    // 处理预览
    function handlePreview() {
        var _url = $("#_url").val();
        if (!checkUrl(_url)) {
            $("#previewCheckAlert").addClass("show");
            window.setTimeout(function () {
                $("#previewCheckAlert").removeClass("show");
            }, 3000);
            return false;
        }
        
        var checkbox = document.getElementById('encryption');
        var isChecked = checkbox.checked;
        var urlaes;
        
        if(isChecked){
            password = prompt("<#if isshowaeskey><#if aeskey?? && aeskey != "false" && aeskey != "">接入AES秘钥是：${aeskey}<#else>请向管理员获取AES秘钥</#if><#else>请输入AES秘钥</#if>");
            if (password === null || password === undefined) {
                return false;
            }
            urlaes = aesEncrypt(_url, password);        
        }else{
            urlaes = Base64.encode(_url);
        }
        
        // 构建预览URL
        var previewUrl = buildPreviewUrl(urlaes, isChecked);
        
        // 在新窗口打开
        window.open(previewUrl, '_blank');
    }
    
    // 构建预览URL
    function buildPreviewUrl(encodedUrl, isEncrypted) {
        var baseUrl = '${baseUrl}onlinePreview?';
        var params = [];
        
        // 添加编码后的URL
        params.push('url=' + encodeURIComponent(encodedUrl));
        
        // 添加复选框参数
        if ($('#previewByUrl [name=forceUpdatedCache]').is(':checked')) {
            params.push('forceUpdatedCache=true');
        }
        if ($('#previewByUrl [name=pdfAutoFetch]').is(':checked')) {
            params.push('pdfAutoFetch=true');
        }
        if ($('#previewByUrl [name=kkagent]').is(':checked')) {
            params.push('kkagent=true');
        }
        if (isEncrypted) {
            params.push('encryption=aes');
        }
        
        // 添加文本输入框参数（只添加有值的）
        var filePassword = $('#filePassword').val();
        if (filePassword) {
            params.push('filePassword=' + encodeURIComponent(filePassword));
        }
        
        var page = $('#page').val();
        if (page) {
            params.push('page=' + encodeURIComponent(page));
        }
        
        var highlightall = $('#highlightall').val();
        if (highlightall) {
            params.push('highlightall=' + encodeURIComponent(highlightall));
        }
        
        var watermarkTxt = $('#watermarkTxt').val();
        if (watermarkTxt) {
            params.push('watermarkTxt=' + encodeURIComponent(watermarkTxt));
        }
        
        // 添加KK秘钥参数
        var key = $('#kkkey').val();
        if (key) {
            params.push('key=' + encodeURIComponent(key));
        }
        
        // 返回完整的URL
        return baseUrl + params.join('&');
    }
    
    function checkFileSize(filepath) {
        var daxiao = "${size}";
        daxiao = daxiao.replace("MB", "");
        var maxsize = daxiao * 1024 * 1024;
        var errMsg = "上传的文件不能超过${size}喔！！！";
        var tipMsg = "您的浏览器暂不支持上传，确保上传文件不要超过${size}，建议使用IE、FireFox、Chrome浏览器";
        var warning = "kkview温馨提示您：上传的文件请注意，如果是设计到公司或者个人机密文件，请不要上传，或者上传执行后立即删除，如果造成各种损失我们概不负责！";
        
        try {
            var filesize = 0;
            var ua = window.navigator.userAgent;
            if (ua.indexOf("MSIE") >= 1) {
                // IE
                var img = new Image();
                img.src = filepath;
                filesize = img.fileSize;
            } else {
                var result = confirm(warning);
                if (!result) {
                    return false;
                }
                filesize = $("#file")[0].files[0].size; //byte
            }
            if (filesize > 0 && filesize > maxsize) {
                alert(errMsg);
                return false;
            } else if (filesize === 0) {
                alert("不能上传0KB文件");
                return false;
            } else if (filesize === -1) {
                alert(tipMsg);
                return false;
            }
        } catch (e) {
            alert("上传失败，请重试");
            return false;
        }
        return true;
    }
    
    function aesEncrypt(encryptString, key) {
        var key = CryptoJS.enc.Utf8.parse(key);
        var srcs = CryptoJS.enc.Utf8.parse(encryptString);
        var encrypted = CryptoJS.AES.encrypt(srcs, key, { mode: CryptoJS.mode.ECB, padding: CryptoJS.pad.Pkcs7 });
        return encrypted.toString();
    }
</script>
</body>
</html>