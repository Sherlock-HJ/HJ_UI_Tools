//
//  HJPageControl.m
//
//
//  Created by ma c on 15/11/7.
//  Copyright (c) 2015年 bjsxt. All rights reserved.
//

#import "HJPageControl.h"
@interface HJPageControl ()
{
    UIView *pageBackgroundView;
    CGFloat pageW,pageH,pageS,currentPageW,currentPageH;
    CGRect pageBackgroundFrame;
    NSMutableArray *_indicatorsArr;
    NSTimeInterval time;
    BOOL cornerRadius;
}
@end
//
@implementation HJPageControl
-(instancetype)initWithFrame:(CGRect)frame style:(WhyPageStyle)style
{
    if (self = [super initWithFrame:frame]) {
        pageBackgroundFrame = frame;
        cornerRadius = YES;
        switch (style) {
            case WhyPageStyleNone:
                currentPageW = 10;
                currentPageH = 10;
                pageW = 10;
                pageH = 10;
                break;
            case WhyPageStyleLong:
                currentPageW = 20;
                currentPageH = 10;
                pageW = 20;
                pageH = 10;
                break;
            case WhyPageStyleBigOrSmall:
                currentPageW = 20;
                currentPageH = 20;
                pageW = 10;
                pageH = 10;
                break;
            case WhyPageStyleRectangle:
                currentPageW = 10;
                currentPageH = 5;
                pageW = 10;
                pageH = 10;
                cornerRadius = NO;
                break;
        }
        pageS = 10;
        time = 0.1;
        _indicatorsArr = [NSMutableArray array];
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    pageBackgroundView = [[UIView alloc]init];
    [self addSubview:pageBackgroundView];
}
//
#pragma mark - set方法设置whyPageControl属性

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    //
    pageBackgroundView.frame = CGRectMake(0, 0, (pageW + pageS) * (numberOfPages+1), pageH);
    pageBackgroundView.center = CGPointMake(pageBackgroundFrame.size.width/2, pageBackgroundFrame.size.height/2);
    //
    for (int i = 0; i < numberOfPages; i++) {
        UIView *pageView = [[UIView alloc]init];
        [pageBackgroundView addSubview:pageView];
        [_indicatorsArr addObject:pageView];
    }
    [self animatePage:0];
}
//
- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    //
    if (_indicatorsArr.count == 0) {
        return;
    }
    [self animatePage:[self currentPageU:currentPage]];
}
///
- (NSInteger)currentPageU:(NSInteger)currentPage
{
    if (currentPage >= self.numberOfPages - 1) {
        currentPage = self.numberOfPages - 1;
    }else if (currentPage <= 0){
        currentPage = 0;
    }else{
        currentPage = currentPage;
    }
    return currentPage;
}
#pragma mark - 点击结束触发手势方法

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (point.x > pageBackgroundFrame.size.width/2) {
        self.currentPage++;
        [self animatePage:self.currentPage = [self currentPageU:self.currentPage]];
    }else{
        self.currentPage--;
        [self animatePage:self.currentPage = [self currentPageU:self.currentPage]];
    }
    
    NSLog(@"%d",self.currentPage);
}

#pragma mark - page动起来

-(void)animatePage:(NSInteger)currentPage
{
    [UIView animateWithDuration:time animations:^{
        
        CGFloat X = 0.0;
        for (int i =0; i < _indicatorsArr.count; i++) {
            UIView *pageView = _indicatorsArr[i];
            if (i == 0) {
                X = 0.0;
            }
            if (i == currentPage) {
                pageView.frame = CGRectMake(X + pageS, -(currentPageH - pageH)/2, currentPageW, currentPageH);
                if (cornerRadius) {
                    [pageView.layer setCornerRadius:currentPageH/2];
                }
                pageView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
            }else{
                pageView.frame = CGRectMake(X +pageS, 0, pageW, pageH);
                if (cornerRadius) {
                    [pageView.layer setCornerRadius:pageH/2];
                }
                pageView.backgroundColor = [UIColor blackColor];
            }
            X = CGRectGetMaxX(pageView.frame);
        }
    }];
    
}
@end
