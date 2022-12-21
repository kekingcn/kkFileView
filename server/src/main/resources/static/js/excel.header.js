/**创建一个div并固定在底部，将center中的所有a标签放在改div中**/
$("body").append($("<div>").css({"width":"100%","height":"100%px","position":"fixed","top":"0","left":"0"
    ,"background-color":"rgba(53, 53, 53, 1)","line-height":"30px","font-size":"13px"}).attr("id","excel-header-nav"));
$("center").css("display", "none");
var centerChildrenA = $("center").children("a");
if (centerChildrenA.length === 0) {
    $("#excel-header-nav").hide();
}
$(centerChildrenA).each(function (a, b) {
    // 获取a标签对应的target的name值，并设置name对应标签的样式以避免锚点标签标题被覆盖
    var href = $(b).attr("href");
    var name = href.substr(1);
    $("[name=" + name + "]").css({"display":"block","padding-top":"14.01px"});
    $(b).css({"padding":"5px","border-right":"1px solid white","color":"#f9f9f9"});
    $("#excel-header-nav").append(b);
});
/**给所有的table添加class=table table-striped样式**/
$("table").addClass("table table-striped");
/**
 * openoffice，只有一个 colgroup，用col子标签来描述列,liboffice 每一列都是一个colgroup 
 * var meta = $("meta[name=generator]");
 * LibreOffice  //OpenOffice
 * console.log(meta[0].content);
 */
/**计算表头宽度----start**/
function ______getColgroupWidth(colgroups){
	var twidth = 0;
	$(colgroups).each(function (i, g) {
		var w = $(g).attr("width");
		var s = $(g).attr("span");
		if(null==s || undefined==s){
			s=1;
		}
		twidth +=1*w*s;
	});
	return twidth;
}
$("table").each(function (a, b) {
	var twidth = 0;
    var tableChildrenColgroup = $(b).children("colgroup");
    if(0==tableChildrenColgroup.length){
    }else if(1==tableChildrenColgroup.length){
    	var cols = tableChildrenColgroup.children("col");
    	if(0==cols.length){
    		twidth=______getColgroupWidth(tableChildrenColgroup);
    	}else{
    		$(cols).each(function (i, g) {
        		var w = $(g).attr("width");
        		twidth +=1*w;
        	});
    	}
    }else{
    	twidth = ______getColgroupWidth(tableChildrenColgroup);
    }
    $(b).css({"width":twidth});
});