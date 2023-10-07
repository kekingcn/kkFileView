<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>${file.name}播放器</title>
		<link type="text/css" rel="stylesheet" href="ckplayer/css/ckplayer.css" />
		<#if "${file.suffix?lower_case}" == "m3u8" >
		<script type="text/javascript" src="ckplayer/hls.js/hls.min.js"></script>
	 <#elseif "${file.suffix?lower_case}" == "flv">
		<script type="text/javascript" src="ckplayer/flv.js/flv.min.js"></script>
			<#elseif "${file.suffix?lower_case}" == "ts">
			<script type="text/javascript" src="ckplayer/mpegts.js/mpegts.js"></script>
            <#elseif "${file.suffix?lower_case}" == "mpd">
			<script type="text/javascript" src="ckplayer/js/dash.all.min.js"></script>
		</#if>
	<script type="text/javascript" src="ckplayer/js/ckplayer.min.js" charset="UTF-8"></script>
		<#include "*/commonHeader.ftl">
		<style>
			.adpause{
				width: 90%;
				height: 90%;
				max-width: 580px;
				max-height: 360px;
				color: #FFF;
				position: absolute;
				background: #07141E;
				top:0;
				bottom: 0;
				left: 0;
				right: 0;
				margin: auto;
				font-size: 30px;
				line-height: 38px;
				box-sizing:border-box;
				-moz-box-sizing:border-box; /* Firefox */
				-webkit-box-sizing:border-box; /* Safari */	
				padding: 50px;
				display: none;
			}
     .video{
		width: 100%; 
		height: 600px;
		max-width: 900px;  
		margin: auto;
         position: absolute;
        top: 0;
       left: 0;
       bottom: 0;
       right: 0;
     background-color: green;
			}
		</style>
	</head>
	<body>
	<div class="video">播放容器</div>
				<script>
                <#if "${file.suffix?lower_case}" == "mpd" >
                function dashPlayer(video,fileUrl){
				video.attr('data-dashjs-player',' ');
				video.attr('src',fileUrl);
			} 
            </#if>
	var videoObject = {
				container: '.video', //视频容器
				//autoplay:true,//自动播放
               // live:true,//指定为直播
               //  crossOrigin:'Anonymous',//发送跨域信息，示例：Anonymous
			    plug:<#if "${file.suffix?lower_case}" == "m3u8" >'hls.js'<#elseif "${file.suffix?lower_case}" == "ts" >'mpegts.js'<#elseif "${file.suffix?lower_case}" == "flv" >'flv.js'<#elseif "${file.suffix?lower_case}" == "mpd" >dashPlayer<#else>''</#if>,//设置使用插件
                loop: false,//是否需要循环播放
                rightBar:true,
                screenshot:true,//截图功能是否开启
                webFull:true,//是否启用页面全屏按钮，默认不启用
				//poster:'ckplayer/poster.png',//封面图片
				menu:[
			{
				title:'kkFileView',
				link:'https://www.kkview.cn',
				underline:true
			},
			{
				title:'播放/暂停',
				click:'player.playOrPause',
			},
			{
				title:'关于视频',
				click:'aboutShow'
			}
		],
         	information:{
			'已加载：':'{loadTime}秒',
			'总时长：':'{duration}秒',
			'视频尺寸：':'{videoWidth}x{videoHeight}',
			'音量：':'{volume}%',
			'FPS：':'{fps}',
			'音频解码：':'{audioDecodedByteCount} Byte',
			'视频解码：':'{videoDecodedByteCount} Byte',
		},
		video:'${mediaUrl}'//视频地址
			};
			var player=new ckplayer(videoObject)//调用播放器并赋值给变量player
			  		 /*初始化水印*/
 if (!!window.ActiveXObject || "ActiveXObject" in window)
{
}else{
 initWaterMark();
}
		</script>
			

	</body>
</html>
