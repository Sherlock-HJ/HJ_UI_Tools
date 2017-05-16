//
//  HttpClient.h
//  LandzipadApp
//
//  Created by ceyu on 16/3/28.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

///HTTP REQUEST METHOD TYPE
typedef NS_ENUM(NSInteger, HttpRequestType) {
    HttpRequestGet,
    HttpRequestPost,
    HttpRequestDelete,
    HttpRequestPut,
};

/**网络请求类*/
@interface HttpClient : NSObject
/**是否停止请求*/
@property (assign, nonatomic) BOOL suspended;
/**主路径*/
-(NSString *)baseURL;
-(void)setBaseURL:(NSString*)baseURL;

+ (HttpClient *)defaultClient;

/**
 *  HTTP请求（GET、POST、DELETE、PUT）
 *
 *  @param url        URL
 *  @param method     RESTFul请求类型
 *  @param parameters 请求参数
 *  @param success    请求成功处理块
 */
- (void)requestWithPath:(NSString *)url
                 method:(HttpRequestType)method
             parameters:(id)parameters
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *  task, NSError *  error))failure;

/**
 *  HTTP请求（HEAD）
 *
 *  @param url          URL
 *  @param parameters 请求参数
 *  @param success     请求成功处理块
 */
- (void)requestWithPathInHEAD:(NSString *)url
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task))success
                      failure:(void (^)(NSURLSessionDataTask *  task, NSError *  error))failure;

/**
 *  HTTP请求 上传图片
 *
 *  @param url          URL
 *  @param parameters 请求参数
 *  @param thumbDic      图片NSData 字典
 *  @param success  请求成功处理块
 */
- (void)requestWithPath:(NSString *)url
             parameters:(NSDictionary *)parameters
        thumbDictionary:(NSDictionary<NSString* , NSData*> *)thumbDic
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//判断当前网络状态
- (BOOL)isConnect;
@end
