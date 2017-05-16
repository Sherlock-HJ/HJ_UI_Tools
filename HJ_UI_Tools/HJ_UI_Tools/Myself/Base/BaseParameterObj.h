//
//  BaseParameterObj.h
//  DingYouMing
//
//  Created by ceyu on 2017/2/22.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseParameterObj : NSObject
///页码
@property (strong, nonatomic) NSNumber* page;

+(instancetype)parameter;

@end
