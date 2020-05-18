# file-online-preview

[![GitHub license](https://img.shields.io/github/license/kekingcn/kkFileView.svg?style=flat-square)](https://github.com/kekingcn/kkFileView/blob/master/LICENSE)

### Introduction

This kekingcn kkFileView project is intended to be a solution for previewing documents online. At present,there are some similar paid products in the industry.
Such as 【[永中office](http://dcs.yozosoft.com/)】,【[office365](http://www.officeweb365.com/)】,【[idocv](https://www.idocv.com/)】, etc...
It is an open source implementation and released under the Apache License version 2.0. Finally,It is aimed to feedback the community after obtaining the consent of company executives, 
special thanks to the supports of @唐老大 and the contributions of @端木详笑. 

### Features
- Build with the popular frame spring boot
- Easy to build and deploy
- Basically support online preview of mainstream office documents, such as Doc, docx, Excel, PDF, TXT, zip, rar, pictures, etc
- REST API
- Abstract file preview interface so that it is easy to extend more file extensions and develop this project on your own

### Official website and DOCS

URL：[https://kkfileview.keking.cn](https://kkfileview.keking.cn)

### Live demo
> Please treat public service kindly, or this would stop at any time.

URL：[https://file.keking.cn](https://file.keking.cn)

### Documentation
1. 中文文档：https://gitee.com/kekingcn/file-online-preview/blob/master/README.md
1. English document：https://github.com/kekingcn/kkFileView/blob/master/README.en.md

### Contact us && Join us
> We will answer everyone's questions in use of this project.
And please Google or Baidu first before asking a question, so that we can solve it efficiently. 
Cherish life away from ineffective communication.

![输入图片说明](https://gitee.com/uploads/images/2017/1219/173717_934cb068_492218.png "屏幕截图.png")
QQ group：613025121

### Pictures for some samples
> Excel

![输入图片说明](https://gitee.com/uploads/images/2017/1213/093051_cd55b3ec_492218.png "屏幕截图.png")
> doc

![输入图片说明](https://gitee.com/uploads/images/2017/1213/092350_5b2ecbe5_492218.png "屏幕截图.png")

> zip,rar

![输入图片说明](https://gitee.com/uploads/images/2017/1213/093806_46cede06_492218.png "屏幕截图.png")

> png,jpeg,jpg,etc., support for zooming with mouse scroll, rotation, inversion,etc.

![输入图片说明](https://gitee.com/uploads/images/2017/1213/094335_657a6f60_492218.png "屏幕截图.png")
Considering space issues, the pictures of other types of documents will not be shown here.You can deploy it by yourself if you are interested in our project.There is a way to deploy it as below.

### Quick Start
> Technology stack
- Spring boot： [spring boot Development Reference Guide](http://www.kailing.pub/PdfReader/web/viewer.html?file=springboot)
- Freemarker
- Redisson 
- Jodconverter
> Dependencies
- Redis(Optional, Unnecessary by default)
- OpenOffice or LibreOffice(Integrated on Windows, will be installed automatically on Linux, need to be manually installed on Mac OS)

1. First step：`git pull https://github.com/kekingcn/file-online-preview.git`

2. Third step：Run the main method of FilePreviewApplication.java.After starting,visit `http://localhost:8012/`.
If everything is ok,you will see the picture below.
![输入图片说明](https://gitee.com/uploads/images/2017/1213/100221_ea15202e_492218.png "屏幕截图.png")

### Changelog
> May 20th 2020 ：
1. Support for global watermark and dynamic change of watermark content through parameters
2. Support for CAD file Preview
3. Add configuration item base.url, support using nginx reverse proxy and set context-path
4. All configuration items can be read from environment variables, which is convenient for docker image deployment and large-scale use in cluster
5. Support the configuration of TrustHost  (only the file source from the trust site can be previewed), and protect the preview service from abuse
6. Support configuration of customize cache cleanup time (cron expression)
7. All recognizable plain text can be previewed directly without downloading, such as .md .java .py, etc
8. Support configuration to limit PDF file download after conversion
9. Optimize Maven packaging configuration to solve the problem of line break in .sh script
10. Place all CDN dependencies on the front end locally for users without external network connection
11. Comment Service on home page switched from Sohu ChangYan to gitalk
12. Fixed preview exceptions that may be caused by special characters in the URL
13. Fixed the addtask exception of the transformation file queue
14. Fixed other known issues
15. Official website build: [https://kkfileview.keking.cn](https://kkfileview.keking.cn)
16. Official docker image repository build: [https://hub.docker.com/r/keking/kkfileview](https://hub.docker.com/r/keking/kkfileview)

> June 18th 2019 ：
1. Support automatic cleaning of cache and preview files
2. Support http/https stream url file preview
3. Support FTP url file preview
4. Add Docker build

> April 8th 2019
1. Cache and queue implementations abstract, providing JDK and REDIS implementations (REDIS becomes optional dependencies)
2. Provides zip and tar.gz packages, and provides a one-click startup script

> January 17th 2018

1. Refined the project directory, abstract file preview interface, Easy to extend more file extensions and depoly this project on your own
1. Added English documentation (@幻幻Fate，@汝辉) contribution
1. Support for more image file extensions
1. Fixed the issue that image carousel in zip file will always start from the first

> January 12th 2018

1. Support for multiple images preview 
1. Support for images rotation preview in rar/zip

> January 2nd 2018

1. Fixed gibberish issue when preview a txt document caused by the file encoding problem 
1. Fixed the issue that some module dependencies can not be found
1. Add a spring boot profile, and support for Multi-environment configuration 
1. Add `pdf.js` to preview the documents such as doc,etc.,support for generating doc headlines as pdf menu，support for mobile preview

### Register Usage
If this project is helpful for you, please register on 'https://gitee.com/kekingcn/file-online-preview/issues/IGSBV',
If this project helps you to economize the service charge for preview of documents, as well as you are willing to support us, click 【donate】 below to donate a cup of coffee, we would appreciate it.
