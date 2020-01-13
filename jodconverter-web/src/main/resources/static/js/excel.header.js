/**创建一个div并固定在底部，将center中的所有a标签放在改div中**/
$("body").append($("<div>").css({"width":"100%","height":"200px","position":"fixed","overflow": "auto","top":"0","left":"0"
    ,"line-height":"30px","font-size":"13px"}).attr("id","excel-header-nav"));
$("center").css("display", "none");
var centerChildrenA = $("center").children("a");
if (centerChildrenA.length === 0) {
    $("#excel-header-nav").hide();
}
$(centerChildrenA).each(function (a, b) {
    // 获取a标签对应的target的name值，并设置name对应标签的样式以避免锚点标签标题被覆盖
    var href = $(b).attr("href");
    var name = href.substr(1);
    console.log(href + ":" + name);
    $(b).attr("title",$(b).text())
    $("[name=" + name + "]").css({"display":"block","padding-top":"14.01px"});
    $(b).css({"padding":"5px","border-right":"1px solid white","color":"#000","display":"inline-block","width":"100px","overflow":"hidden","text-overflow":"ellipsis","white-space":"nowrap","background-color":"white"});
    $("#excel-header-nav").append(b);
});
/**给所有的table添加class=table table-striped样式**/
$("table").addClass("table table-striped");
$("body").css("margin-top","200px")
