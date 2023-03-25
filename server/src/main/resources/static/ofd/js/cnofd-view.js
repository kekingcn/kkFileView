function _createForOfIteratorHelper(o, allowArrayLike) { var it = typeof Symbol !== "undefined" && o[Symbol.iterator] || o["@@iterator"]; if (!it) { if (Array.isArray(o) || (it = _unsupportedIterableToArray(o)) || allowArrayLike && o && typeof o.length === "number") { if (it) o = it; var i = 0; var F = function F() {}; return { s: F, n: function n() { if (i >= o.length) return { done: true }; return { done: false, value: o[i++] }; }, e: function e(_e) { throw _e; }, f: F }; } throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); } var normalCompletion = true, didErr = false, err; return { s: function s() { it = it.call(o); }, n: function n() { var step = it.next(); normalCompletion = step.done; return step; }, e: function e(_e2) { didErr = true; err = _e2; }, f: function f() { try { if (!normalCompletion && it.return != null) it.return(); } finally { if (didErr) throw err; } } }; }

$("#openFile").click(function() {
    openFile();
});

$("#file").change(function() {
    fileChanged();
});

$("#zoomIn").click(function() {
    zoomIn();
});

$("#zoomOut").click(function() {
    zoomOut();
});

$("#zoomValue").change(function() {
    zoomChange();
});

$("#firstPage").click(function() {
    firstPage();
});

$("#prePage").click(function() {
    prePage();
});

$("#nextPage").click(function() {
    nextPage();
});

$("#lastPage").click(function() {
    lastPage();
});

$("#print").click(function() {
    print();
});

$("#main").scroll(function() {
    scrool();
});

window.onresize = function() {
    return function() {
        var contentDiv = document.getElementById("content");

        var nowleft = 0;
        if (contentDiv.childNodes[0]) nowleft = contentDiv.childNodes[0].offsetLeft;
    } ();
};

// 手机端，隐藏缩放比例选择框，打开文件和打印按钮
if (this.isMobile()) {
    if (document.getElementById("zoomSelect")) document.getElementById("zoomSelect").style.display = "none";
    if (document.getElementById("openFile")) document.getElementById("openFile").style.display = "none";
    if (document.getElementById("print")) document.getElementById("print").style.display = "none";
    if (document.getElementById("separator1")) document.getElementById("separator1").style.display = "none";
    if (document.getElementById("separator2")) document.getElementById("separator2").style.display = "none";
}

// 判断手机端还是PC端
function isMobile() {
    var flag = navigator.userAgent.match(/(phone|pad|pod|iPhone|iPod|ios|iPad|Android|Mobile|BlackBerry|IEMobile|MQQBrowser|JUC|Fennec|wOSBrowser|BrowserNG|WebOS|Symbian|Windows Phone)/i);
    return flag;
}
// 判断是否IE浏览器
function isIE() {
	var navigator = window.navigator.userAgent;
	if (navigator.indexOf("MSIE") > 0 || navigator.indexOf("Trident") > 0) {
		return true;
	}
	return false;
}

this.screenWidth = document.body.clientWidth;

// cnofd提供浏览器端和服务端两种OFD版式文件的解析渲染模式。
// 服务器渲染模式；浏览器端渲染时，请注释以下两行代码
//Object(cnofd["setRenderMode"])("Server");
//Object(cnofd["setServerUrl"])("http://localhost:8080/api/ofdrender/");

data: function data() {
    return {
        leftMenuWidth: 0,
        ofdBase64: null,
        pageIndex: 1,
        pageCount: 0,
        title: null,
        value: null,
        ofdDoc: null,
        screenWidth: document.body.clientWidth,
        ofdDiv: null,
        isFont: false
    };
}

this.pageZoomScale = "1.0";
cnofd["setScaleValue"](this.pageZoomScale);
var scale = this.getQueryVariable("scale");
if (scale && (scale == "width" || Number(scale))) {
    this.pageZoomScale = scale;
    cnofd["setScaleValue"](scale);
}

var file = this.getQueryVariable("file");
    file = decodeURIComponent(file);  
if (file) this.loadOfdFile(file);

if (scale && (scale == "width" || Number(scale))) {
    var selectZoom = document.getElementById("zoomValue");

    selectZoom.selectedIndex = -1;
    if (this.pageZoomScale == "width") {
        selectZoom.selectedIndex = 0;
    } else {
        for (var i = 1; i < selectZoom.length; i++) {
            if (Math.abs(this.pageZoomScale - selectZoom.options[i].value) < 0.01) {
                selectZoom.selectedIndex = i;
                break;
            }
        }
    }
}

function getQueryVariable(variable) {
    var query = window.location.search.substring(1);
    var vars = query.split("&");

    for (var i = 0; i < vars.length; i++) {
        var pair = vars[i].split("=");

        if (pair[0] == variable) {
            return pair[1];
        }
    }

    return false;
}

