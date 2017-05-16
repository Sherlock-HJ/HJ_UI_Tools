//
//  PayTool.m
//  DingYouMing
//
//  Created by ceyu on 2017/3/8.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import "PayTool.h"
#import "HttpClient.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "MJExtension.h"
#import "NSString+Tool.h"

@interface PayTool () <WXApiDelegate>
@property(strong,nonatomic) NSURL *url;
@property(assign,nonatomic) BOOL isPayBegin;
@end

@implementation PayTool
+(instancetype)sharePayTool{
    static PayTool *payTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        payTool = [[PayTool alloc]init];
    });
    return payTool;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册微信支付
        [WXApi registerApp:@"wxd930ea5d5a258f4f" withDescription:[WXApi getApiVersion]];
    }
    return self;
}
#pragma mark - 支付宝支付相关
///TODO:添加appid

-(void)aliPayAction:(PayParamObj*)param{

    
    [self payBegin];//开始
    __weak __typeof(self)wself = self;
    HttpClient *http = [HttpClient defaultClient];
    [http requestWithPath:@"interface/alipay/payUrl_Alipay" method:HttpRequestGet parameters:param.mj_keyValues success:^(NSURLSessionDataTask *task, id responseObject) {

        if ([responseObject[@"error_code"] integerValue] == 0) {
            self.isPayBegin = YES ;///支付开始
            ///TODO:添加appid
            // NOTE: 如果加签成功，则继续执行支付
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"com.DingYouMing.alipay";
            
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString =  responseObject[@"url"];
            
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                

                if ([resultDic[@"resultStatus"] integerValue] == 9000) {//支付宝支付成功
                    [wself returnURLWithParam:resultDic];
                }else{
                    [wself payErrorCode:[resultDic[@"resultStatus"] integerValue] withErrorInfo:resultDic[@"memo"]];//
                }
                
            }];
            
            
        }else{
            [wself payErrorCode:[responseObject[@"error_code"] integerValue] withErrorInfo:@"支付请求发送失败"];//

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [wself payErrorCode:-1 withErrorInfo:@"网络错误"];//

    }];
    
    
}
-(void)wePayAction:(PayParamObj*)param{
    self.isPayBegin = YES;
    
    //    if (![WXApi isWXAppInstalled]) {//检查微信是否已被用户安装
    //
    //        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到您的手机未安装微信" preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:nil];
    //        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"安装" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            //跳转APPStorez下载
    //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
    //        }];
    //        [alertC addAction:cancelAction];
    //        [alertC addAction:sureAction];
    //
    //        [self presentViewController:alertC animated:YES completion:nil];
    //
    //        return ;
    //    }
    //    if (![WXApi isWXAppSupportApi ]) {//判断当前微信的版本是否支持OpenApi
    //        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到您手机中的微信版本不支持，请更新" preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:nil];
    //        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //            //跳转APPStorez下载
    //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
    //
    //        }];
    //        [alertC addAction:cancelAction];
    //        [alertC addAction:sureAction];
    //
    //        [self presentViewController:alertC animated:YES completion:nil];
    //
    //        return ;
    //    }
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = @"10000100";
    request.prepayId= @"1101000000140415649af9fc314aa427";
    request.package = @"Sign=WXPay";
    request.nonceStr= [NSString stringWithFormat:@"%ld",arc4random()%10000000000].MD5;
    request.timeStamp = (UInt32)[[NSDate date] timeIntervalSince1970];
    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
    [WXApi sendReq:request];
}
#pragma mark - 支付结果

- (void)returnURLWithParam:(NSDictionary*)resultDic{

    __weak __typeof(self)wself = self;
    HttpClient *http = [HttpClient defaultClient];
    [http requestWithPath:@"interface/alipay/returnUrl" method:HttpRequestGet parameters:resultDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"error_code"] integerValue] == 0) {

            [wself payErrorCode:0 withErrorInfo:@"支付成功！"];//
        
        }else{
        
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [wself payErrorCode:-1 withErrorInfo:@"网络错误"];//

    }];
    
}
-(void)payVerifyResults{
    if (self.isPayBegin) {
        self.isPayBegin = NO ;///支付结束
        [self payErrorCode:-1 withErrorInfo:@"支付未完成！"];
    }
}
-(void)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options{
    self.url = url;
    self.isPayBegin = NO ;///支付结束

    __weak __typeof(self)wself = self;
    if ([url.host isEqualToString:@"safepay"]) {
        //        跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {

            if ([resultDic[@"resultStatus"] integerValue] == 9000) {//支付宝支付成功
                [wself returnURLWithParam:resultDic];
                
            }else{
                [wself payErrorCode:[resultDic[@"resultStatus"] integerValue] withErrorInfo:resultDic[@"memo"] ];//

            }
            
        }];
    }else{
        [WXApi handleOpenURL:url delegate:self];
        
    }
    
}
#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req{
    
    NSLog(@"WXApiDelegate: req - %@",req.openID);
}
-(void)onResp:(BaseResp *)resp{
    
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                [self returnURLWithParam:@{response.returnKey:response.returnKey}];
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%@",resp.errStr);
                [self payErrorCode:resp.errCode withErrorInfo:resp.errStr];//

                break;
        }
    }
    
}
#pragma mark - 代理
-(void)payErrorCode:(NSInteger)errorCode withErrorInfo:(NSString *)errorInfo;//
{
    if ([self.delegate respondsToSelector:@selector(payResultWithErrorCode:withErrorInfo:withObject:)]) {
        [self.delegate payResultWithErrorCode:errorCode withErrorInfo:errorInfo withObject:_object];
    }
}
-(void)payBegin{
    if ([self.delegate respondsToSelector:@selector(payBeginWithObject:)]) {
        [self.delegate payBeginWithObject:_object];
    }
}
@end
