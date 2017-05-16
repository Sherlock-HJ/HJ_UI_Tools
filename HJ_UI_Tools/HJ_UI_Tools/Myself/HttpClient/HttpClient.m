//
//  HttpClient.m
//  LandzipadApp
//
//  Created by ceyu on 16/3/28.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HttpClient.h"
#import "AFNetworking.h"

@interface HttpClient()
@property(nonatomic,strong) AFHTTPSessionManager *manager;
@property(nonatomic,assign) BOOL isConnect;



@end

@implementation HttpClient

- (instancetype)init{
    if (self = [super init]){

        // 获得网络管理者

        self.manager = [AFHTTPSessionManager manager];

        //请求参数序列化类型
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        //响应结果序列化类型
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif",@"application/x-javascript",@"application/x-www-form-urlencoded", nil];
        self.isConnect = YES;
        [self isConnectionAvailable];

    }
    return self;
}

+ (HttpClient *)defaultClient
{
    static HttpClient *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
-(void)setBaseURL:(NSString*)baseURL{
    self.manager.baseURL = [NSURL URLWithString:baseURL];
}
-(NSString *)baseURL{
    return self.manager.baseURL.absoluteString;
}
#pragma mark -----------------------------------------------------
- (void)requestWithPath:(NSString *)url
                 method:(HttpRequestType)method
             parameters:(id)parameters
                success:(void (^)(NSURLSessionDataTask *, id))success
                     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{

    //判断网络状况（有链接：执行请求；无链接：弹出提示）
    if (self.isConnect) {
       
        switch (method) {
            case HttpRequestGet:
            {
                [self.manager GET:url parameters:parameters progress:nil success:success failure:failure];
            }
                break;
            case HttpRequestPost:
            {
                [self.manager POST:url parameters:parameters progress:nil success:success failure:failure];
            }
                break;
            case HttpRequestDelete:
            {
                [self.manager DELETE:url parameters:parameters success:success failure:failure];
            }
                break;
            case HttpRequestPut:
            {
                [self.manager PUT:url parameters:parameters success:success failure:false];
            }
                break;
            default:
                break;
        }
    }else{
        if (failure) {
            failure(nil,nil);
        }
        //网络错误咯
        [self showExceptionDialog];
        //发出网络异常通知广播
        [[NSNotificationCenter defaultCenter] postNotificationName:@"k_NOTI_NETWORK_ERROR" object:nil];
    }
    
    //请求的URL
    url = [NSString stringWithFormat:@"%@?",url];
    NSArray *keyArr = [parameters allKeys];
    for (NSString *keyStr in keyArr) {
        NSString *string = parameters[keyStr];
        url = [NSString stringWithFormat:@"%@%@=%@&",url,keyStr,string];
    }
    NSLog(@"\n----\nRequest path:%@/%@\n----\n",self.manager.baseURL,url);

}

- (void)requestWithPathInHEAD:(NSString *)url
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task))success
                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
   
    if (self.isConnect) {
        [self.manager HEAD:url parameters:parameters success:success failure:failure];
    }else{
        [self showExceptionDialog];
    }
}

- (void)requestWithPath:(NSString *)url
             parameters:(NSDictionary *)parameters
        thumbDictionary:(NSDictionary<NSString* , NSData*> *)thumbDic
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
{
    if (self.isConnect) {
        
        if (thumbDic.count==0) {
            [self.manager POST:url parameters:parameters progress:nil success:success failure:failure];
        }
        else{
            [self.manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSArray * allKeys =  [thumbDic allKeys];
                for (NSInteger num = 0; num < allKeys.count; num++) {
                    
                    [formData appendPartWithFileData:thumbDic[allKeys[num]] name:allKeys[num] fileName:@"1.png" mimeType:@"image/png"];
                    
                }
                
            } progress:nil success:success failure:failure];
        }
    }else{
        [self showExceptionDialog];
    }
    //请求的URL
    //请求的URL
    url = [NSString stringWithFormat:@"%@?",url];
    NSArray *keyArr = [parameters allKeys];
    for (NSString *keyStr in keyArr) {
        NSString *string = parameters[keyStr];
        url = [NSString stringWithFormat:@"%@%@=%@&",url,keyStr,string];
    }
    NSLog(@"\n----\nRequest path:%@/%@\n----\n",self.manager.baseURL,url);
    
}


- (void)setSuspended:(BOOL)suspended{
    NSOperationQueue *operationQueue =  self.manager.operationQueue;
    [operationQueue setSuspended:suspended];

}
//看看网络是不是给力
- (void)isConnectionAvailable{
    
    NSURL *baseURL = [NSURL URLWithString:@"https://www.baidu.com/"];
    AFHTTPSessionManager *operationManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];

    NSOperationQueue *operationQueue = operationManager.operationQueue;
    [operationManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                self.isConnect = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable://当前网络不可用
            default:
                [operationQueue setSuspended:YES];
                [self showExceptionDialog];
                self.isConnect = NO;
                break;
        }
        

    }];
    [operationManager.reachabilityManager startMonitoring];

    
  }

//弹出网络错误提示框
- (void)showExceptionDialog
{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络异常，请检查网络连接" preferredStyle:UIAlertControllerStyleAlert];
        //
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        //
        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        //
        [vc presentViewController:alertController animated:YES completion:nil];
    
}

@end
