<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>kkFileView 演示页</title>
    <link rel="icon" href="./favicon.ico" type="image/x-icon">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=JetBrains+Mono:wght@400;600&family=Space+Grotesk:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/loading.css"/>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="bootstrap-table/bootstrap-table.min.css"/>
    <link rel="stylesheet" href="css/theme.css"/>
    <link rel="stylesheet" href="css/main-pages.css?v=v1-polish-20260411-5"/>
    <script type="text/javascript" src="js/jquery-3.6.1.min.js"></script>
    <script type="text/javascript" src="js/jquery.form.min.js"></script>
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="bootstrap-table/bootstrap-table.min.js"></script>
    <script type="text/javascript" src="js/base64.min.js"></script>
    <script type="text/javascript" src="js/crypto-js.js"></script>
    <script type="text/javascript" src="js/aes.js"></script>
    <style>
        .file-icon {
            margin-right: 8px;
            font-size: 14px;
        }

        #table a:not(.btn) {
            color: var(--text) !important;
        }

        #table a:not(.btn):hover {
            color: var(--brand) !important;
        }
    </style>
</head>

<body class="app-shell app-home">

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

<nav class="site-nav navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand" href="https://kkview.cn" target='_blank'>kkFileView</a>
        </div>
        <ul class="nav navbar-nav">
            <li class="active"><a href="./index">首页</a></li>
            <li><a href="./integrated">接入说明</a></li>
            <li><a href="./record">版本发布记录</a></li>
            <li><a href="./sponsor">赞助开源</a></li>
            <li><a href="./contact">技术支持</a></li>
        </ul>
    </div>
</nav>