function loadOfdFile(ofdFile) {
    var that = this;
    JSZipUtils.getBinaryContent(ofdFile,
    function(err, data) {
        if (err) {
            console.log(err);
        } else {
            var base64String = btoa(String.fromCharCode.apply(null, new Uint8Array(data)));
            that.ofdBase64 = base64String;
        }
    });
    this.getOfdDocument(ofdFile, this.screenWidth, this.pageZoomScale);

    setPageInfo();
}

function openFile() {
    this.isFont = false;
    this.file = null;
    $("#file")[0].click();
}

function fileChanged() {
    this.file = $("#file")[0].files[0];
    if (this.file == null) 
        return;
    
    var ext = this.file.name.replace(/.+\./, "");

    if (["ofd"].indexOf(ext) === -1) {
        this.$alert("error", "仅支持ofd文件类型", {
            confirmButtonText: "确定",
            callback: function callback(action) {
                this.$message({
                    type: "info",
                    message: "action: ".concat(action)
                });
            }
        });
        return;
    }

    if (this.file.size > 10 * 1024 * 1024) {
        this.$alert("error", "文件大小超过10MB", {
            confirmButtonText: "确定",
            callback: function callback(action) {
                this.$message({
                    type: "info",
                    message: "action: ".concat(action)
                });
            }
        });
        return;
    }

    // 新打开OFD文件时，还原成页面实际尺寸显示
    //Object(cnofd["setScaleValue"])(1.0);
    Object(cnofd["setScaleValue"])(this.pageZoomScale);
    var selectZoom = document.getElementById("zoomValue");
    if (selectZoom)
        selectZoom.value = this.pageZoomScale;
        
    var that = this;
    var reader = new FileReader();
    reader.readAsDataURL(this.file);

    reader.onload = function(e) {
        that.ofdBase64 = e.target.result.split(",")[1];
    };

    this.getOfdDocument(this.file, this.screenWidth, this.pageZoomScale);
    //$("#file")[0].value = null;
}

function getOfdDocument(file, screenWidth, pageZoomScale) {
    var that = this;

    $("#loading").show();

    var contentDiv = document.getElementById("content");
    contentDiv.innerHTML = "";
    Object(cnofd["ofdParse"])({
        ofd: file,
        success: function success(res) {
            that.ofdDoc = res;
            that.pageIndex = 1;
            that.pageCount = res.pageCount;
            if (pageZoomScale == "width") {
                var divs = Object(cnofd["ofdRender"])(res, screenWidth);
                that.displayOfdDiv(divs);
            } else {
                var divs = Object(cnofd["ofdRenderByScale"])(res, screenWidth, pageZoomScale);
                that.displayOfdDiv(divs);                
            }
            $("#loading").hide();
        },
        fail: function fail(error) {
            $("#loading").hide();
            alert("OFD打开失败", error, {
                confirmButtonText: "确定",
                callback: function callback(action) {
                    this.$message({
                        type: "info",
                        message: "action: ".concat(action)
                    });
                }
            });
        }
    });
}

function displayOfdDiv(divs) {
    var contentDiv = document.getElementById("content");
    contentDiv.innerHTML = "";

    var _iterator3 = _createForOfIteratorHelper(divs),
    _step3;

    try {
        for (_iterator3.s(); ! (_step3 = _iterator3.n()).done;) {
            var div = _step3.value;
            contentDiv.appendChild(div);
        }
    } catch(err) {
        _iterator3.e(err);
    } finally {
        _iterator3.f();
    }

    setPageInfo();
}

function zoomIn() {
    var selectZoom = document.getElementById("zoomValue");
    if (selectZoom.selectedIndex > 1) {
        selectZoom.selectedIndex = selectZoom.selectedIndex - 1;
        
        Object(cnofd["setScaleValue"])(selectZoom.options[selectZoom.selectedIndex].value);
        var divs = Object(cnofd["ofdRenderByScale"])(this.ofdDoc);
        if (divs) {
          this.displayOfdDiv(divs);
        } else {
          this.getOfdDocument(this.file, this.screenWidth);
        }  
    }
}

function zoomOut() {
    var selectZoom = document.getElementById("zoomValue");
    if (selectZoom.selectedIndex < selectZoom.length-1) {
        selectZoom.selectedIndex = selectZoom.selectedIndex + 1;
        if (selectZoom.selectedIndex == 0) selectZoom.selectedIndex = 1;
        
        Object(cnofd["setScaleValue"])(selectZoom.options[selectZoom.selectedIndex].value);
        var divs = Object(cnofd["ofdRenderByScale"])(this.ofdDoc);
        if (divs) {
          this.displayOfdDiv(divs);
        } else {
          this.getOfdDocument(this.file, this.screenWidth);
        }  
    }
}

function zoomChange() {
    var selectZoom = document.getElementById("zoomValue");
    if (selectZoom.options[selectZoom.selectedIndex].value == "width") {
        Object(cnofd["setScaleValue"])(selectZoom.options[selectZoom.selectedIndex].value);
        var divs = Object(cnofd["ofdRender"])(this.ofdDoc, this.screenWidth);
        if (divs) {
          this.displayOfdDiv(divs);
        } else {
          this.getOfdDocument(this.file, this.screenWidth);
        } 
    } else {
        Object(cnofd["setScaleValue"])(selectZoom.options[selectZoom.selectedIndex].value);
        var divs = Object(cnofd["ofdRenderByScale"])(this.ofdDoc);
        if (divs) {
          this.displayOfdDiv(divs);
        } else {
          this.getOfdDocument(this.file, this.screenWidth);
        } 
    }
}

