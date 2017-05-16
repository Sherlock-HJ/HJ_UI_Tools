//
//  StarsView.m
//  DingYouMing
//
//  Created by ceyu on 2017/2/22.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import "StarsView.h"

@implementation StarsView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = self.superview.backgroundColor;
    self.scale = 0;
}
-(void)setScale:(CGFloat)scale{
    _scale =scale;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat width = rect.size.width/5;
    if (width>rect.size.height) {//最小宽度
        width = rect.size.height;
    }
    //画五角星
    for (int j =0; j<5; j++) {
        
        //确定中心点
        CGPoint centerPoint=CGPointMake(width*(0.5+j), rect.size.height/2);
        //确定半径
        CGFloat radius=width/2;
        //五角星的顶点
        CGPoint p1=CGPointMake(centerPoint.x, centerPoint.y-radius);
        CGContextMoveToPoint(ctx, p1.x, p1.y);
        //五角星每个点之间点夹角，采用弧度计算。每两个点进行连线就可以画出五角星
        //点与点之间点夹角为2*M_PI/5.0，
        CGFloat angle=4*M_PI/5.0;
        for (int i=1; i<=4; i++) {
            CGFloat x=centerPoint.x-sinf(i*angle)*radius;
            CGFloat y=centerPoint.y-cosf(i*angle)*radius;
            CGContextAddLineToPoint(ctx, x, y);
        }
        CGContextClosePath(ctx);
    }
    //剪切上下文范围
   CGContextClip(ctx);

    //画颜色条
    CGRect leftRect = CGRectMake(0, rect.size.height/2 - width/2, width*5*self.scale, width);
    CGRect rightRect = leftRect;
    rightRect.origin.x = CGRectGetMaxX(leftRect);
    rightRect.size.width = rect.size.width - rightRect.origin.x ;
    CGContextAddRect(ctx, leftRect);
    [[UIColor orangeColor] setFill];
    CGContextFillPath(ctx);
    CGContextAddRect(ctx, rightRect);
    [[UIColor lightGrayColor] setFill];
    CGContextFillPath(ctx);
    
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return YES;
}
@end
