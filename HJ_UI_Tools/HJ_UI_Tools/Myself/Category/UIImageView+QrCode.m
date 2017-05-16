//
//  UIImageView+QrCode.m
//  二维码
//
//  Created by ceyu on 16/7/20.
//  Copyright © 2016年 吴宏佳. All rights reserved.
//

#import "UIImageView+QrCode.h"

@implementation UIImageView (QrCode)
- (void)QrCodeWithString:(NSString*)string{
    
    [self QrCodeWithString:string withImageSize:150.0];
}
- (void)QrCodeWithString:(NSString *)string withImageSize:(CGFloat)size{
    [self QrCodeWithString:string withImageSize:size scale:0 orientation:UIImageOrientationUp];
}
- (void)QrCodeWithString:(NSString*)string withImageSize:(CGFloat) size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation{
    
    // 1. 实例化二维码滤镜
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2. 恢复滤镜的默认属性
    
    [filter setDefaults];
    
    // 3. 将字符串转换成
    
    NSData  *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    // 4. 通过KVO设置滤镜inputMessage数据
    
    [filter setValue:data forKey:@"inputMessage"];
//    NSLog(@"%@", filter.inputKeys);
    // 5. 获得滤镜输出的图像
    
    CIImage *outputImage = [filter outputImage];
    
    // 6. 将CIImage转换成UIImage，并放大显示
    
    //    return [UIImage imageWithCIImage:outputImage scale:20.0 orientation:UIImageOrientationUp];
    
    CGRect extent = CGRectIntegral(outputImage.extent);
    
    CGFloat scaleMin = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scaleMin;
    
    size_t height = CGRectGetHeight(extent) * scaleMin;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scaleMin, scaleMin);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    self.image = [UIImage imageWithCGImage:scaledImage scale:scale orientation:orientation];

    self.autoresizesSubviews = NO;
    //视图不进行自动尺寸调整
    self.autoresizingMask = UIViewAutoresizingNone;
    CGRect QrCodeF = self.frame;
    QrCodeF.size = self.image.size;
    self.frame = QrCodeF;
}

@end
