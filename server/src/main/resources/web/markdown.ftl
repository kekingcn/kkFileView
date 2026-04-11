<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>${file.name}文本预览</title>
    <#include "*/commonHeader.ftl">
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="css/index.css"/>
    <script src="bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="js/marked.min.js" type="text/javascript"></script>
    <script src="js/base64.min.js" type="text/javascript"></script>
    <script src="js/codemirror.js" type="text/javascript"></script>
</head>
<body>
<input hidden id="textData" value="${textData}"/>

<div class="main-container">
    <!-- 目录区域 - 左侧 -->
    <div id="directory">
        <div>文档目录</div>
        <div id="content">
            <ul></ul>
            <div class="empty-toc" style="display:none;">暂无目录</div>
        </div>
    </div>

    <!-- 主内容区域 -->
    <div class="content-container">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h6 class="panel-title">
                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                        ${file.name}
                    </a>
                </h6>
            </div>
            
            <!-- 视图切换按钮 -->
            <div class="view-toggle">
                <button id="preview_btn" class="view-btn active">预览模式</button>
                <button id="source_btn" class="view-btn">源代码</button>
            </div>
            
            <div class="panel-body">
                <div id="markdown"></div>
            </div>
        </div>
    </div>
</div>

<textarea id="textarea" style="display:none;"></textarea>

<script>
    // 初始化编辑器
    var editor = CodeMirror.fromTextArea(document.getElementById('textarea'), { 
        mode: "text/html",
        lineNumbers: true,
        tabMode: "indent",
        lineWrapping: false,
        theme: "default",
        viewportMargin: Infinity
    });
	
	 var kkkeyword = '${highlightall}';
    
    // 初始化目录
    function initTOC() {
        let html = "";
        let index = 0;
        
        // 从预览内容中提取标题
        $("#markdown h1, #markdown h2, #markdown h3, #markdown h4, #markdown h5").each(function() {
            let id = "heading-" + index++;
            $(this).attr('id', id);
            let level = this.tagName.toLowerCase().replace('h', '');
            let text = $(this).text();
            if (text.length > 50) {
                text = text.substring(0, 50) + "...";
            }
            html += '<li class="li-h' + level + '"><a href="#' + id + '" title="' + $(this).text() + '">' + text + '</a></li>';
        });
        
        $("#directory ul").html(html);
        
        // 显示/隐藏空目录提示
        if (html === "") {
            $("#directory .empty-toc").show();
            $("#directory ul").hide();
        } else {
            $("#directory .empty-toc").hide();
            $("#directory ul").show();
        }
        
        // 确保目录滚动条可见
        setTimeout(function() {
            const contentDiv = document.getElementById('content');
            if (contentDiv.scrollHeight > contentDiv.clientHeight) {
                contentDiv.style.paddingRight = '8px';
            }
        }, 100);
    }
    
    // 安全HTML转义函数
    function htmlEscape(str) {
        if (!str) return "";
        return str
           
            .replace(/</g, "&lt;")
 
            .replace(/javascript/gi, "javascript ");
    }
    
    // 加载markdown内容
    function loadMarkdown() {
        try {
            var textData = Base64.decode($("#textData").val());
            textData = htmlEscape(textData);
            
         
           // 应用关键字高亮
const highlightedText = highlightKeyword(textData, kkkeyword);
window.textPreData = "<div style='width:100%;'><pre>" + highlightedText + "</pre></div>";
window.textMarkdownData = marked.parse(highlightedText);
            
            $("#markdown").html(window.textMarkdownData);
            editor.setValue(textData);
            
            // 更新编辑器容器宽度
            setTimeout(function() {
                editor.refresh();
                // 设置编辑器高度
                const panelBody = $('.panel-body');
                const editorHeight = panelBody.height() - 40; // 减去一些padding
                editor.setSize('100%', editorHeight);
            }, 100);
            
            // 初始化目录
            initTOC();
            
        } catch (e) {
            console.error("加载内容失败:", e);
            $("#markdown").html("<div class='alert alert-danger' style='padding:15px;border-radius:8px;width:100%;'>加载内容失败: " + e.message + "</div>");
        }
    }
	
	


