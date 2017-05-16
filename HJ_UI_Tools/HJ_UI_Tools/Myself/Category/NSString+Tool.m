//
//  NSString+Tool.m
//  YiXiXinCourier
//
//  Created by mac on 17/1/13.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import "NSString+Tool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Tool)
#pragma mark - 对象方法

#pragma mark md5加密32位
-(NSString *)MD5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
#pragma mark 是否是整数
-(BOOL)isInteger{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
    
}
#pragma mark 是否是小数点后两位
-(BOOL)isTwoDecimalPlaces{
    float number = self.floatValue;
    NSRange range = [self rangeOfString:@"."];
    NSScanner * scanner = [NSScanner scannerWithString:self];
    
    return (range.length == 0 || range.location == self.length - 3|| range.location == self.length - 2)&&self.length > 0 && number > 0 &&[scanner scanFloat:&number] && [scanner isAtEnd];
    
}
#pragma mark - 工厂方法

#pragma mark---对字符串的值进行判断
+(NSString*)judgeString:(NSString*)string
{
    NSString * currentStr = [NSString stringWithFormat:@"%@",string];
    if (string &&currentStr.length && [string isKindOfClass:[NSString class]] && ![string isKindOfClass:[NSNull class]] &&  ![currentStr isEqualToString:@"(null)"] && ![currentStr isEqualToString:@"<null>"]) {
        return string;
    }
    return @"";
}


@end
