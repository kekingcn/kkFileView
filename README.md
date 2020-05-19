# file-online-preview
此项目为文件文档在线预览项目解决方案，对标业内付费产品有【[永中office](http://dcs.yozosoft.com/)】【[office365](http://www.officeweb365.com/)】【[idocv](https://www.idocv.com/)】等，在取得公司高层同意后以Apache协议开源出来反哺社区，在此特别感谢@唐老大的支持以及@端木详笑的贡献。该项目使用流行的spring boot搭建，易上手和部署，基本支持主流办公文档的在线预览，如doc,docx,Excel,pdf,txt,zip,rar,图片等等
### 项目特性

1. 支持office，pdf, cad等办公文档
1. 支持txt,java,php,py,md,js,css等所有纯文本
1. 支持zip,rar,jar,tar,gzip等压缩包
1. 支持jpg，jpeg，png，gif等图片预览（翻转，缩放，镜像）
1. 使用spring boot开发，预览服务搭建部署非常简便
1. rest接口提供服务，跨平台特性(java,php,python,go,php，....)都支持，应用接入简单方便
1. 抽象预览服务接口，方便二次开发，非常方便添加其他类型文件预览支持
1. 最最重要Apache协议开源，代码pull下来想干嘛就干嘛

### 官网及文档

地址：[https://kkfileview.keking.cn](https://kkfileview.keking.cn)

### 在线体验
> 请善待公共服务，会不定时停用

地址：[https://file.keking.cn](https://file.keking.cn)

### 项目文档（Project documentation）
1. 详细wiki文档：https://gitee.com/kekingcn/file-online-preview/wikis/pages
1. 中文文档：https://gitee.com/kekingcn/file-online-preview/blob/master/README.md
1. English document：https://gitee.com/kekingcn/file-online-preview/blob/master/README.en.md

### 联系我们，加入组织
> 我们会用心回答解决大家在项目使用中的问题，也请大家在提问前至少Google或baidu过，珍爱生命远离无效的交流沟通

![输入图片说明](https://gitee.com/uploads/images/2017/1219/173717_934cb068_492218.png "屏幕截图.png")
QQ群号：613025121

### 文档预览效果
#### 1. 文本预览
支持所有类型的文本文档预览， 由于文本文档类型过多，无法全部枚举，默认开启的类型如下 txt,html,htm,asp,jsp,xml,json,properties,md,gitignore,log,java,py,c,cpp,sql,sh,bat,m,bas,prg,cmd  
文本预览效果如下  
![文本预览效果如下](https://kkfileview.keking.cn/img/preview/preview-text.png)      

#### 2. 图片预览
支持jpg，jpeg，png，gif等图片预览（翻转，缩放，镜像），预览效果如下  
![图片预览](https://kkfileview.keking.cn/img/preview/preview-image.png)  

#### 3. word文档预览
支持doc，docx文档预览，word预览有两种模式：一种是每页word转为图片预览，另一种是整个word文档转成pdf，再预览pdf。两种模式的适用场景如下  
* 图片预览：word文件大，前台加载整个pdf过慢
* pdf预览：内网访问，加载pdf快
图片预览模式预览效果如下  
![word文档预览1](https://kkfileview.keking.cn/img/preview/preview-doc-image.png)  
pdf预览模式预览效果如下  
![word文档预览2](https://kkfileview.keking.cn/img/preview/preview-doc-pdf.png)  

#### 4. ppt文档预览
支持ppt，pptx文档预览，和word文档一样，有两种预览模式  
图片预览模式预览效果如下  
![ppt文档预览1](https://kkfileview.keking.cn/img/preview/preview-ppt-image.png)  
pdf预览模式预览效果如下  
![ppt文档预览2](https://kkfileview.keking.cn/img/preview/preview-ppt-pdf.png)  

#### 5. pdf文档预览
支持pdf文档预览，和word文档一样，有两种预览模式   
图片预览模式预览效果如下  
![pdf文档预览1](https://kkfileview.keking.cn/img/preview/preview-pdf-image.png)  
pdf预览模式预览效果如下   
![pdf文档预览2](https://kkfileview.keking.cn/img/preview/preview-pdf-pdf.png)    

#### 6. excel文档预览
支持xls，xlsx文档预览，预览效果如下  
![excel文档预览](https://kkfileview.keking.cn/img/preview/preview-xls.png)  

#### 7. 压缩文件预览
支持zip,rar,jar,tar,gzip等压缩包，预览效果如下  
![压缩文件预览1](https://kkfileview.keking.cn/img/preview/preview-zip.png)  
可点击压缩包中的文件名，直接预览文件，预览效果如下  
![压缩文件预览2](https://kkfileview.keking.cn/img/preview/preview-zip-inner.png)  

#### 8. 多媒体文件预览
理论上支持所有的视频、音频文件，由于无法枚举所有文件格式，默认开启的类型如下  
mp3,wav,mp4,flv  
视频预览效果如下  
![多媒体文件预览1](https://kkfileview.keking.cn/img/preview/preview-video.png)  
音频预览效果如下  
![多媒体文件预览2](https://kkfileview.keking.cn/img/preview/preview-audio.png)  

#### 9. CAD文档预览
支持CAD dwg文档预览，和word文档一样，有两种预览模式  
图片预览模式预览效果如下  
![cad文档预览1](https://kkfileview.keking.cn/img/preview/preview-cad-image.png)  
pdf预览模式预览效果如下  
![cad文档预览2](https://kkfileview.keking.cn/img/preview/preview-cad-pdf.png)  
考虑说明篇幅原因，就不贴其他格式文件的预览效果了，感兴趣的可以参考下面的实例搭建下

### 快速开始
> 项目使用技术
- spring boot： [spring boot开发参考指南](http://www.kailing.pub/PdfReader/web/viewer.html?file=springboot)
- freemarker
- redisson 
- jodconverter
> 依赖外部环境
- redis (可选，默认不用)
- OpenOffice或者LibreOffice(Windows下已内置，Linux会自动安装，Mac OS下需要手动安装)

1. 第一步：pull项目https://github.com/kekingcn/file-online-preview.git

3. 第二步：运行FilePreviewApplication的main方法，服务启动后，访问http://localhost:8012/
会看到如下界面，代表服务启动成功
![输入图片说明](https://gitee.com/uploads/images/2017/1213/100221_ea15202e_492218.png "屏幕截图.png")

### 历史更新记录

> 2020年05月20日 ：
1. 新增支持全局水印，并支持通过参数动态改变水印内容
2. 新增支持CAD文件预览
3. 新增base.url配置，支持使用nginx反向代理和使用context-path
4. 支持所有配置项支持从环境变量里读取，方便Docker镜像部署和集群中大规模使用
5. 支持配置限信任站点（只能预览来自信任点的文件源），保护预览服务不被滥用
6. 支持配置自定义缓存清理时间（cron表达式）
7. 全部能识别的纯文本直接预览，不用再转跳下载，如.md .java .py等
8. 支持配置限制转换后的PDF文件下载
9. 优化maven打包配置，解决 .sh 脚本可能出现换行符问题
10. 将前端所有CDN依赖放到本地，方便没有外网连接的用户使用
11. 首页评论服务由搜狐畅言切换到Gitalk
12. 修复url中包含特殊字符可能会引起的预览异常
13. 修复转换文件队列addTask异常
14. 修复其他已经问题
15. 官网建设：[https://kkfileview.keking.cn](https://kkfileview.keking.cn)
16. 官方Docker镜像仓库建设：[https://hub.docker.com/r/keking/kkfileview](https://hub.docker.com/r/keking/kkfileview)

> 2019年06月18日 ：
1. 支持自动清理缓存及预览文件
2. 支持http/https下载流url文件预览
3. 支持FTP url文件预览
4. 加入Docker构建

> 2019年04月08日 ：
1. 缓存及队列实现抽象，提供JDK和REDIS两种实现(REDIS成为可选依赖)
2. 打包方式提供zip和tar.gz包，并提供一键启动脚本

> 2018年01月19日 ：

1. 大文件入队提前处理
1. 新增addTask文件转换入队接口 
1. 采用redis队列，支持kkFIleView接口和异构系统入队两种方式

> 2018年01月17日 ：

1. 优化项目结构，抽象文件预览接口，更方便的加入更多的文件类型预览支持，方便二次开发
1. 新增英文文档说明（@幻幻Fate，@汝辉）贡献
1. 新增图片预览文件支持类型
1. 修复压缩包内轮播图片总是从第一张开始的问题

> 2018年01月12日 ：

1. 新增多图片同时预览 
1. 支持压缩包内图片轮番预览

> 2018年01月02日 ： 

1. 修复txt等文本编码问题导致预览乱码 
1. 修复项目模块依赖引入不到的问题 
1. 新增spring boot profile，支持多环境配置 
1. 引入pdf.js预览doc等文件，支持doc标题生成pdf预览菜单，支持手机端预览

### 使用登记
如果这个项目解决了你的实际问题，可在https://gitee.com/kekingcn/file-online-preview/issues/IGSBV
登记下，如果节省了你的三方预览服务费用，也愿意支持下的话，可点击下方【捐助】请作者喝杯咖啡，也是非常感谢
