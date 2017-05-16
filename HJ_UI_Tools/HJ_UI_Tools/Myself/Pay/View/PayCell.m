//
//  PayCell.m
//  CiJi
//
//  Created by ceyu on 2016/11/28.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "PayCell.h"
#import "payCellObj.h"

@implementation PayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setPayObj:(payCellObj *)payObj{
    _payObj = payObj;
    
    self.payNameLab.text = payObj.payName;
    self.payInfoLab.text = payObj.payInfo;
    self.imgView.image = [UIImage imageNamed:payObj.imgName];
}
@end
