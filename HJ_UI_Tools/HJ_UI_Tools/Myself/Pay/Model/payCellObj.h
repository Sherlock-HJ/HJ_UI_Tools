//
//  payCellObj.h
//  CiJi
//
//  Created by ceyu on 2016/11/30.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface payCellObj : NSObject

/**图片名*/
@property (copy, nonatomic) NSString* imgName;
/**支付商名*/
@property (copy, nonatomic) NSString* payName;
/**支付商简介*/
@property (copy, nonatomic) NSString* payInfo;


+ (instancetype)objectForDictionary:(NSDictionary *)dictionary;

@end
