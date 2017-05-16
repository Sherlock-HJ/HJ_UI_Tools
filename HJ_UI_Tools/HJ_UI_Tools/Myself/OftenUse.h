//
//  OftenUse.h
//  YiXiXinCourier
//
//  Created by mac on 17/1/12.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const forgotPassword;
UIKIT_EXTERN NSString *const registered ;

UIKIT_EXTERN const NSInteger pageSize ;

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define KeyWindow [[UIApplication sharedApplication]keyWindow]
///主色调
#define  MassToneAttune [UIColor colorWithRed:42.0/255.0 green:221.0/255.0 blue:208.0/255.0 alpha:1.0]

#define HJCOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HJCOLOR3 HJCOLOR(51, 51, 51, 1.0)
#define HJCOLOR6 HJCOLOR(102, 102, 102, 1.0)
#define HJCOLOR9 HJCOLOR(153, 153, 153, 1.0)


///token 验证出错
#define LOGIN_TOKEN_ERROR  resultObj.err_code == 1001 || resultObj.err_code == 1002

///拼接主路径
#define MainURLString(url)  [NSString stringWithFormat:@"%@%@",[HttpClient defaultClient].baseURL,url]
#define MainURL(url)  [NSURL URLWithString:MainURLString(url)]

///移动端类型 - 业务
#define ClientTypes @0
