function isInSight(el, i) {
  var bound = el.getBoundingClientRect()
  var clientHeight = window.innerHeight
  //只考虑向下滚动加载
  //const clientWidth=window.innerWeight;
  return bound.top + bound.height >= 0 && bound.top <= clientHeight + 100
}

function checkImgs() {
  var index = 0
  var imgs = document.querySelectorAll('.my-photo')
  for (var i = index; i < imgs.length; i++) {
    if (isInSight(imgs[i], i)) {
      loadImg(imgs[i])
      index = i
    }
  }
}

function loadImg(el) {
  var source = el.getAttribute('data-src')
  el.src = source
}

// 滚动停止检测相关变量
var scrollTimer = null
var isScrolling = false

/**
 * 滚动停止检测函数
 * 滚动停止500毫秒后执行图片加载
 */
function onScrollStop() {
  isScrolling = false
  // console.log('滚动停止，开始加载图片')
  checkImgs()
}

/**
 * 滚动事件处理函数
 * 设置滚动状态，并延迟执行图片加载
 */
function handleScroll() {
  isScrolling = true

  // 清除之前的定时器
  if (scrollTimer) {
    clearTimeout(scrollTimer)
  }

  // 滚动停止500毫秒后执行图片加载
  scrollTimer = setTimeout(function () {
    if (isScrolling) {
      onScrollStop()
    }
  }, 500)
}

// 监听滚动事件
window.addEventListener('scroll', handleScroll)

// 监听窗口大小变化事件
window.addEventListener('resize', handleScroll)

// 页面加载完成后执行一次检查
document.addEventListener('DOMContentLoaded', function () {
  setTimeout(checkImgs, 100)
})