function scrool() {
    var contentDiv = document.getElementById("content");
    
    var contentDiv1 = contentDiv.firstElementChild;

    var scrolled = (contentDiv1 === null || contentDiv1 === void 0 ? void 0 : contentDiv1.getBoundingClientRect() === null || contentDiv1.getBoundingClientRect() === void 0 ? void 0 : contentDiv1.getBoundingClientRect().top) - 60;
    var top = 0;
    var index = 0;

    for (var i = 0; i < contentDiv.childElementCount; i++) {
        var contentDiv2 = contentDiv.children.item(i);

        top += Math.abs(contentDiv2 === null || contentDiv2 === void 0 ? void 0 : contentDiv2.style.height.replace("px", "")) + Math.abs(contentDiv2 === null || contentDiv2 === void 0 ? void 0 : contentDiv2.style.marginBottom.replace("px", ""));

        if (Math.abs(scrolled) < top) {
            index = i;
            break;
        }
    }

    this.pageIndex = index + 1;

    setPageInfo();
}

function setPageInfo() {
    if (! (this.pageCount == null) && this.pageCount > 0) {
        $("#pageInfo")[0].innerText = this.pageIndex + "/" + this.pageCount;
    }
}

function prePage() {
    var contentDiv = document.getElementById("content");
    var ele = contentDiv.children.item(this.pageIndex - 2);
    ele === null || ele === void 0 ? void 0 : ele.scrollIntoView(true);
    ele ? this.pageIndex = this.pageIndex - 1 : "";

    setPageInfo();
}

function firstPage() {
    var contentDiv = document.getElementById("content");
    var ele = contentDiv.firstElementChild;
    ele === null || ele === void 0 ? void 0 : ele.scrollIntoView(true);
    ele ? this.pageIndex = 1 : "";

    setPageInfo();
}

function nextPage() {
    var contentDiv = document.getElementById("content");
    var ele = contentDiv.children.item(this.pageIndex);
    ele === null || ele === void 0 ? void 0 : ele.scrollIntoView(true);
    ele ? ++this.pageIndex: "";

    setPageInfo();
}

function lastPage() {
    var contentDiv = document.getElementById("content"); 
    var ele = contentDiv.children.item(contentDiv.childElementCount - 1);
    ele === null || ele === void 0 ? void 0 : ele.scrollIntoView(true); 
    ele ? this.pageIndex = contentDiv.childElementCount : "";

    setPageInfo();
}

function print() {
    var contentDiv = document.getElementById("content"); 
    var contentDivChilds = contentDiv.children;
    var list = [];

    for (var i = 0; i < contentDivChilds.length; i++) {
        var ele = contentDivChilds.item(i);
        list.push(ele.cloneNode(true));
        this.percentage = i / contentDivChilds.length;
    }
        
    if (list.length > 0) {
        if (!isIE()) {
            var mywindow = window.open("打印窗口", "_blank"); 
            mywindow.document.write('<!DOCTYPE html><html><head>'
                                   +'<style media="print">.page-break { page-break-inside: avoid; page-break-after: always; }</style>'
                                   +'</head><body></body</html>');
            var documentBody = mywindow.document.body; 
            var _iterator2 = _createForOfIteratorHelper(list),
            _step2;

            try {
                for (_iterator2.s(); ! (_step2 = _iterator2.n()).done;) {
                    var canvas = _step2.value;
                    canvas.style.margin = "";
                    canvas.style.boxShadow = "";
                    documentBody.appendChild(canvas);
                }
            } catch(err) {
                _iterator2.e(err);
            } finally {
                _iterator2.f();
            }

            mywindow.focus();
            mywindow.print();
            mywindow.close();   
            
        } else {
            var printhtml = "";
            for (var i=0; i < list.length; i++) {
                var canvas = list[i];
                canvas.style.margin = "";
                canvas.style.boxShadow = "";
                printhtml = printhtml + canvas.outerHTML;
            }
            printIE(printhtml);     
        }
    }
}

// IE浏览器，在iframe里调用打印 
function printIE(printhtml) {
    //新建一个iframe 
    var iframe = document.createElement("iframe"); 
    iframe.id = "printf"; 
    iframe.style.width = "0"; 
    iframe.style.display = "none"
    iframe.style.height = "0"; 
    iframe.style.border = "none";
     
    //将iframe插入到printBody里 
    document.body.appendChild(iframe); 
    
    setTimeout(function () { 
                                iframe.contentDocument.write(" <script type='text/javascript'>  window.onload = function() { document.execCommand('print'); } </script> " + printhtml); 
                                iframe.contentDocument.close(); 
                            },
                            100)
}

