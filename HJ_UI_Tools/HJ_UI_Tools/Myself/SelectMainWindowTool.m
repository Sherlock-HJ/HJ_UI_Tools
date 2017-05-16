//
//  SelectMainWindowTool.m
//  YiXiXinCourier
//
//  Created by mac on 17/1/12.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import "SelectMainWindowTool.h"
#import "CDAccountTool.h"
#import "OftenUse.h"
#import "HttpClient.h"
#import "CityURLObj.h"

@implementation SelectMainWindowTool

/**
 *  选择根控制器
 */
+ (void)chooseRootController{
    CityURLObj *cityObj = [CityURLObj cityURLObj];
    [[HttpClient defaultClient] setBaseURL:cityObj.rootURL];

    [self appearance];//设置主题色调
    NSString *key = @"CFBundleVersion";
    
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) {
        
        [self isLogin];
        
    } else { // 新版本 New features

        [self toNewFeatures];
        // 存储新版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
    }
    
}
+(void)isLogin{
    CDAccountObj *account = [CDAccountTool account];
    if (account) [self toMain];//去首页
    else [self toLogin];//去登录
}
+(void)toLogin{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = [storyboard instantiateInitialViewController];
}
+(void)toMain{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = [storyboard instantiateInitialViewController];
    
}

+(void)toNewFeatures{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewFeatures" bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = [storyboard instantiateInitialViewController];
    
}
+(UIViewController*)generateCommonlyAddressVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"CommonlyAddressVC"];
}
+(UIViewController *)generateForgotVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
     UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RegisteredVC"];
    vc.title = forgotPassword;
    return vc;
}
+(void)isUpdate{
    ///TODO:添加appid
    NSURLSession *urlSession =  [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask =  [urlSession dataTaskWithURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/lookup?id=1218688738"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)  return ;
        
        NSString *jsonStr =   [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSRange leftRange = [jsonStr rangeOfString:@"version"];
        NSUInteger loc = leftRange.location+leftRange.length + 3;
        if (jsonStr.length < loc) return ;
        jsonStr = [jsonStr substringFromIndex:loc];
        NSRange rightRange = [jsonStr rangeOfString:@","];
        if (jsonStr.length < rightRange.location-1) return ;
        NSString *currentVersion = [jsonStr substringToIndex:rightRange.location-1];
        
        NSString *lastVersion =[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
        
        BOOL loob =  [currentVersion compare:lastVersion options:NSNumericSearch] ==NSOrderedDescending;
        
        NSLog(@"%@----%@",loob?@"是":@"否",[NSThread currentThread]);
        if (loob) {
            dispatch_async(dispatch_get_main_queue(), ^{///回主线程执行UI部分
                [self alert];
            });
            
        }
    }];
    
    [dataTask resume];
    
}

+(void)alert{
    NSString *key = @"CFBundleShortVersionString";//与App Store一致的版本号
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    NSString *message = [ NSString stringWithFormat:@"有新版本啦~赶快去升级吧~\n当前版本：%@",currentVersion];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"升级！" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction =[UIAlertAction actionWithTitle:@"去升级！" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ///TODO:添加升级链接
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E6%96%B0%E7%AD%96%E8%BE%BE%E4%B8%9A%E5%8A%A1/id1218688738?mt=8"]];
        [self alert];
    } ];
    [alert addAction:sureAction];
    
    [KeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];

}
+(void)appearance{
    // UITabBarItem
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:MassToneAttune} forState:UIControlStateSelected];
    //pageControl
    [UIPageControl appearance].currentPageIndicatorTintColor = MassToneAttune;
    ///UINavigationBar
    [UINavigationBar appearance].barTintColor = MassToneAttune;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];

}
@end
