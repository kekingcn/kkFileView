<!DOCTYPE html>

<html lang="en">
<head>
<title>${file.name}文件预览</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <#include "*/commonHeader.ftl">
	     <script src="js/base64.min.js" type="text/javascript"></script>
   <script src="epub/epub.js"></script>
   <script src="js/jszip.min.js"></script>
  <link rel="stylesheet" type="text/css" href="epub/examples.css">
</head>
	<#if currentUrl?contains("http://") || currentUrl?contains("https://") || currentUrl?contains("file://")>
    <#assign finalUrl="${currentUrl}">
  <#elseif currentUrl?contains("ftp://") >
   <#assign finalUrl="${currentUrl}">
<#else>
    <#assign finalUrl="${baseUrl}${currentUrl}">
</#if>
<body>
  <select id="toc"></select>
  <div id="viewer" class="scrolled"></div>
  <div id="prev" class="arrow">‹</div>
  <div id="next" class="arrow">›</div>
</body>
<script type="text/javascript">
    var url = '${finalUrl}';
    var baseUrl = '${baseUrl}'.endsWith('/') ? '${baseUrl}' : '${baseUrl}' + '/';
    if (!url.startsWith(baseUrl)) {
         url = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(url));
    }
  var currentSectionIndex = 100;
    // Load the opf
    var book = ePub(url);
    //var rendition = book.renderTo("viewer", { flow: "scrolled-doc" });
    var rendition = book.renderTo("viewer", {
      flow: "scrolled-doc",
      width: "100%"
     // height: 600
    });
    var params = URLSearchParams && new URLSearchParams(document.location.search.substring(1));
    var currentSectionIndex = (params && params.get("loc")) ? params.get("loc") : undefined;
    rendition.display(currentSectionIndex);
    var next = document.getElementById("next");
    next.addEventListener("click", function(e){
      rendition.next();
      e.preventDefault();
    }, false);

    var prev = document.getElementById("prev");
    prev.addEventListener("click", function(e){
      rendition.prev();
      e.preventDefault();
    }, false);

    rendition.on("rendered", function(section){
      var nextSection = section.next();
      var prevSection = section.prev();

      if(nextSection) {
        nextNav = book.navigation.get(nextSection.href);

        if(nextNav) {
          nextLabel = nextNav.label;
        } else {
          nextLabel = "next";
        }

        next.textContent = " »";
      } else {
        next.textContent = "";
      }
      if(prevSection) {
        prevNav = book.navigation.get(prevSection.href);

        if(prevNav) {
          prevLabel = prevNav.label;
        } else {
          prevLabel = "previous";
        }
        prev.textContent = "« " ;
      } else {
        prev.textContent = "";
      }
    });
	
	 rendition.on("rendered", function(section){
      var current = book.navigation && book.navigation.get(section.href);

      if (current) {
        var $select = document.getElementById("toc");
        var $selected = $select.querySelector("option[selected]");
        if ($selected) {
          $selected.removeAttribute("selected");
        }

        var $options = $select.querySelectorAll("option");
        for (var i = 0; i < $options.length; ++i) {
          let selected = $options[i].getAttribute("ref") === current.href;
          if (selected) {
            $options[i].setAttribute("selected", "");
          }
        }
      }

    });
	  book.loaded.navigation.then(function(toc){
			var $select = document.getElementById("toc"),
					docfrag = document.createDocumentFragment();

			toc.forEach(function(chapter) {
				var option = document.createElement("option");
				option.textContent = chapter.label;
				option.setAttribute("ref", chapter.href);

				docfrag.appendChild(option);
			});

			$select.appendChild(docfrag);

			$select.onchange = function(){
					var index = $select.selectedIndex,
							url = $select.options[index].getAttribute("ref");
					rendition.display(url);
					return false;
			};

		});

  		 /*初始化水印*/
 if (!!window.ActiveXObject || "ActiveXObject" in window)
{
}else{
 initWaterMark();
}
</script>
</html>