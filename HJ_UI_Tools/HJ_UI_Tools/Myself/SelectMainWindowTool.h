//
//  SelectMainWindowTool.h
//  YiXiXinCourier
//
//  Created by mac on 17/1/12.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectMainWindowTool : NSObject

+ (void)chooseRootController;

+(void)toLogin;
+(void)toMain;
+(void)toNewFeatures;

+(void)isLogin;
+(void)isUpdate;

///生成CommonlyAddressVC
+(UIViewController*)generateCommonlyAddressVC;
///修改密码
+(UIViewController*)generateForgotVC;
@end
