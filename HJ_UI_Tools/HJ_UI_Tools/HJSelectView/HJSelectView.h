//
//  HJSelectView.h
//  HJSelectViewController
//
//  Created by 吴宏佳 on 16/2/6.
//  Copyright © 2016年 吴宏佳. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^didSelectRowBlock)(NSInteger row);
@interface HJSelectView : UIView

+(instancetype)sharedHJSelectViewWithItems:( NSArray*)items didSelectRowBlock:(didSelectRowBlock)blcok;

- (void)show;
@end
