<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>${file.name}预览</title>
<#include "*/commonHeader.ftl">
<link rel="stylesheet" href="xspreadsheet/xspreadsheet.css"/>
<script src="xspreadsheet/xspreadsheet.js"></script>
<script src="xspreadsheet/is-utf8.js"></script>
<script src="xspreadsheet/xlsx.full.min.js"></script>
<script src="xspreadsheet/xlsxspread.min.js"></script>
<script src="xspreadsheet/zh-cn.js"></script>
<script src="js/base64.min.js" type="text/javascript"></script>
</head>
	<#if csvUrl?contains("http://") || csvUrl?contains("https://")>
    <#assign finalUrl="${csvUrl}">
    <#elseif csvUrl?contains("ftp://") >
  <#assign finalUrl="${csvUrl}">
<#else>
    <#assign finalUrl="${baseUrl}${csvUrl}">
</#if>
<body>
<div id="htmlout"></div>
<script>
x_spreadsheet.locale('zh-cn');
var HTMLOUT = document.getElementById('htmlout');
var xspr = x_spreadsheet(HTMLOUT);
HTMLOUT.style.height = (window.innerHeight - 400) + "px";
HTMLOUT.style.width = (window.innerWidth - 50) + "px";

var process_wb = (function() {
  return function process_wb(wb) {
    var data = stox(wb);
    xspr.loadData(data);
    if(typeof console !== 'undefined') console.log("output", new Date());
  };
})();
 var url = '${finalUrl}';
  var baseUrl = '${baseUrl}'.endsWith('/') ? '${baseUrl}' : '${baseUrl}' + '/';
    if (!url.startsWith(baseUrl)) {
         url = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(url));
    }
let xhr = new XMLHttpRequest();
xhr.open('GET',url); //文件所在地址
xhr.responseType = 'blob';
xhr.onload = () => {
let content = xhr.response;
let blob = new Blob([content]);
let file = new File([blob],'excel.csv',{ type: 'excel/csv' });
var reader = new FileReader();
reader.onload = function(e) {
      if(typeof console !== 'undefined') console.log("onload", new Date());
      var data = e.target.result;
          data = new Uint8Array(data);
          let f = isUTF8(data);
            if (f) {
             try {
         var str = cptable.utils.decode(65001, data);
          process_wb(XLSX.read(str, { type: "string" }));
        } catch (error) {
       process_wb(XLSX.read(data));
          }
              } else {
              try {
         var str = cptable.utils.decode(936, data);
          process_wb(XLSX.read(str, { type: "string" }));
        } catch (error) {
       process_wb(XLSX.read(data));
          }
           }
};
reader.readAsArrayBuffer(file);
        }
        xhr.send();
   		 /*初始化水印*/
 if (!!window.ActiveXObject || "ActiveXObject" in window)
{
}else{
 initWaterMark();
}
</script>

</body>
</html>