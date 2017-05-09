//
//  CommentViewController.m
//  CaiBao
//
//  Created by LC on 2017/5/9.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CommentViewController.h"
#import "MJRefresh.h"
#import "OneCircleTableViewCell.h"
#import "OneCircleModel.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CircleViewModel.h"
#import "LikeTableViewCell.h"

@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MJRefreshNormalHeader *headerRefresh;
    MJRefreshBackStateFooter *footerRefresh;
    NSInteger page;
}
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic ,strong) UITableView *tableView;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == 3) {
        self.title = @"评论";
    }
    
    if (self.type == 2) {
        self.title = @"@我的";
    }

    if (self.type == 4) {
        self.title = @"喜欢";
    }
    [self.view addSubview:self.tableView];

}

- (void)viewDidAppear:(BOOL)animated
{
    if (!headerRefresh) {
        WeakSelf(weakSelf);
        headerRefresh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            NSArray *array = @[@"2752793",@"2754109",@"2752270"];
            page = 1;
            NSString *urlStr = [NSString stringWithFormat:@"http://quanzi.caipiao.163.com/circle_postInfo.html?product=caipiao_client&mobileType=iphone&ver=4.32&channel=i4zhushou&apiVer=1.1&apiLevel=27&deviceId=278&postId=%@",[array objectAtIndex:self.type - 2]];
            [CircleViewModel OneRequsetDataWithUrlStr:urlStr callback:^(NSArray *dataArray) {
                
                weakSelf.dataSource = [NSMutableArray arrayWithArray:dataArray];
                [weakSelf.tableView.mj_header endRefreshing];
                page++;
                [weakSelf.tableView reloadData];
            }];
        }];
        self.tableView.mj_header = headerRefresh;
        [self.tableView.mj_header beginRefreshing];
    }
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[OneCircleTableViewCell class] forCellReuseIdentifier:@"onecell"];
        [_tableView registerNib:[UINib nibWithNibName:@"LikeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 4 || self.type == 2) {
        return 60;
    }
    OneCircleModel *model = self.dataSource[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"circleModel" cellClass:[OneCircleTableViewCell class] contentViewWidth:SCREEN_WIDTH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 3) {
        OneCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecell"];
        if (cell == nil) {
            cell = [[OneCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"onecell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//选择不变色
        OneCircleModel *model = self.dataSource[indexPath.row];
        cell.level = [NSString stringWithFormat:@"%ld",indexPath.row + 2];
        cell.circleModel = model;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
    
    if (self.type == 4 || self.type == 2) {
        LikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[LikeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//选择不变色
        OneCircleModel *model = self.dataSource[indexPath.row];

        
        cell.nameL.text = model.replyerNickName;
        
        cell.timeL.text = model.createTime;
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.replyerAvatarUrl] placeholderImage:[UIImage imageNamed:@"avatar"]];
        cell.imageV.layer.cornerRadius = 20;
        cell.imageV.clipsToBounds = YES;
        
        return cell;
    }
    
    
    
    return nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
