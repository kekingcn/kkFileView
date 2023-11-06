
// Features specially written for demo

(function() {

    // language
    function language(params) {
        
        var lang = navigator.language||navigator.userLanguage;//常规浏览器语言和IE浏览器
        lang = lang.substr(0, 2);//截取lang前2位字符

        return lang;

    }

    /**
     * Get url parameters
     */
    function getRequest() {
        var vars = {};
        var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi,    
        function(m,key,value) {
          vars[key] = value;
        });
        
        return vars;
    }

    window.luckysheetDemoUtil = {
        language:language,
        getRequest:getRequest
    }
    
})()