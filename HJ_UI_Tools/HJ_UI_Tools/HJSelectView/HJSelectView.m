//
//  HJSelectView.m
//  HJSelectViewController
//
//  Created by 吴宏佳 on 16/2/6.
//  Copyright © 2016年 吴宏佳. All rights reserved.
//

#import "HJSelectView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HJSelectView ()<UITableViewDataSource,UITableViewDelegate>

@property (copy , nonatomic) NSArray* items;

@property (strong , nonatomic) didSelectRowBlock didselectBlock;

@end

@implementation HJSelectView
+(instancetype)sharedHJSelectViewWithItems:(NSArray*)items
{
        return [[self alloc]initWithItems:items];
}

- (instancetype)initWithItems:(NSArray*)items
{
    self = [super init];
    if (self) {
        self.items = items;

        self.frame =[UIScreen mainScreen].bounds;
        
        UIButton *grayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:grayBtn];
        
        grayBtn.frame =[UIScreen mainScreen].bounds;
        grayBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [grayBtn addTarget:self action:@selector(tapEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat tableHeight = [items count] * 44 < (HEIGHT - 140)?[items count ] * 44:(HEIGHT - 140);
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 70, WIDTH - 40, tableHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:tableView];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [tableView.layer setCornerRadius:10.0];
        
    }
    return self;
}


#pragma mark - tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *hjSelect = @"hjSelect";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:hjSelect];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hjSelect];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.items[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self removeFromSuperview];

    if (self.didselectBlock) {
        self.didselectBlock(indexPath.row);

    }
}

- (void)tapEvent:(id)event
{
    [self removeFromSuperview];
}

- (void)showDidSelectRowBlock:(didSelectRowBlock)blcok
{
    [ [ [ UIApplication  sharedApplication ]  keyWindow ] addSubview : self ] ;
    self.didselectBlock = blcok;
}
@end
