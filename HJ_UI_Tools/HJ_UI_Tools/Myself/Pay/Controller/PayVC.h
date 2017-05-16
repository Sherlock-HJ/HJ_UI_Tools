//
//  payVC.h
//  CiJi
//
//  Created by ceyu on 2016/11/28.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayParamObj.h"
#import "PayTool.h"

@interface PayVC :UIViewController
/**支付对象*/
@property (readonly, nonatomic) PayParamObj* payParam;

@end
