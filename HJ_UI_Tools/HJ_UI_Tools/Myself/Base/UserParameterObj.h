//
//  UserParameterObj.h
//  DingYouMing
//
//  Created by ceyu on 2017/2/27.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserParameterObj : NSObject
///用户id
@property (strong, nonatomic) NSNumber* user_id;
///用户令牌
@property (strong, nonatomic) NSString* token;
///页码
@property (strong, nonatomic) NSNumber* page;

+(instancetype)parameter;
-(BOOL)updateToken;
@end
