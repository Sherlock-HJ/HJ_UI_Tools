//
//  payCellObj.m
//  CiJi
//
//  Created by ceyu on 2016/11/30.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "payCellObj.h"

@implementation payCellObj
+ (instancetype)objectForDictionary:(NSDictionary *)dictionary{
    
    return [[self alloc]initWithDictionary:dictionary];
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
@end
