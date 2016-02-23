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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    HJPageControl *pageWhy = [[HJPageControl alloc]initWithFrame:CGRectMake(0, 330, 375, 30) style:WhyPageStyleRectangle];
    pageWhy.backgroundColor = [UIColor yellowColor];
    pageWhy.numberOfPages = 10;
    //    pageWhy.currentPage = 2;
    
    
    [self.view addSubview:pageWhy];

    // Do any additional setup after loading the view, typically from a nib.
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    HJSelectView *hjSV = [HJSelectView sharedHJSelectViewWithItems:@[@"sdf",@"sdf",@"sdf",@"sdf",@"sdf",@"sdf",@"sdf",@"sdf",@"sdf",@"sdf",@"sdf",@"dfd"] ];
    [hjSV showDidSelectRowBlock:^(NSInteger row) {
         NSLog(@"%ld",(long)row);
    }];
}
@end
