//
//  UIView+HUD.m
//  YiXiXinCourier
//
//  Created by mac on 17/1/13.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import "UIView+HUD.h"
#import "MBProgressHUD.h"

@implementation UIView (HUD)
-(void)showHUDWithText:(NSString*)text hideDelay:(NSTimeInterval)time{
    if (!text) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:time];
}
-(void)showHUDLoading{
    [self showHUDLoadingWithText:nil];
}
-(void)showHUDLoadingWithText:(NSString*)text{
    if (!text) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.mode = text?MBProgressHUDModeCustomView:MBProgressHUDModeIndeterminate;
    hud.label.text = text;
    
}
-(void)hiddenHUDLoading{
    [MBProgressHUD hideHUDForView:self animated:YES];
    
}

@end
