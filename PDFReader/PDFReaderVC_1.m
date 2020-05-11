//
//  PDFReaderVC_1.m
//  PDFReader
//
//  Created by hanxiuhui on 2020/5/11.
//

#import "PDFReaderVC_1.h"
#import <QuickLook/QuickLook.h>
#import <Masonry.h>
#import <YYKit.h>
#import "NSFileManager+TKAdd.h"
#import <AFNetworking.h>

// 📂Caches缓存文件夹的绝对路径 ~/Library/Caches  缓存PDF文件
#define TKCacheeAbsolutePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define TKPDFCacheAbsolutePath [TKCacheeAbsolutePath stringByAppendingPathComponent:@"/PDFCache"]

@interface PDFReaderVC_1 () <QLPreviewControllerDataSource>

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) QLPreviewController *previewController;

@end

@implementation PDFReaderVC_1

#pragma mark - LifeCycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    // 进度条
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(@1);
    }];
    
    
    
    if (self.localUrl && self.localUrl.length > 0) {
        // 加载本地
        self.filePath = self.localUrl;
        [self prepareUI];
    } else {
        
        self.filePath = [self generateAbsolutePathByUrl:self.networkUrl];
        
        
        BOOL isExist = [[NSFileManager defaultManager] checkExistFileName:self.filePath.lastPathComponent atAbsolutePath:TKPDFCacheAbsolutePath];
        
        if (isExist) {
            // 本地有缓存
            [self prepareUI];
        } else {
            // 下载网络文件
            __weak typeof(self) weakSelf = self;
            AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.networkUrl]];
            
            [mgr downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                
                // 监听下载进度
                NSLog(@"%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                CGFloat progress = 1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf.progressView setProgress:progress animated:YES];
                });
                
                
                
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                
                return [NSURL fileURLWithPath:self.filePath];
                
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                
                
                NSLog(@"filePath=%@",filePath);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf.progressView setProgress:0.0f animated:YES];
                    if (error) {
                        // 添加默认视图
                        NSLog(@"下载失败=%@", error);
                        NSLog(@"下载path=%@", filePath.path);
                        [[NSFileManager defaultManager] removeItemAtAbsolutePath:filePath.path];
                    } else {
                        [strongSelf prepareUI];
                    }
                });
                
            }];
            
            
            
            
        }
    }
}

#pragma mark - QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return [NSURL fileURLWithPath:self.filePath];
}

#pragma mark - getter

- (QLPreviewController *)previewController {
    if (!_previewController) {
        _previewController = [[QLPreviewController alloc] init];
        _previewController.view.frame = self.view.bounds;
        _previewController.dataSource = self;
    }
    return _previewController;
}

- (UIProgressView *)progressView {
    if (!_progressView){
        _progressView = [UIProgressView new];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

#pragma mark - Private Methods

- (void)prepareUI {
    [self addChildViewController:self.previewController];
    [self.view addSubview:self.previewController.view];
    [self.previewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (NSString *)generateAbsolutePathByUrl:(NSString *)url {
    NSArray<NSString *> *subs = [url componentsSeparatedByString:@"."];
    if (subs == nil || subs.count == 0) {
        return nil;
    }
    NSString *suffix = subs.lastObject;
    NSString *fullPath = [TKPDFCacheAbsolutePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", [url md5String], suffix]];
    return fullPath;
}
@end
