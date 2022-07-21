<#setting classic_compatible=true>
<link rel="icon" href="./favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
<script src="js/jquery-3.0.0.min.js" type="text/javascript"></script>
<script src="js/jquery.form.min.js" type="text/javascript"></script>
<script src="bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script src="js/bootbox.min.js" type="text/javascript"></script>
<script src="js/watermark.js" type="text/javascript"></script>
<script src="js/base64.min.js" type="text/javascript"></script>

<script>
    /**
     * 初始化水印
     */
    function initWaterMark() {
        let watermarkTxt = '${watermarkTxt}';
        if (watermarkTxt !== '') {
            watermark.init({
                watermark_txt: '${watermarkTxt}',
                watermark_x: 0,
                watermark_y: 0,
                watermark_rows: 0,
                watermark_cols: 0,
                watermark_x_space: ${watermarkXSpace},
                watermark_y_space: ${watermarkYSpace},
                watermark_font: '${watermarkFont}',
                watermark_fontsize: '${watermarkFontsize}',
                watermark_color: '${watermarkColor}',
                watermark_alpha: ${watermarkAlpha},
                watermark_width: ${watermarkWidth},
                watermark_height: ${watermarkHeight},
                watermark_angle: ${watermarkAngle},
            });
        }
    }

    // 中文环境
    var locale_zh_CN = {
        OK: '确定',
        CONFIRM: '确认',
        CANCEL: '取消'
    };
    bootbox.addLocale('locale_zh_CN', locale_zh_CN);

    /**
     * 需要文件密码
     */
    function needFilePassword() {
        if ('${needFilePassword}' == 'true') {
            let promptTitle = "你正在预览加密文件，请输入文件密码。";
            if ('${filePasswordError}' == 'true') {
                promptTitle = "密码错误，请重新输入密码。";
            }

            bootbox.prompt({
                title: promptTitle,
                inputType: 'password',
                centerVertical: true,
                locale: 'locale_zh_CN',
                callback: function (filePassword) {
                    if (filePassword != null) {
                        const locationHref = window.location.href;
                        const isInclude = locationHref.includes("filePassword=");
                        let redirectUrl = null;
                        if (isInclude) {
                            const url = new URL(locationHref);
                            url.searchParams.set("filePassword", filePassword);
                            redirectUrl = url.href;
                        } else {
                            redirectUrl = locationHref + '&filePassword=' + filePassword;
                        }

                        window.location.replace(redirectUrl);
                    } else {
                        location.reload();
                    }
                }
            });
        }
    }
</script>

<style>
    * {
        margin: 0;
        padding: 0;
    }

    html, body {
        height: 100%;
        width: 100%;
    }
</style>
