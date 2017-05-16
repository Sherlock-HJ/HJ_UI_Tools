//
//  UserParameterObj.m
//  DingYouMing
//
//  Created by ceyu on 2017/2/27.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import "UserParameterObj.h"
#import "CDAccountTool.h"

@implementation UserParameterObj
+(instancetype)parameter{
    
    return [[self alloc]init];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        CDAccountObj *obj = [CDAccountTool account];
//        _token = obj.token;
        _user_id = obj.user_id;
    }
    return self;
}
-(BOOL)updateToken{
    CDAccountObj *obj = [CDAccountTool account];
//    _token = obj.token;
    _user_id = obj.user_id;
    return obj!=nil;
}
@end
