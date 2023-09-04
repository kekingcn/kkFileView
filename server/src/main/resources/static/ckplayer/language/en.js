(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global = global || self, global.ckplayerLanguage = factory());
}(this, function () { 'use strict';
	/*
	 * 功能：包含播放器用到的全部相关语言文字
	 */
	var language={
		play:'Play',
		pause:'Pause',
		refresh:'Refresh',
		full:'Fullscreen',
		exitFull:'Non-Fullscreen',
		webFull:'Web fullscreen',
		exitWebFull:'Non-Web fullscreen',
		theatre:'Theatre',
		exitTheatre:'Non-theatre',
		volume:'Volume：',
		muted:'Mute',
		exitmuted:'Unmute',
		seek:'Seek：',
		waiting:'Waiting',
		live:'Liveing',
		backLive:'Back live',
		lookBack:'Look back：',
		next:'Next episode',
		screenshot:'Screenshot',
		smallwindows:'Small windows',
		playbackrate:'Speed',
		playbackrateSuffix:' Speed',
		track:'Subtitle',
		noTrack:'No subtitle',
		definition:'Definition',
		switchTo:'Switched from：',
		closeTime:'The advertisement can be closed in {seconds} seconds',
		closeAd:'Close ad',
		second:'seconds',
		details:'View details',
		copy:'Copy',
		copySucceeded:'Copy succeeded, can be pasted!',
		smallwindowsOpen:'The small window function is turned on',
		screenshotStart:'Screenshot, please wait...',
		smallwindowsClose:'The small window function is turned off',
		screenshotClose:'Screenshot function is turned off',
		loopOpen:'Loop open',
		loopClose:'Loop close',
		close:'Close',
		down:'Down',
		p50:'50%',
		p75:'75%',
		p100:'100%',
		timeScheduleAdjust:{
			prohibit:'No dragging',
			prohibitBackOff:'No repeat viewing',
			prohibitForward:'Fast forward prohibited',
			prohibitLookBack:'Some content is forbidden to play',
			prohibitForwardNotViewed:'Disable playback of parts not viewed'
		},
		error:{
			noMessage:'Unknown error',
			supportVideoError:'The browser version is too low. It is recommended to replace it with another browser',
			videoTypeError:'This browser does not support playing this video. It is recommended to replace it with another browser',
			loadingFailed:'Loading failed',
			emptied:'An error occurred while loading the frequency file',
			screenshot:'Screenshot failed',
			ajax:'Ajax data request error',
			noVideoContainer:'No video container'
		}
	};
	return language;
}))