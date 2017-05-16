//
//  PayTool.h
//  DingYouMing
//
//  Created by ceyu on 2017/3/8.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayParamObj.h"

@protocol PayToolDelegate <NSObject>
@optional
-(void)payResultWithErrorCode:(NSInteger)errorCode withErrorInfo:(NSString *)errorInfo withObject:(id)object;//
-(void)payBeginWithObject:(id)object;//

@end

@interface PayTool : NSObject

/**代理*/
@property (weak, nonatomic) id<PayToolDelegate> delegate;

@property (strong, nonatomic) id object;


+(instancetype)sharePayTool;

-(void)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options;

-(void)aliPayAction:(PayParamObj*)param;

-(void)wePayAction:(PayParamObj*)param;

///支付确认结果
-(void)payVerifyResults;
@end
