# PDFReader
PDF文档加载的几种方式

### QLPreviewController 加载pdf文档

在 iOS4 之后苹果推出了QLPreviewController，允许用户浏览许多不同的文件类型，比如：xls、word、pdf文件等。使用该 API 需要导入 QuickLook.framework。

使用时，必须实现 QLPreviewControllerDataSource 的两个代理方法。

上下滑动支持单个文档的浏览，左右滑动支持不同文档间的切换，还支持苹果自带的分享打印功能等。