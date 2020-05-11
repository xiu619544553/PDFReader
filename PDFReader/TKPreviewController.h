//
//  TKPreviewController.h
//  PDFReader
//
//  Created by hanxiuhui on 2020/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 支持 pdf、word、excel 等
@interface TKPreviewController : UIViewController
/// 网络链接
@property (nonatomic, copy) NSString *networkUrl;
/// 本地文件路径
@property (nonatomic, copy) NSString *localUrl;

@end

NS_ASSUME_NONNULL_END
