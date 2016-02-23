//
//  ViewController.m
//  HJ_UI_Tools
//
//  Created by 吴宏佳 on 16/2/23.
//  Copyright © 2016年 吴宏佳. All rights reserved.
//

#import "ViewController.h"
#import "HJSelectView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    HJSelectView *hjSV = [HJSelectView sharedHJSelectViewWithItems:@[@"sdf",@"dfd"] didSelectRowBlock:^(NSInteger row) {
        NSLog(@"%ld",(long)row);
    }];
    [hjSV show];
}
@end
