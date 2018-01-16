<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>图片预览图</title>
    <link rel="stylesheet" href="css/viewer.min.css">
    <style>
        * { margin: 0; padding: 0;}
        #dowebok { width: 800px; margin: 0 auto; font-size: 0;}
        #dowebok li {  display: inline-block;width: 50px;height: 50px; margin-left: 1%; padding-top: 1%;}
        /*#dowebok li img { width: 200%;}*/
    </style>
</head>
<body>
<ul id="dowebok">
        <#list imgurls as img>
            <li><img id="${img}"  url="${img}" src="${img}" width="1px" height="1px"></li>
        </#list>
</ul>
<script src="js/viewer.min.js"></script>
<script>
    var viewer = new Viewer(document.getElementById('dowebok'), {
        url: 'src',
       navbar:false
    });
    document.getElementById("${currentUrl}").click();
</script>
</body>

</html>
