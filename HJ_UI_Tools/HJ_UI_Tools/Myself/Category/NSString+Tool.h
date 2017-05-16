//
//  NSString+Tool.h
//  YiXiXinCourier
//
//  Created by mac on 17/1/13.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tool)
#pragma mark - 对象方法
///32位MD5加密
-(NSString *)MD5;

#pragma mark - 工厂方法
///判断字符串是否为空
+(NSString*)judgeString:(NSString*)string;
/// 是否是整数
-(BOOL)isInteger;
///是否是小数点后两位
-(BOOL)isTwoDecimalPlaces;
@end
