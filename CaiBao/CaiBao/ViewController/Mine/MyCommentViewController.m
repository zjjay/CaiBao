//
//  MyCommentViewController.m
//  CaiBao
//
//  Created by LC on 2017/4/18.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "MyCommentViewController.h"

@interface MyCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *footView;
@end

@implementation MyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.footView;
    }
    return _tableView;
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 0, 150, 150)];
        imageV.image = [UIImage imageNamed:@"foundNOContent"];
        [_footView addSubview:imageV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, 180, 200, 20)];
        label.text = @"没有相关内容";
        label.font = [UIFont systemFontOfSize:14.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        [_footView addSubview:label];
    }
    return _footView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
//    cell.imageView.image = [UIImage imageNamed:[imageArray[indexPath.section] objectAtIndex:indexPath.row]];
//    cell.textLabel.text = [titleArray[indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
