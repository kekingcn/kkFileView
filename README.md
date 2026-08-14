# kkFileView

### Introduction

Document online preview project solution, built using the popular Spring Boot framework for easy setup and deployment. This versatile open source project provides basic support for a wide range of document formats, including:

1. Supports Office documents such as `doc`, `docx`, `xls`, `xlsx`, `xlsm`, `ppt`, `pptx`, `csv`, `tsv`, , `dotm`, `xlt`, `xltm`, `dot`, `xlam`, `dotx`, `xla,` ,`pages` ,`pptm` etc.
2. Supports domestic WPS Office documents such as `wps`, `dps`, `et` , `ett`, ` wpt`.
3. Supports OpenOffice, LibreOffice office documents such as `odt`, `ods`, `ots`, `odp`, `otp`, `six`, `ott`, `fodt` and `fods`.
4. Supports Visio flowchart files such as `vsd`, `vsdx`.
5. Supports Windows system image files such as `wmf`, `emf`.
6. Supports Photoshop software model files such as `psd` ,`eps`.
7. Supports document formats like `pdf`, `ofd`, and `rtf`.
8. Supports software model files like `xmind`. 
9. Support for `bpmn` workflow files.
10. Support for `eml` , `msg` mail files
11. Support for `epub` book documents
12. Supports 3D model files like `obj`, `3ds`, `stl`, `ply`, `gltf`, `glb`, `off`, `3dm`, `fbx`, `dae`, `wrl`, `3mf`, `ifc`, `brep`, `step`, `iges`, `fcstd`, `bim`, etc.
13. Supports CAD model files such as `dwg`, `dxf`, `dwf`  `iges` ,` igs`, `dwt` , `dng` , `ifc` , `dwfx` , `stl` , `cf2` , `plt`, etc.
14. Supports all plain text files such as `txt`, `xml` (rendering), `md` (rendering), `java`, `php`, `py`, `js`, `css`, etc.
15. Supports compressed packages such as `zip`, `rar`, `jar`, `tar`, `gzip`, `7z`, etc.
16. Supports image previewing (flip, zoom, mirror) of `jpg`, `jpeg`, `png`, `gif`, `bmp`, `ico`, `jfif`, `webp`, `heic`,  ,`heif` etc.
17. Supports image information model files such as `tif` and `tiff`.
18. Supports image format files such as `tga`.
19. Supports vector image format files such as `svg`.
20. Supports `mp3`,`wav`,`mp4`,`flv` .
21. Supports many audio and video format files such as `avi`, `mov`, `wmv`, `mkv`, `3gp`, and `rm`.
22. Supports for `dcm` .
23. Supports for `drawio` .

### Features
- Build with the popular frame spring boot
- Easy to build and deploy
- Basically support online preview of mainstream office documents, such as Doc, docx, Excel, PDF, TXT, zip, rar, pictures, etc
- REST API
- Abstract file preview interface so that it is easy to extend more file extensions and develop this project on your own

### Official website and DOCS

