<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>普通文本预览</title>
    <style>
        * {
            margin: 0;
            padding: 0;
        }
        html, body {
            height: 100%;
            width: 100%;
        }
        body { 
      padding: 5px;
      margin: 5px;
    }
    .string {
      color: green;
    }
    .number {
      color: darkorange;
    }
    .boolean {
      color: blue;
    }
    .null {
      color: magenta;
    }
    .key {
      color: red;
    }
    </style>
</head>
<body>
<div id = "text"><pre></pre></div>
<script src="js/jquery-3.0.0.min.js" type="text/javascript"></script>
<script src="js/watermark.js" type="text/javascript"></script>
<script>
    /*初始化水印*/
    window.onload = function() {
        var watermarkTxt = '${watermarkTxt}';
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
                watermark_color:'${watermarkColor}',
                watermark_alpha: ${watermarkAlpha},
                watermark_width: ${watermarkWidth},
                watermark_height: ${watermarkHeight},
                watermark_angle: ${watermarkAngle},
            });
        }
        $.ajax({
            type: 'GET',
            url: '${ordinaryUrl}',
            success: function (data) {
                if (isJson(data)) {
                    data = syntaxHighlight(data);
                    $("#text").html("<pre>" + data + "</pre>");
                    return;
                } else if (isXml(data)) {
                    data = XMLtoString(data);
                }

                //$("#text").html("<pre>" + data + "</pre>");
                $("#text pre").text(data);
            }
        });
    }

    //判断是否是json
  function isJson(obj) {
    var isjson =
      typeof obj == "object" &&
      Object.prototype.toString.call(obj).toLowerCase() == "[object object]" &&
      !obj.length;
    return isjson;
  }

    //判断是否是xml
  function isXml(obj) {
    var isxml =
      typeof obj == "object" &&
      Object.prototype.toString.call(obj).toLowerCase() ==
        "[object xmldocument]" &&
      !obj.length;
    return isxml;
  }

    //xml内容转为字符串
  function XMLtoString(xmlObject) {
    var serialized;
    try {
      // XMLSerializer exists in current Mozilla browsers
      serializer = new XMLSerializer();
      serialized = serializer.serializeToString(xmlObject);
    } catch (e) {
      // Internet Explorer has a different approach to serializing XML
      serialized = xmlObject.xml;
    }
    return serialized;
  }

    //html标签转为实体
  function HTMLEnCode(str) {
    var s = "";
    if (str.length == 0) return "";
    s = str.replace(/&/g, "&gt;");
    s = s.replace(/</g, "&lt;");
    s = s.replace(/>/g, "&gt;");
    s = s.replace(/  /g, "&nbsp;");
    s = s.replace(/\'/g, "'");
    s = s.replace(/\"/g, "&quot;");
    s = s.replace(/\n/g, " <br>");
    return s;
  }

    //json添加样式
  function syntaxHighlight(json) {
    if (typeof json != "string") {
      json = JSON.stringify(json, undefined, 2);
    }
    json = json
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
    return json.replace(
      /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g,
      function (match) {
        var cls = "number";
        if (/^"/.test(match)) {
          if (/:$/.test(match)) {
            cls = "key";
          } else {
            cls = "string";
          }
        } else if (/true|false/.test(match)) {
          cls = "boolean";
        } else if (/null/.test(match)) {
          cls = "null";
        }
        return '<span class="' + cls + '">' + match + "</span>";
      }
    );
  }

</script>
</body>

</html>
