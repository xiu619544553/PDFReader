//
//  NSFileManager+TKAdd.h
//  PDFReader
//
//  Created by hanxiuhui on 2020/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (TKAdd)
- (void)removeItemAtAbsolutePath:(NSString *)path;
- (BOOL)checkExistFileName:(NSString *)fileName atAbsolutePath:(NSString*)path;
@end

NS_ASSUME_NONNULL_END