URL：[https://kkview.cn](https://kkview.cn/)

### Live demo
> Please treat public service kindly, or this would stop at any time.

URL：[https://file.kkview.cn](https://file.kkview.cn)

### Contact Us
> We will answer your questions carefully and solve any problems you encounter while using the project. We also kindly ask that you at least Google or Baidu before asking questions in order to save time and avoid ineffective communication. Let's cherish our lives and stay away from ineffective communication.

<img src="./doc/github星球.png/" width="50%">

### Quick Start
> Technology stack
- Spring boot： [spring boot Development Reference Guide](http://www.kailing.pub/PdfReader/web/viewer.html?file=springboot)
- Freemarker
- Redisson 
- Jodconverter
> Dependencies
- Redis(Optional, Unnecessary by default)
- OpenOffice or LibreOffice(Integrated on Windows, will be installed automatically on Linux, need to be manually installed on Mac OS)

1. First step：`git pull https://github.com/kekingcn/kkFileView.git`

2. second step：Run the main method of `/server/src/main/java/cn/keking/ServerMain.java`. After starting,visit `http://localhost:8012/`.

## Change History

### Version 5.0.2 (August 14, 2026)

#### Security Fixes
1. Sandboxed untrusted HTML previews in an opaque-origin iframe and disabled embedded JavaScript by default, preventing previewed files from executing in the kkFileView application origin (GHSA-9wcf-jxxf-w2g2)
2. Disabled the demo file deletion endpoint by default, changed it to POST, and required an explicitly configured password with exact comparison (GHSA-f3qx-xrwc-5428)

#### Fixes
1. Refreshed ImageIO plugins when PDF conversion starts so nested JAR providers such as the JBIG2 reader are discovered, preventing images from disappearing in PDF-to-image previews

#### Upgrade Notes
1. All users running v5.0.1 or earlier are strongly encouraged to upgrade to v5.0.2
2. JDK 21 or higher remains required, and existing v5.0.1 configuration can be reused
3. File deletion is now disabled unless `KK_DELETE_PASSWORD` or an external `delete.password` is set to an independent strong password; integrations must call `/deleteFile` with POST
4. `kk.scriptjs` now defaults to `false`; when explicitly enabled, scripts still run only inside the isolated iframe sandbox

### Version 5.0.1 (July 13, 2026)

#### Security Fixes
1. Fixed `/addTask` bypassing trusted-host and local-directory filters, which could allow server-side request forgery (SSRF) (GHSA-gwwj-52hv-6g2m)
2. Fixed the `/listFiles` `directory` parameter escaping the demo directory, which could allow path traversal and directory information disclosure (GHSA-pmp8-g8p2-p6jq)

#### Fixes
1. Fixed PDF cross-origin access, page positioning, text highlighting, printing, and print watermark issues
2. Fixed PDF absolute paths behind reverse proxies and parsing failures when watermark or highlight text contains special characters
3. Fixed inconsistent Redis settings across standalone, cluster, master-replica, and sentinel modes, including missing address protocols
4. Fixed successful responses after MIME validation failures, unclear HTTP error reporting, and accidental closure of a shared HTTP client
5. Fixed xlsx parsing crashes when LuckyExcel data-validation types have no mapping

#### Improvements
1. Moved LuckyExcel parsing for large xlsx files into a Web Worker, with automatic main-thread fallback when the Worker is unavailable or fails
2. Added `pdf.sidebar.open` to control whether the PDF sidebar opens by default
3. Added Linux, Windows, and macOS validation to Maven CI
4. Added a repository security policy and private vulnerability reporting guidance

#### Upgrade Notes
1. All users running v5.0.0 or earlier are strongly encouraged to upgrade to v5.0.1
2. JDK 21 or higher remains required, and existing v5.0.0 configuration can be reused

### Version 5.0.0 (April 14, 2026)

#### Improvements
1. Enhanced xlsx front-end parsing - Improved Excel file front-end rendering performance
2. Optimized image parsing - Enhanced image processing mechanism
3. Improved tif parsing - Enhanced TIF format support
4. Enhanced svg parsing - Optimized SVG vector image rendering
5. Improved json parsing - Enhanced JSON file processing
6. Optimized ftp multi-client access - Improved FTP service compatibility
7. Enhanced home page directory access - Implemented post server-side pagination mechanism
8. Improved marked parsing - Enhanced Markdown rendering
9. Redesigned archive preview into a single workspace with a collapsible tree and inline file preview
10. Improved archive preview file-type badges and single-image preview styling
11. Added an agent-focused repository guide for engineering automation and maintenance
12. Refreshed the demo portal pages, including the index, integration guide, release record, and sponsor pages

#### New Features
1. msg email parsing - Added support for msg format email file preview
2. heic image parsing - Added support for HEIC format image preview
3. Cross-domain methods - Added cross-domain processing mechanism
4. Highlighting methods - Added text highlighting functionality
5. Pagination methods - Added document page control
6. AES encryption methods - Added AES encryption support
7. Basic authentication methods - Added Basic authentication mechanism
8. Key management methods - Added key management functionality
9. Anti-duplicate conversion - Added duplicate file conversion protection
10. Async waiting - Added asynchronous processing mechanism
11. Upload restrictions - Added restrictions for unsupported file uploads
12. cadviewer conversion methods - Added CAD viewer conversion functionality

#### Fixed Issues
1. Compressed file path issues - Fixed internal path handling in compressed files
2. Security issues - Fixed security vulnerabilities
3. Incomplete image watermark issues - Fixed incomplete watermark display
4. SSL self-signed certificate access issues - Fixed compatibility with self-signed certificates
5. Fixed archive-contained Office files that could stay stuck on loading because repeated extraction appended to existing files
6. Default Office preview now prefers PDF mode, and PDF preview opens with the thumbnail sidebar visible by default
7. Updated startup scripts to discover the packaged jar dynamically instead of relying on stale hard-coded jar names
8. Updated Docker and release helper docs to align with the 5.0.0 release line
9. Fixed OFD table border overflow rendering issues
10. Refined the PDF.js compatibility polyfill to avoid preview errors in compatibility environments

#### Updates
1. JDK version requirement - Mandatory requirement for JDK 21 or higher
2. pdf front-end parsing update - Upgraded PDF front-end rendering component
3. odf front-end parsing update - Upgraded ODF document front-end rendering
4. 3D model front-end parsing update - Upgraded 3D model viewer
5. pdf backend async conversion optimization - Implemented multi-threaded asynchronous conversion
6. tif backend async conversion optimization - Implemented multi-threaded asynchronous conversion
7. Video backend async conversion optimization - Implemented multi-threaded asynchronous conversion
8. CAD backend async conversion optimization - Implemented multi-threaded asynchronous conversion
9. Default preview configuration strategy adjusted - Office preview now defaults to PDF mode, the mode switch is hidden by default, and PDF preview opens with the thumbnail sidebar visible. If you need the previous image-first behavior after upgrade, explicitly set `office.preview.type=image` and `office.preview.switch.disabled=false`.
10. Trust host configuration matching expanded - `trust.host` and related rules now support wildcard and CIDR matching, which may broaden or narrow effective allow/deny behavior after upgrade depending on your patterns

### Version 4.4.0 (January 16, 2025)

#### New Features
1. xlsx printing support
2. Added GZIP compression enablement in configuration
3. CAD format now supports conversion to SVG and TIF formats, added timeout termination and thread management
4. Added captcha verification for file deletion
5. Added xbrl format preview support
6. PDF preview added control over signatures, drawings, illustration control, search positioning pagination, and display content definition
7. Added CSV format front-end parsing support
8. Added Docker image support for ARM64
9. Added Office preview conversion timeout property setting
10. Added preview file host blacklist mechanism

#### Optimizations
1. Optimized OFD mobile preview page adaptability
2. Updated xlsx front-end parsing component to accelerate parsing speed
3. Upgraded CAD component
4. Office function adjustments, supporting comments, conversion page limit, watermark generation, etc.
5. Upgraded markdown component
6. Upgraded dcm parsing component
7. Upgraded PDF.JS parsing component
8. Changed video player plugin to ckplayer
9. Smarter tif parsing, supporting modified image formats
10. Improved character encoding detection accuracy for large and small text files, handling concurrency vulnerabilities
11. Refactored file download code, added general file server authentication access design
12. Updated bootstrap component and streamlined unnecessary files
13. Updated epub version, optimized epub display effect
14. Fixed issue where scheduled cache cleanup only deleted disk cache files for multimedia file types
15. Auto-detection of installed Office components, added default paths for LibreOffice 7.5 & 7.6 versions
16. Changed drawio default to preview mode
17. Added PDF thread management, timeout management, memory cache management, updated PDF parsing component version
18. Optimized Dockerfile for true cross-platform image building

#### Fixes
1. Fixed forceUpdatedCache property setting issue where local cache files weren't updated
2. Fixed PDF decryption error after successful encrypted file conversion
3. Fixed BPMN cross-domain support issue
4. Fixed special character error in compressed package secondary reverse proxy
5. Fixed video cross-domain configuration causing video preview failure
6. Fixed TXT text pagination secondary loading issue
7. Fixed Drawio missing Base64 component issue
8. Fixed Markdown escaping issue
9. Fixed EPUB cross-domain error
10. Fixed URL special character issues
11. Fixed compressed package traversal vulnerability
12. Fixed compressed file path errors, image collection path errors, watermark issues, etc.
13. Fixed front-end parsing XLSX containing EMF format file errors

### Version 4.3.0 (July 5, 2023)

#### New Features
1. Added DCM medical digital imaging preview
2. Added drawio drawing preview
3. Added command to regenerate with cache enabled: &forceUpdatedCache=true
4. Added dwg CAD file preview
5. Added PDF file password support
6. Added DPI customization for PDF file image generation
7. Added configuration to delete converted OFFICE, CAD, TIFF, compressed package source files (enabled by default to save disk space)
8. Added front-end xlsx parsing method
9. Added support for pages, eps, iges, igs, dwt, dng, ifc, dwfx, stl, cf2, plt and other formats

#### Optimizations
1. Modified generated PDF file names to include file extensions to prevent duplicate names
2. Adjusted SQL file preview method
3. Optimized OFD preview compatibility
4. Beautified TXT text pagination box display
5. Upgraded Linux/Docker built-in office to LibreOffice-7.5.3
6. Upgraded Windows built-in office to LibreOffice-7.5.3 Portable
7. Other functional optimizations

#### Fixes
1. Fixed compressed package path errors in reverse proxy scenarios
2. Fixed .click error when image preview URLs contain &
3. Fixed known OFD preview issues
4. Fixed page error when clicking on file directories (tree nodes) in compressed package preview
5. Other known issue fixes

### Version 4.2.1 (April 18, 2023)

#### Change Log
1. Fixed null pointer bug in dwg file preview

### Version 4.2.0 (April 13, 2023)

#### New Features
1. Added SVG format file preview support
2. Added encrypted Office file preview support
3. Added encrypted zip, rar, and other compressed package file preview support
4. Added xmind software model file preview support
5. Added BPMN workflow model file preview support
6. Added eml email file preview support
7. Added EPUB e-book file preview support
8. Added office document format support: dotm, ett, xlt, xltm, wpt, dot, xlam, xla, dotx, etc.
9. Added 3D model file support: obj, 3ds, stl, ply, gltf, glb, off, 3dm, fbx, dae, wrl, 3mf, ifc, brep, step, iges, fcstd, bim, etc.
10. Added configurable high-risk file upload restrictions (e.g., exe files)
11. Added configurable site filing information
12. Added password requirement for demo site file deletion

#### Optimizations
1. Added caching for text document preview
2. Beautified 404, 500 error pages
3. Optimized invoice and other OFD file preview seal rendering compatibility
4. Removed office-plugin module, using new jodconverter component
5. Optimized Excel file preview effect
6. Optimized CAD file preview effect
7. Updated xstream, junrar, pdfbox, and other dependency versions
8. Updated TIF to PDF conversion plugin, added conversion cache
9. Optimized demo page UI deployment
10. Compressed package file preview supports directories

#### Fixes
1. Fixed XSS issues in some interfaces
2. Fixed console printed demo address not following content-path configuration
3. Fixed OFD file preview cross-domain issues
4. Fixed internal self-signed certificate HTTPS URL file download issues
5. Fixed special character file deletion issues
6. Fixed OOM caused by unreclaimed memory in PDF to image conversion
7. Fixed garbled preview for xlsx 7.4+ version files
8. Fixed TrustHostFilter not intercepting cross-domain interfaces (security issue - upgrade required if using TrustHost)
9. Fixed compressed package file preview filename garbled issue on Linux systems
10. Fixed OFD file preview only displaying 10 pages


### Changelog
> December 14, 2022, version 4.1.0 released:

1. Updated homepage design by @wsd7747.
2. Compatible with multipage tif for pdf and jpg conversion and multiple page online preview for tif image preview by @zhangzhen1979.
3. Optimized docker build, using layered build method by @yl-yue.
4. Implemented file encryption based on userToken cache by @yl-yue.
5. Implemented preview for encrypted Word, PPT, and Excel files by @yl-yue.
6. Upgraded Linux & Docker images to LibreOffice 7.3.
7. Updated OFD preview component, tif preview component, and added support for PPT watermarking.
8. Numerous other upgrades, optimizations, and bug fixes.
We thank @yl-yue, @wsd7747, @zhangzhen1979, @tomhusky, @shenghuadun, and @kischn.sun for their code contributions.


> July 6, 2021, version 4.0.0 released:

1. The integration of OpenOffice in the underlying system has been replaced with LibreOffice, resulting in enhanced compatibility and improved preview effects for Office files.
2. Fixed the directory traversal vulnerability in compressed files.
3. Fixed the issue where previewing PPT files in PDF mode was ineffective.
4. Fixed the issue where the front-end display of image preview mode for PPT files was abnormal.
5. Added a new feature: the file upload function on the homepage can be enabled or disabled in real-time through configuration.
6. Optimized the logging of Office process shutdown.
7. Optimized the logic for finding Office components in Windows environment, with built-in LibreOffice taking priority.
8. Optimized the synchronous execution of starting Office processes.

> June 17, 2021, version 3.6.0 released:

This version includes support for OFD file type versions, and all the important features in this release were contributed by the community. We thank @gaoxingzaq and @zhangxiaoxiao9527 for their code contributions.

1. Added support for previewing OFD type files. OFD is a domestically produced file format similar to PDF.
2. Added support for transcoding and previewing video files through ffmpeg. With transcoding enabled, theoretically, all mainstream video file formats such as RM, RMVB, FLV, etc. are supported for preview.
3. Beautified the preview effect of PPT and PPTX file types, much better looking than the previous version.
4. Updated the versions of dependencies such as pdfbox, xstream, common-io.

> January 28, 2021:

The final update of the Lunar New Year 2020 has been released, mainly including some UI improvements, bug fixes reported by QQ group users and issues, and most importantly, it is a new version for a good year.

1. Introduced galimatias to solve the problem of abnormal file download caused by non-standard file names.
2. Updated UI style of index access demonstration interface.
3. Updated UI style of markdown file preview.
4. Updated UI style of XML file preview, adjusted the architecture of text file preview to facilitate expansion.
5. Updated UI style of simTxT file preview.
6. Adjusted the UI of continuous preview of multiple images to flip up and down.
7. Simplified all file download IO operations by adopting the apache-common-io package.
8. XML file preview supports switching to pure text mode.
9. Enhanced prompt information when url base64 decoding fails.
10. Fixed import errors and image preview bug.
11. Fixed the problem of missing log directory when running the release package.
12. Fixed the bug of continuous preview of multiple images in the compressed package.
13. Fixed the problem of no universal matching for file type suffixes in uppercase and lowercase.
14. Specified the use of the Apache Commons-code implementation for Base64 encoding to fix exceptions occurring in some JDK versions.
15. Fixed the bug of HTML file preview of text-like files.
16. Fixed the problem of inability to switch between jpg and pdf when previewing dwg files.
17. Escaped dangerous characters to prevent reflected xss.
18. Fixed the problem of duplicate encoding causing the failure of document-to-image preview and standardized the encoding.

> December 27, 2020:

The year-end major update of 2020 includes comprehensive architecture design, complete code refactoring, significant improvement in code quality, and more convenient secondary development. We welcome you to review the source code and contribute to building by raising issues and pull requests.

1. Adjusted architecture modules, extensively refactored code, and improved code quality by several levels. Please feel free to review.
2. Enhanced XML file preview effect and added preview of XML document structure.
3. Added support for markdown file preview, including support for md rendering and switching between source text and preview.
4. Switched the underlying web server to jetty, resolving the issue: https://github.com/kekingcn/kkFileView/issues/168
5. Introduced cpdetector to solve the problem of file encoding recognition.
6. Adopted double encoding with base64 and urlencode for URLs to completely solve preview problems with bizarre file names.
7. Added configuration item office.preview.switch.disabled to control the switch of office file preview.
8. Optimized text file preview logic, transmitting content through Base64 to avoid requesting file content again during preview.
9. Disabled the image zoom effect in office preview mode to achieve consistent experience with image and pdf preview.
10. Directly set pdfbox to be compatible with lower version JDK, and there will be no warning prompts even when run in IDEA.
11. Removed non-essential toolkits like Guava and Hutool to reduce code volume.
12. Asynchronous loading of Office components speeds up application launch to within 5 seconds.
13. Reasonable settings of the number of threads in the preview consumption queue.
14. Fixed the bug where files in compressed packages failed to preview again.
15. Fixed the bug in image preview.

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
15. Official website build: [https://kkview.cn](https://kkview.cn)
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

### Sponsor Us
If this project has been helpful to you, we welcome your sponsorship. Your support is our greatest motivation.！
