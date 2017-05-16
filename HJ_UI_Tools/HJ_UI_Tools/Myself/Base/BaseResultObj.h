//
//  BaseResultObj.h
//  YiXiXinCourier
//
//  Created by mac on 17/1/13.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseResultObj : NSObject

/**数组长度*/
@property (assign, nonatomic) NSInteger count;
/**数组*/
@property (copy, nonatomic) NSArray* list;

@property (assign, nonatomic) NSInteger err_code;

@property (copy, nonatomic) NSString* err_info;

+(instancetype)result;

@end
