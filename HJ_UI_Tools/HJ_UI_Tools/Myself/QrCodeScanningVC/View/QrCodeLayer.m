//
//  QrCodeLayer.m
//  KuGuan
//
//  Created by ceyu on 16/7/22.
//  Copyright © 2016年 吴宏佳. All rights reserved.
//

#import "QrCodeLayer.h"
static const CGFloat lineH = 20.0;
@implementation QrCodeLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        orangeY= 0;
        display= [CADisplayLink displayLinkWithTarget:self selector:@selector(updateImage)];
        
        [display addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

    }
    return self;
}
//提示此方法代理也可实现，但不用时层delegate必须等于nil，否则程序会crash
- (void)drawInContext:(CGContextRef)ctx{
    CGRect rect = self.bounds;
    
    // Drawing code
    
    
    // 创建色彩空间对象
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //对应点颜色
    CGFloat colors[12] ={
        0.0f, 0.0f, 0.0f, 0.0f,
        0.0f, 0.0f, 0.0f, 0.5f,
        0.0f, 0.0f, 0.0f, 0.0f,
    };
    //对应点颜色位置
    CGFloat locations[3] ={0.0f,0.5f,1.0f};
    // 创建渐变对象
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef,colors,locations,3);
    // 释放色彩空间
    CGColorSpaceRelease(colorSpaceRef);
//    CGContextClipToRect(ctx, clipF);
    CGPoint startPoint = CGPointMake(0,rect.origin.y+ orangeY - lineH/2);
    CGPoint endPoint = CGPointMake(0,rect.origin.y +lineH+orangeY-lineH/2);
    CGContextDrawLinearGradient( ctx, gradientRef, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
    // 释放渐变对象
    CGGradientRelease(gradientRef);

//    for (NSInteger num = 0; num < 10; num++) {
//        CGContextMoveToPoint(ctx, rect.origin.x, num * rect.size.height/10);
//        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), num * rect.size.height/10);
//        
//        CGContextMoveToPoint(ctx, num * rect.size.width/10, rect.origin.y);
//        CGContextAddLineToPoint(ctx,  num * rect.size.width/10, CGRectGetMaxY(rect));
//
//    }
//    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 0.5);
//    CGContextStrokePath(ctx);

    CGContextMoveToPoint(ctx, rect.origin.x, orangeY);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), orangeY);
    CGContextStrokePath(ctx);
    if (orangeY <= 0) {
        orangeY = 0;
        unit= 1;
    }
    if (orangeY >= rect.size.height) {
        orangeY = rect.size.height;
        unit= -1;
    }
    orangeY+=unit;

}

- (void)updateImage{

    [self setNeedsDisplay];
}
- (void)stopDisplayAnimation{
    display.paused = YES;
    [display invalidate];
    display = nil;
}
@end