<div class="page-shell">
    <div class="container" role="main">
        <section class="hero-section">
            <div class="hero-grid single">
                <div class="hero-copy">
                    <div class="home-hero-layout">
                        <div class="home-hero-copy">
                    <span class="eyebrow">Preview Engine / Demo Portal</span>
                <h1 class="hero-title">开源的万能文件预览系统</h1>
                    <p class="hero-subtitle">
                        kkFileView 提供统一的文件预览入口，覆盖 5 大文件族群、70+ 常见文件类型，支持文件链接预览、上传文件预览，以及业务系统里的常见接入方式。
                    </p>
                    <div class="hero-actions">
                        <a class="hero-link primary" href="#demo-lab">开始体验</a>
                        <a class="hero-link secondary" href="./integrated">查看接入说明</a>
                        <a class="hero-link secondary" href="./record">版本发布记录</a>
                        <a class="hero-link secondary" href="./sponsor">赞助开源</a>
                    </div>
                        </div>
                        <div class="home-hero-side">
                    <div class="doc-stack" aria-hidden="true">
                        <div class="doc-sheet sheet-word">
                            <img src="images/hero-icons/word.svg" alt="Word">
                            <span>DOCX</span>
                        </div>
                        <div class="doc-sheet sheet-excel">
                            <img src="images/hero-icons/excel.svg" alt="Excel">
                            <span>XLSX</span>
                        </div>
                        <div class="doc-sheet sheet-powerpoint">
                            <img src="images/hero-icons/powerpoint.svg" alt="PowerPoint">
                            <span>PPTX</span>
                        </div>
                        <div class="doc-sheet sheet-pdf">
                            <img src="images/hero-icons/pdf.svg" alt="PDF">
                            <span>PDF</span>
                        </div>
                    </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="feature-section">
            <div class="section-heading">
                <div>
                    <span class="eyebrow">Capability Map</span>
                    <h2>支持丰富的文件类型预览</h2>
                </div>
                <p>
                    你可以先快速扫一遍支持范围，再判断它是否适合接入你的业务系统。
                    如果你有新增格式建议，也欢迎继续到开源社区补充。
                </p>
            </div>
            <div class="feature-grid">
                <article class="feature-card">
                    <span class="tag brand">Office</span>
                    <h3>办公文档</h3>
                    <p>面向日常业务流里最常见的 Office、WPS 与 LibreOffice 文档。</p>
                    <ul>
                        <li>doc / docx / xls / xlsx / ppt / pptx / csv / tsv</li>
                        <li>wps / dps / et / ett / wpt</li>
                        <li>odt / ods / odp / ott / fodt / fods</li>
                    </ul>
                </article>
                <article class="feature-card">
                    <span class="tag highlight">Engineering</span>
                    <h3>CAD 与 3D</h3>
                    <p>覆盖设计、制造和工程协同链路里经常出现的模型与图纸格式。</p>
                    <ul>
                        <li>dwg / dxf / dwf / dwt / plt / cf2</li>
                        <li>obj / 3ds / stl / gltf / glb / fbx / dae</li>
                        <li>ifc / step / iges / fcstd / bim / brep</li>
                    </ul>
                </article>
                <article class="feature-card">
                    <span class="tag">Image</span>
                    <h3>图片与图像</h3>
                    <p>支持常规位图、多页图像、矢量图，以及较新的移动端图片格式。</p>
                    <ul>
                        <li>jpg / png / gif / bmp / webp / heic</li>
                        <li>tif / tiff / tga / svg / wmf / emf</li>
                        <li>翻转、缩放、镜像等交互能力</li>
                    </ul>
                </article>
                <article class="feature-card">
                    <span class="tag brand">Archive</span>
                    <h3>压缩与文本</h3>
                    <p>压缩包目录浏览、纯文本渲染、源码文件高亮都属于默认能力范围。</p>
                    <ul>
                        <li>zip / rar / jar / tar / gzip / 7z</li>
                        <li>txt / md / xml / java / js / css / py / php</li>
                        <li>支持目录访问、搜索和服务端分页</li>
                    </ul>
                </article>
                <article class="feature-card">
                    <span class="tag warn">Media</span>
                    <h3>音视频与邮件</h3>
                    <p>覆盖业务里常见的媒体文件与邮件归档场景，兼顾转码和直接预览。</p>
                    <ul>
                        <li>mp3 / wav / mp4 / flv / avi / mov / mkv</li>
                        <li>eml / msg 邮件文件</li>
                        <li>epub / ofd / xmind / bpmn / drawio / dcm</li>
                    </ul>
                </article>
                <article class="feature-card">
                    <span class="tag">Security</span>
                    <h3>接入能力</h3>
                    <p>除了预览类型本身，首页也需要把接入时常用的控制项直接暴露出来。</p>
                    <ul>
                        <li>支持 AES、Basic Auth、FTP 参数扩展</li>
                        <li>支持页码、高亮、水印、密码与缓存刷新</li>
                        <li>支持本地上传、目录浏览、文件删除</li>
                    </ul>
                </article>
            </div>
        </section>

        <section class="workspace-section" id="demo-lab">
            <div class="workspace-card">
                <div class="workspace-header">
                    <div>
                        <span class="eyebrow">Demo Lab</span>
                        <h3>文件链接预览</h3>
                        <p>这里统一承接两种预览来源：直接输入 URL，或者从本地文件目录里选择文件。参数和操作入口都尽量收在一起。</p>
                    </div>
                    <div class="note-row">
                        <span class="note-pill">URL 预览</span>
                        <span class="note-pill">支持目录级访问</span>
                        <span class="note-pill">服务端分页</span>
                        <span class="note-pill">搜索与删除</span>
                    </div>
                </div>

                <div class="source-grid">
                    <div class="source-card">
                        <h4>输入 URL 直接试跑</h4>
                        <p>贴入文件地址，按需叠加页码、高亮、水印、AES 和跨域参数，直接在新窗口验证最终预览行为。</p>
                        <#if "${kkkey}" != "false" >
                            <p>
                                程序已启用秘钥访问。
                                <#if isshowkey>
                                    当前接入秘钥为 <span class="text-highlight">${kkkey}</span>。
                                <#else>
                                    如需秘钥，请联系管理员。
                                </#if>
                            </p>
                        </#if>
                        <div class="preview-panel">
                            <form action="${baseUrl}onlinePreview" target="_blank" id="previewByUrl">
                                <input type="hidden" name="url"/>
                                <div class="preview-options">
                                    <div class="preview-switches">
                                        <label><input type="checkbox" name="forceUpdatedCache" value="true"/> 更新缓存</label>
                                        <label><input type="checkbox" name="kkagent" value="true"/> 跨域代理</label>
                                        <label><input type="checkbox" id="encryption" name="encryption" value="aes"/> AES 加密</label>
                                    </div>
                                    <div class="preview-grid">
                                        <input type="text" id="filePassword" name="filePassword" class="form-control" placeholder="文件密码"/>
                                        <input type="text" id="page" name="page" class="form-control" placeholder="页码"/>
                                        <input type="text" id="highlightall" name="highlightall" class="form-control" placeholder="高亮关键字"/>
                                        <input type="text" id="watermarkTxt" name="watermarkTxt" class="form-control" placeholder="水印文本"/>
                                        <#if isshowkey>
                                            <input type="text" id="kkkey" name="key" class="form-control" placeholder="KK 秘钥"/>
                                        </#if>
                                    </div>
                                </div>
                                <div class="preview-url">
                                    <input type="text" id="_url" class="form-control" placeholder="请输入预览文件 URL，例如 https://example.com/demo.pdf"/>
                                    <input type="submit" value="立即预览" class="preview-submit">
                                </div>
                            </form>
                            <div class="alert alert-danger alert-dismissable hide" role="alert" id="previewCheckAlert">
                                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                                <strong>请输入正确的 URL</strong>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="section-heading">
                    <div>
                        <span class="eyebrow">Local Source</span>
                        <h2>上传文件预览</h2>
                    </div>
                </div>

                <div class="toolbar-grid">
                    <div class="toolbar-card">
                        <h4>文件操作</h4>
                        <#if fileUploadDisable == false>
                            <form enctype="multipart/form-data" id="fileUpload">
                                <div class="toolbar-inline">
                                    <input type="file" id="file" name="file" class="form-control"/>
                                    <input type="button" id="fileUploadBtn" class="btn toolbar-btn" value="上传文件"/>
                                    <input type="button" id="newFolderBtn" class="btn toolbar-btn" value="新建文件夹"/>
                                </div>
                            </form>
                        <#else>
                            <div class="disabled-upload">
                                <div class="alert alert-warning">
                                    <span class="glyphicon glyphicon-info-sign"></span>
                                    文件上传功能已禁用。如需开启，请修改配置文件或联系管理员。
                                </div>
                            </div>
                        </#if>
                    </div>
                    <div class="toolbar-card">
                        <h4>快速搜索</h4>
                        <div class="toolbar-inline">
                            <input type="text" id="searchInput" class="form-control" placeholder="搜索文件名..." value="${searchText!''}">
                            <button class="btn toolbar-btn" type="button" onclick="performSearch()">搜索</button>
                            <button class="btn toolbar-btn" type="button" onclick="clearSearch()">清除</button>
                        </div>
                    </div>
                </div>

                <ol class="modern-breadcrumb" id="pathBreadcrumb" style="display: none;">
                    <li><a href="javascript:void(0);" onclick="changeDirectory('')">根目录</a></li>
                </ol>

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
                                <button type="button" class="btn toolbar-btn" onclick="createNewFolder()">创建</button>
                                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                            </div>
                        </div>
                    </div>
                </div>

                <table id="table" data-pagination="true"></table>
            </div>
        </section>
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
    <div class="site-footer">
        <a target="_blank" href="https://beian.miit.gov.cn/">${beian}</a>
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
            $.post('${baseUrl}deleteFile', {fileName: fileName, password: deleteCaptchaText}, function(data){
                if (!data.success) {
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
                var password = prompt("请输入文件删除密码");
                if (password === null) {
                    return false;
                }
                $.ajax({
                    url: '${baseUrl}deleteFile',
                    type: 'POST',
                    data: {fileName: fileName, password: password},
                    success: function (data) {
                        if (!data.success) {
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
            showRefresh: false,
            showColumns: false,
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
                            return '<span class="text-highlight">' + match + '</span>';
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
        
        if (path) {
            breadcrumb.show();
            breadcrumb.append('<li><a href="javascript:void(0);" onclick="changeDirectory(\'\')">根目录</a></li>');
            var parts = path.split('/').filter(Boolean);
            var currentPath = '';
            
            parts.forEach(function(part, index) {
                currentPath += (currentPath ? '/' : '') + part;
                if (index < parts.length - 1) {
                    breadcrumb.append('<li><a href="javascript:void(0);" onclick="changeDirectory(\'' + currentPath + '\')">' + part + '</a></li>');
                } else {
                    breadcrumb.append('<li class="active">' + part + '</li>');
                }
            });
        } else {
            breadcrumb.hide();
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
