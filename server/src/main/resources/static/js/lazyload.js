function isInSight(el) {
    var bound = el.getBoundingClientRect();
    var clientHeight = window.innerHeight;
    //只考虑向下滚动加载
    //const clientWidth=window.innerWeight;
    return bound.top <= clientHeight + 100;
}

var index = 0;

function checkImgs() {
    var imgs = document.querySelectorAll('.my-photo');
    for (var i = index; i < imgs.length; i++) {
        if (isInSight(imgs[i])) {
            loadImg(imgs[i]);
            index = i;
        }
    }
}

function loadImg(el) {
    var source = el.getAttribute("data-src");
    el.src = source;

}
// var mustRun = 500
// function throttle(fn, mustRun) {
//     var timer = null;
//     var previous = null;
//     return function() {
//         var now = new Date();
//         var context = this;
//         var args = arguments;
//         if (!previous) {
//             previous = now;
//         }
//         var remaining = now - previous;
//         if (mustRun && remaining >= mustRun) {
//             fn.apply(context, args);
//             previous = now;
//         }
//     }
// }


function throttle(fn) {
    var timer = null;
    var previous = null;
    return function () {
        var now = new Date();
        var context = this;
        var args = arguments;
        if (!previous) {
            previous = now;
        }
        var remaining = now - previous;
        setTimeout(refresh(fn, remaining, context, args, previous, now));
    }
}

function refresh(fn, remaining, context, args, previous, now) {
    if (remaining >= 500) {
        fn.apply(context, args);
        previous = now;
    }
}
