//
//  GrayBackgroundLayer.m
//  KuGuan
//
//  Created by ceyu on 16/7/22.
//  Copyright © 2016年 吴宏佳. All rights reserved.
//

#import "GrayBackgroundLayer.h"

@implementation GrayBackgroundLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setNeedsDisplay];
    }
    return self;
}
- (void)drawInContext:(CGContextRef)ctx{
    CGContextSetRGBFillColor(ctx, 0.5, 0.6, 0.4, 1.0);
    CGContextStrokePath(ctx);
    
    CGRect bgF =self.bounds;
    CGContextAddRect(ctx, bgF);
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5);
    
    CGContextFillPath(ctx);
    
    CGFloat scanW = 200.0;
    CGFloat scanH = scanW;
    CGFloat scanX = (bgF.size.width - scanW)/2;
    CGFloat scanY = (bgF.size.height - scanH)/2;
    CGRect downF = CGRectMake(scanX, scanY, scanW, scanH);
    CGContextClearRect(ctx, downF);
}
@end
