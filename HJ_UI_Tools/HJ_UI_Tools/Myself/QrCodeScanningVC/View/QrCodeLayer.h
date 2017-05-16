//
//  QrCodeLayer.h
//  KuGuan
//
//  Created by ceyu on 16/7/22.
//  Copyright © 2016年 吴宏佳. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface QrCodeLayer : CALayer
{
    CGFloat orangeY;
    CGFloat unit  ;
    CADisplayLink *display;
}
///停止CADisplayLink
- (void)stopDisplayAnimation;
//- (CGRect)scanRect;
@end
