//
//  payVC.m
//  CiJi
//
//  Created by ceyu on 2016/11/28.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "PayVC.h"
#import "PayCell.h"
#import "payCellObj.h"
#import "HttpClient.h"
#import "CDAccountTool.h"
#import "PayParamObj.h"
#import "UIView+HUD.h"

static NSString *cellName = @"PayCell";
@interface PayVC ()<UITableViewDataSource,UITableViewDelegate,UITableViewDataSourcePrefetching>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic)  NSArray *datas;
@property (strong, nonatomic)  UIAlertAction *sureAction;

@end

@implementation PayVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        _payParam = [PayParamObj parameter];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *datas = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"payCellDatas" ofType:@"plist"]];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *payDic in datas) {
        [array addObject:[payCellObj objectForDictionary:payDic]];
    }
    self.datas = array;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if ([UIDevice currentDevice].systemVersion.floatValue > 10.0) {
        self.tableView.prefetchDataSource = self;
    }
    [self.tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
    cell.payObj = self.datas[indexPath.row];
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self backAction];
    switch (indexPath.row) {
        case 0:
            [[PayTool sharePayTool] aliPayAction:_payParam];
            break;
        case 1:
            [self.view showHUDWithText:@"努力开发中~" hideDelay:2.0];

//            [[PayTool sharePayTool] wePayAction:_payParam];
            break;
    }
    
}
#pragma mark - UITableViewDataSourcePrefetching
- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    NSLog(@"%@",indexPaths);
}

#pragma mark - IBAction

- (IBAction)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
