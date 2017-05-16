//
//  NSNumber+Tool.h
//  DingYouMing
//
//  Created by ceyu on 2017/3/3.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Tool)
///page从1开始的页码计算
+(NSNumber*)pageForTotal:(NSInteger)total withLines:(NSInteger)lines;
@end
