# file-online-preview
This project is a solution for preview of some documents.There are some similar paid products, such as 【[永中office](http://dcs.yozosoft.com/)】【[office365](http://www.officeweb365.com/)】【[idocv](https://www.idocv.com/)】,etc..After achieving the agreement of our senior management,we decide to open source to feedback with Apache License. And we specially thanks for the contributions and helps of @唐老大 and @端木详笑.
This project is built with Spring Boot which is popular.It's easy to use and deploy.It supports the preview of mainstream office documents, such as doc,docx,Excel,pdf,txt,zip,rar,pictures,etc.
### The demo online
> Please be nice to the public service, or this would stop at any time.

URL：http://file.keking.cn/

### Contact us & Join us
> We will answer everyone's questions which are found when running this project patiently.And please Google or Baidu first before asking a question, so that we can solve then efficiently.

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
In consideration of the length of the introduction, the pictures of other file type will not be shown.You can deploy it yourself if you are interested in our project.The way to deploy is as below.

### Quick Start
> The technologies of this project.
- spring boot： [spring boot开发参考指南](http://www.kailing.pub/PdfReader/web/viewer.html?file=springboot)
- freemarker
- redisson 
- jodconverter
> Dependent on external environment
- redis 
- OpenOffice or LibreOffice

1. First step：pull https://github.com/kekingcn/file-online-preview.git

2. Second step：configurate redis address and OpenOffice endpoint，such as
```
#=============================================#Spring Redisson Configuration#===================================#
spring.redisson.address = 192.168.1.204:6379
##The folder for files which are uploaded to the server(Because of running as jar)
file.dir = C:\\Users\\yudian\\Desktop\\dev\\
## openoffice configuration
office.home = C:\\Program Files (x86)\\OpenOffice 4

```
'file.dir' is the real storage addres, please end with '/'.

3. Third step：Run the main method of FilePreviewApplication.java.After starting,visit 'http://localhost:8012/'.
If everything is ok,you will see picture below.
![输入图片说明](https://gitee.com/uploads/images/2017/1213/100221_ea15202e_492218.png "屏幕截图.png")

### System Update History

> 2018年01月12日 ：

1. Support for multiple images preview 
1. Support for images preview in rar/zip

> 2018年01月02日 ： 

1. fixed gibberish issue when preview a txt document caused by the file encoding problem 
1. fixed the issue that some module dependencies can not be found
1. add a spring boot profile, and support for Multi-environment configuration 
1. add 'pdf.js' to preview the documents such as doc,etc.,support for generating doc headlines as pdf menu，support for mobile preview

### Register Usage
If this project is helpful for you, please register on 'https://gitee.com/kekingcn/file-online-preview/issues/IGSBV',
If this project helps you to economize the service charge for preview of ducuments, as well as you are willing to support us, click 【donate】 below to donate a cup of coffee, we will be so appreciate that.
