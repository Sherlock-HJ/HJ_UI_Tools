//
//  PayParamObj.h
//  DingYouMing
//
//  Created by ceyu on 2017/3/3.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import "UserParameterObj.h"

@interface PayParamObj : UserParameterObj
/**订单关键字*/
@property (copy, nonatomic) NSString* subject;
/**总价*/
@property (copy, nonatomic) NSString* total_amount;
/**订单号*/
@property (copy, nonatomic) NSString* no;
@end
