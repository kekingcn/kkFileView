(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global = global || self, global.ckplayerLanguage = factory());
}(this, function () { 'use strict';
	/*
	 *功能：包含播放機用到的全部相關語言文字
	 */
	var language = {
		play: '播放',
		pause: '暫停',
		refresh: '重播',
		full: '全屏',
		exitFull: '退出全屏',
		webFull: '頁面全屏',
		exitWebFull: '退出頁面全屏',
		theatre: '劇場模式',
		exitTheatre: '退出劇場模式',
		volume: '音量：',
		muted: '靜音',
		exitmuted: '恢復音量',
		seek: 'seek:',
		waiting: '緩衝',
		live: '直播中',
		backLive: '返回直播',
		lookBack: '回看：',
		next: '下一集',
		screenshot: '視頻截圖',
		smallwindows: '小視窗播放功能',
		playbackrate: '倍速',
		playbackrateSuffix: '倍',
		track: '字幕',
		noTrack: '無字幕',
		definition: '清晰度',
		switchTo: '切換成：',
		closeTime: '{seconds}秒後可關閉廣告',
		closeAd: '關閉廣告',
		second: '秒',
		details: '查看詳情',
		copy: '複製',
		copySucceeded: '複製成功,可貼粘！',
		smallwindowsOpen: '小視窗功能已開啟',
		smallwindowsClose: '小視窗功能已關閉',
		screenshotStart: '截圖中,請稍候…',
		screenshotClose: '截圖功能已關閉',
		loopOpen: '迴圈播放',
		loopClose: '已關閉迴圈播放',
		close: '關閉',
		down: '下載',
		p50: '50%',
		p75: '75%',
		p100: '100%',
		timeScheduleAdjust: {
			prohibit: '視頻禁止拖動',
			prohibitBackOff: '視頻禁止重複觀看',
			prohibitForward: '視頻禁止快進',
			prohibitLookBack: '視頻禁止播放部分內容',
			prohibitForwardNotViewed: '視頻禁止播放未觀看的部分'
		},
		error: {
			noMessage: '未知錯誤',
			supportVideoError: '該流覽器版本太低,建議更換成其它瀏覽器',
			videoTypeError: '該瀏覽器不支持播放該視頻,建議更換成其它瀏覽器',
			loadingFailed: '加載失敗',
			emptied: '視頻檔案加載過程中出現錯誤',
			screenshot: '視頻截圖失敗',
			ajax: 'Ajax數據請求錯誤',
			noVideoContainer: '未找到放置視頻的容器'
		}
	};
	return language;
}))