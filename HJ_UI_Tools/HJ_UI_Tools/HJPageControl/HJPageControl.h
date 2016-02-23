//
//  WhyPageControl.h
//  why封装的小UI工具
//
//  Created by ma c on 15/11/7.
//  Copyright (c) 2015年 bjsxt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_CLASS_AVAILABLE_IOS(2_0)@interface HJPageControl : UIControl

typedef NS_ENUM(NSInteger, WhyPageStyle) {
    WhyPageStyleNone,//默认从0开始
    WhyPageStyleLong,
    WhyPageStyleBigOrSmall,
    WhyPageStyleRectangle,
};
/**页码总数*/
@property(nonatomic) NSInteger numberOfPages;
/**当前页码序数*/
@property(nonatomic) NSInteger currentPage;
/**是否隐藏页码标示符*/
@property(nonatomic) BOOL hidesForSinglePage;
/**其他页码颜色*/
@property(nonatomic,retain) UIColor *pageIndicatorTintColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
/**当前页码颜色*/
@property(nonatomic,retain) UIColor *currentPageIndicatorTintColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;


-(instancetype)initWithFrame:(CGRect)frame style:(WhyPageStyle)style;

@end
