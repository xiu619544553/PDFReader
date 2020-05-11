//
//  NSFileManager+TKAdd.m
//  PDFReader
//
//  Created by hanxiuhui on 2020/5/11.
//

#import "NSFileManager+TKAdd.h"

@implementation NSFileManager (TKAdd)

- (BOOL)checkExistFileName:(NSString *)fileName atAbsolutePath:(NSString*)path {
    // 默认不存在
    BOOL flag = NO;
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:path]) {
        return flag;
    }
    
    NSArray *subpaths = [fileMgr subpathsAtPath:path];
    NSEnumerator *subFilesEnumerator = [subpaths objectEnumerator];
    NSString *result = nil;
    while ((result = [subFilesEnumerator nextObject])) {
        if ([result isEqualToString:fileName]) {
            flag = YES;
            break;
        }
    }
    
    return flag;
}

- (void)removeItemAtAbsolutePath:(NSString *)path
{
    NSFileManager *fileMgr=[NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:path]) { return; }
    
    NSError *error = nil;
    BOOL result =  [fileMgr removeItemAtPath:path error:&error];
    if(result) {
        NSLog(@"清除成功");
    } else {
        NSLog(@"%@", error);
    }
}
@end