function highlightKeyword(text, keyword) {
    if (!keyword || keyword.trim() === '') return text;
    
    const escapedKeyword = keyword.replace(/[.*+?^${'$'}{}()|[\]\\]/g, '\\$&');
    const regex = new RegExp('(' + escapedKeyword + ')', 'gi');
    
    return text.replace(regex, '<span class="highlight-keyword">$1</span>');
}
    
    // 切换视图
    function switchView(mode) {
        if (mode === 'preview') {
            $("#preview_btn").addClass('active');
            $("#source_btn").removeClass('active');
            $("#markdown").html(window.textMarkdownData);
            initTOC();
        } else {
            $("#source_btn").addClass('active');
            $("#preview_btn").removeClass('active');
            $("#markdown").html(window.textPreData);
            $("#directory .empty-toc").show();
            $("#directory ul").hide();
            
            // 源代码模式下确保pre元素样式正确
            $("#markdown pre").css({
                'max-width': '100%',
                'overflow-x': 'auto',
                'background-color': '#f8f9fa',
                'border': '1px solid #e9ecef',
                'border-radius': '8px',
                'padding': '18px',
                'word-wrap': 'break-word',
                'white-space': 'pre-wrap'
            });
        }
    }
	
    
    // 页面加载完成
    $(document).ready(function() {
        // 初始化水印
        if (typeof initWaterMark === 'function') {
            initWaterMark();
        }
        
        // 加载markdown内容
        loadMarkdown();
        
        // 监听编辑器变化
      editor.on('change', function(cm) {
    // 更新预览
    var content = cm.getValue();
    // 应用关键字高亮
    const highlightedContent = highlightKeyword(content, kkkeyword);
    window.textPreData = "<div style='width:100%;'><pre>" + highlightedContent + "</pre></div>";
    window.textMarkdownData = marked.parse(highlightedContent);
    
    // 如果当前是预览模式，更新预览内容
    if ($("#preview_btn").hasClass('active')) {
        $("#markdown").html(window.textMarkdownData);
        initTOC();
    }
});
        
        // 绑定视图切换事件
        $("#preview_btn").click(function() {
            switchView('preview');
        });
        
        $("#source_btn").click(function() {
            switchView('source');
        });
        
        // 为目录链接添加平滑滚动
        $(document).on('click', '#directory a', function(e) {
            e.preventDefault();
            var target = $(this.getAttribute('href'));
            if (target.length) {
                // 滚动主内容区域
                $('.panel-body').animate({
                    scrollTop: target.offset().top + $('.panel-body').scrollTop() - 20
                }, 500);
                
                // 高亮当前目录项
                $('#directory li a').removeClass('active');
                $(this).addClass('active');
            }
        });
        
        // 窗口调整大小时重新计算高度
        $(window).resize(function() {
            // 更新编辑器大小
            if (editor) {
                const panelBody = $('.panel-body');
                const editorHeight = panelBody.height() - 40;
                editor.setSize('100%', editorHeight);
                editor.refresh();
            }
        });
        
        // 添加键盘快捷键
        $(document).keydown(function(e) {
            // Ctrl+1 切换到预览模式
            if (e.ctrlKey && e.key === '1') {
                e.preventDefault();
                switchView('preview');
            }
            // Ctrl+2 切换到源代码模式
            else if (e.ctrlKey && e.key === '2') {
                e.preventDefault();
                switchView('source');
            }
        });
        
        // 添加目录项悬停效果
        $(document).on('mouseenter', '#directory li a', function() {
            $(this).css('background-color', '#e9ecef');
        }).on('mouseleave', '#directory li a', function() {
            if (!$(this).hasClass('active')) {
                $(this).css('background-color', 'transparent');
            }
        });
        
        // 监听主内容区域滚动，更新目录高亮
        $('.panel-body').scroll(function() {
            if ($("#preview_btn").hasClass('active')) {
                var scrollTop = $('.panel-body').scrollTop();
                var found = false;
                
                $('#markdown h1, #markdown h2, #markdown h3, #markdown h4, #markdown h5').each(function() {
                    var elementTop = $(this).offset().top;
                    var elementBottom = elementTop + $(this).outerHeight();
                    
                    if (elementTop <= scrollTop + 50 && elementBottom > scrollTop + 50) {
                        var id = $(this).attr('id');
                        $('#directory li a').removeClass('active');
                        $('#directory li a[href="#' + id + '"]').addClass('active');
                        found = true;
                        return false;
                    }
                });
                
                if (!found) {
                    $('#directory li a').removeClass('active');
                }
            }
        });
    });
</script>
</body>
</html>