//
//  ViewController.m
//  HJ_UI_Tools
//
//  Created by 吴宏佳 on 16/2/23.
//  Copyright © 2016年 吴宏佳. All rights reserved.
//

#import "ViewController.h"
#import "HJSelectView.h"
#import "HJPageControl.h"
#import "HJSudokuModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**页码控制器用法示例*/
    HJPageControl *pageWhy = [[HJPageControl alloc]initWithFrame:CGRectMake(0, 330, 375, 30) style:WhyPageStyleRectangle];
    pageWhy.backgroundColor = [UIColor yellowColor];
    pageWhy.numberOfPages = 10;
    //    pageWhy.currentPage = 2;
    
    
    [self.view addSubview:pageWhy];

/**九宫格用法示例*/
    [HJSudokuModel sudokuWithsudokuY:100 Width:100 height:20 column:3 total:8 block:^(CGRect frame, NSInteger index) {
        UILabel *lab = [[UILabel alloc]initWithFrame:frame];
        lab.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:lab];
    }];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    HJSelectView *hjSV = [HJSelectView sharedHJSelectViewWithItems:@[@"sdf",@"sdf",@"sdf",@"sdf",@"sdf",@"sdf",@"sdf",@"sdf",@"sdf",@"sdf",@"sdf",@"dfd"] ];
    [hjSV showDidSelectRowBlock:^(NSInteger row) {
         NSLog(@"%ld",(long)row);
    }];
}
@end
