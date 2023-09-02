(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global = global || self, global.ckplayerLanguage = factory());
}(this, function () { 'use strict';
	/*
	 * 功能：包含播放器用到的全部相关语言文字
	 */
	var language={
		play:'播放',
		pause:'暂停',
		refresh:'重播',
		full:'全屏',
		exitFull:'退出全屏',
		webFull:'页面全屏',
		exitWebFull:'退出页面全屏',
		theatre:'剧场模式',
		exitTheatre:'退出剧场模式',
		volume:'音量：',
		muted:'静音',
		exitmuted:'恢复音量',
		seek:'seek：',
		waiting:'缓冲',
		live:'直播中',
		backLive:'返回直播',
		lookBack:'回看：',
		next:'下一集',
		screenshot:'视频截图',
		smallwindows:'小窗口播放功能',
		playbackrate:'倍速',
		playbackrateSuffix:'倍',
		track:'字幕',
		noTrack:'无字幕',
		definition:'清晰度',
		switchTo:'切换成：',
		closeTime:'{seconds}秒后可关闭广告',
		closeAd:'关闭广告',
		second:'秒',
		details:'查看详情',
		copy:'复制',
		copySucceeded:'复制成功，可贴粘！',
		smallwindowsOpen:'小窗口功能已开启',
		smallwindowsClose:'小窗口功能已关闭',
		screenshotStart:'截图中，请稍候...',
		screenshotClose:'截图功能已关闭',
		loopOpen:'循环播放',
		loopClose:'已关闭循环播放',
		close:'关闭',
		down:'下载',
		p50:'50%',
		p75:'75%',
		p100:'100%',
		timeScheduleAdjust:{
			prohibit:'视频禁止拖动',
			prohibitBackOff:'视频禁止重复观看',
			prohibitForward:'视频禁止快进',
			prohibitLookBack:'视频禁止播放部分内容',
			prohibitForwardNotViewed:'视频禁止播放未观看的部分'
		},
		error:{
			noMessage:'未知错误',
			supportVideoError:'该浏览器版本太低，建议更换成其它浏览器',
			videoTypeError:'该浏览器不支持播放该视频，建议更换成其它浏览器',
			loadingFailed:'加载失败',
			emptied:'视频文件加载过程中出现错误',
			screenshot:'视频截图失败',
			ajax:'Ajax数据请求错误',
			noVideoContainer:'未找到放置视频的容器'
		}
	};
	return language;
}))