//
//  UIImageView+QrCode.h
//  二维码
//
//  Created by ceyu on 16/7/20.
//  Copyright © 2016年 吴宏佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (QrCode)
/**
 *@string 要转化为二维码的字符串
 */
- (void)QrCodeWithString:(NSString*)string;
/**
 *@string 要转化为二维码的字符串
 *@size 二维码的长（长=宽）
 */
- (void)QrCodeWithString:(NSString*)string withImageSize:(CGFloat) size;
/**
 *@string 要转化为二维码的字符串
 *@size 二维码的长（长=宽）
 *@scale 缩放比例（0为size大小 其他值图片质量变差）
 *@orientation 二维码方向 可设置镜像
 */
- (void)QrCodeWithString:(NSString*)string withImageSize:(CGFloat) size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;
@end
