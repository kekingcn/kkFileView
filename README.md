# file-online-preview
此项目为文件文档在线预览项目解决方案，对标业内付费产品有【[永中office](http://dcs.yozosoft.com/)】【[office365](http://www.officeweb365.com/)】【[idocv](https://www.idocv.com/)】等，在取得公司高层同意后以Apache协议开源出来反哺社区，在此特别感谢@唐老大的支持以及@端木详笑的贡献。该项目使用流行的spring boot搭建，易上手和部署，基本支持主流办公文档的在线预览，如doc,docx,Excel,pdf,txt,zip,rar,图片等等
### 在线体验
> 请善待公共服务，会不定时停用

地址：http://58.246.254.194:8012/

### 联系我们，加入组织
> 我们会用心回答解决大家在项目使用中的问题，也请大家在提问前至少Google或baidu过，珍爱生命远离无效的交流沟通

![输入图片说明](https://gitee.com/uploads/images/2017/1219/173717_934cb068_492218.png "屏幕截图.png")
QQ群号：613025121

### 文档预览效果
> Excel预览效果

![输入图片说明](https://gitee.com/uploads/images/2017/1213/093051_cd55b3ec_492218.png "屏幕截图.png")
> doc预览效果

![输入图片说明](https://gitee.com/uploads/images/2017/1213/092350_5b2ecbe5_492218.png "屏幕截图.png")

> zip,rar压缩预览效果

![输入图片说明](https://gitee.com/uploads/images/2017/1213/093806_46cede06_492218.png "屏幕截图.png")

> png,jpeg,jpg等图片预览效果，支持滚轮缩放，旋转，倒置等

![输入图片说明](https://gitee.com/uploads/images/2017/1213/094335_657a6f60_492218.png "屏幕截图.png")
考虑说明篇幅原因，就不贴其他格式文件的预览效果了，感兴趣的可以参考下面的实例搭建下

### 快速开始
> 项目使用技术
- spring boot： [spring boot开发参考指南](http://www.kailing.pub/PdfReader/web/viewer.html?file=springboot)
- freemarker
- redisson 
- jodconverter
> 依赖外部环境
- redis 
- OpenOffice或者LibreOffice

1. 第一步：pull项目https://github.com/kekingcn/file-online-preview.git

2. 第二步：配置redis地址和OpenOffice目录，如
```
server.port = 8012
spring.http.encoding.charset = utf8
## Freemarker 配置
spring.freemarker.template-loader-path = classpath:/web/
spring.freemarker.cache = false
spring.freemarker.charset = UTF-8
spring.freemarker.check-template-location = true
spring.freemarker.content-type = text/html
spring.freemarker.expose-request-attributes = true
spring.freemarker.expose-session-attributes = true
spring.freemarker.request-context-attribute = request
spring.freemarker.suffix = .ftl
#=============================================#spring Redisson配置#===================================#
spring.redisson.address = 192.168.1.204:6379
##资源映射路径(因为jar方式运行的原因)
file.dir = C:\\Users\\yudian\\Desktop\\dev\\
spring.resources.static-locations = classpath:/META-INF/resources/,classpath:/resources/,classpath:/static/,classpath:/public/,file:${file.dir}
## openoffice相关配置
openOfficePath = /Applications/OpenOffice.app/Contents
office.home = C:\\Program Files (x86)\\OpenOffice 4
server.tomcat.uri-encoding = UTF-8
converted.file.charset = GBK
#======================================#文件上传限制#======================================#
spring.http.multipart.max-file-size=100MB
```
file.dir为转换文件实际存储地址，注意要以/结尾

3. 第三步：运行FilePreviewApplication的main方法，服务启动后，访问http://localhost:8012/
会看到如下界面，代表服务启动成功
![输入图片说明](https://gitee.com/uploads/images/2017/1213/100221_ea15202e_492218.png "屏幕截图.png")
### 使用登记
如果这个项目解决了你的实际问题，可在https://gitee.com/kekingcn/file-online-preview/issues/IGSBV
登记下，如果节省了你的三方预览服务费用，也愿意支持下的话，可点击下方【捐助】请作者喝杯咖啡，也是非常感谢
