//
//  PayCell.h
//  CiJi
//
//  Created by ceyu on 2016/11/28.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class payCellObj;
@interface PayCell : UITableViewCell
/**数据模型*/
@property (strong, nonatomic) payCellObj *payObj;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *payNameLab;
@property (weak, nonatomic) IBOutlet UILabel *payInfoLab;

@end
