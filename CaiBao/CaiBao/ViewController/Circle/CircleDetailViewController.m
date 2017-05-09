//
//  CircleDetailViewController.m
//  CaiBao
//
//  Created by LC on 2017/4/10.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CircleDetailViewController.h"
#import "CircleViewModel.h"
#import "CircleDetailTableViewCell.h"
#import "CircleListModel.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "MJRefresh.h"
#import "OneCircleViewController.h"

@interface CircleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CircleDetailDelegate>
{
    MJRefreshNormalHeader *headerRefresh;
    MJRefreshBackStateFooter *footerRefresh;
    NSInteger page;
}
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation CircleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.circleModel) {
        self.title = self.circleModel.boardName;
    }else{
        self.title = self.titleName;
    }
    [self.view addSubview:self.tableView];
    
    if (![self.titleName isEqualToString:@"我的收藏"]) {
        WeakSelf(weakSelf);
        footerRefresh = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            NSString *urlStr;
            CircleListModel *model = [self.dataSource lastObject];
            if (self.circleModel) {
                urlStr = [NSString stringWithFormat:@"http://quanzi.caipiao.163.com/circle_getPosts.html?product=caipiao_client&mobileType=iphone&ver=4.32&channel=i4zhushou&apiVer=1.1&apiLevel=27&deviceId=27&boardId=%@&maxId=%@&sort=hot",self.circleModel.boardId,model.postId];
            }else{
                urlStr = [NSString stringWithFormat:@"http://quanzi.caipiao.163.com/circle_getHotPosts.html?product=caipiao_client&mobileType=iphone&ver=4.32&channel=i4zhushou&apiVer=1.1&apiLevel=27&deviceId=27&maxId=%@&sort=hot",model.postId];
            }
            
            [CircleViewModel DetailRequsetDataWithUrlStr:urlStr callback:^(NSArray *dataArray) {
                [weakSelf.dataSource addObjectsFromArray:dataArray];
                [weakSelf.tableView.mj_footer endRefreshing];
                [weakSelf.tableView reloadData];
                page++;
                
            }];
        }];
        
        self.tableView.mj_footer = footerRefresh;
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!headerRefresh) {
        WeakSelf(weakSelf);
        headerRefresh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            NSString *urlStr;
            if (self.circleModel) {
                urlStr = [NSString stringWithFormat:@"http://quanzi.caipiao.163.com/circle_getPosts.html?product=caipiao_client&mobileType=iphone&ver=4.32&channel=i4zhushou&apiVer=1.1&apiLevel=27&deviceId=27&boardId=%@&sort=hot",self.circleModel.boardId];
            }else{
                urlStr = [NSString stringWithFormat:@"http://quanzi.caipiao.163.com/circle_getHotPosts.html?product=caipiao_client&mobileType=iphone&ver=4.32&channel=i4zhushou&apiVer=1.1&apiLevel=27&deviceId=27&sort=hot"];
            }
            [CircleViewModel DetailRequsetDataWithUrlStr:urlStr callback:^(NSArray *dataArray) {
                if ([self.titleName isEqualToString:@"我的收藏"]) {
                    weakSelf.dataSource = [NSMutableArray array];
                    for (CircleListModel *model in dataArray) {
                        if ([model.likeCount intValue] > 0) {
                            model.like = @"1";
                            [weakSelf.dataSource addObject:model];
                        }
                    }
                }else{
                    
                    weakSelf.dataSource = [NSMutableArray arrayWithArray:dataArray];
                }
                
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView reloadData];
                page++;

            }];
        }];
        self.tableView.mj_header = headerRefresh;
        [self.tableView.mj_header beginRefreshing];
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        if (self.circleModel || [self.titleName isEqualToString:@"我的收藏"]) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT)];
        }else{
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - MAIN_BOTTOM_TABBAR_HEIGHT)];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];

        [_tableView registerClass:[CircleDetailTableViewCell class] forCellReuseIdentifier:@"cell"];
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
    CircleListModel *model = self.dataSource[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CircleDetailTableViewCell class] contentViewWidth:SCREEN_WIDTH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[CircleDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    CircleListModel *model = self.dataSource[indexPath.row];
    
    cell.model = model;
    cell.delegate = self;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleListModel *model = self.dataSource[indexPath.row];
    OneCircleViewController *circle = [OneCircleViewController new];
    circle.listModel = model;
    [self.navigationController pushViewController:circle animated:YES];
}

#pragma mark - CircleDetailDelegate
- (void)didClickUserNameInCell:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    CircleListModel *model = self.dataSource[index.row];
    OneCircleViewController *circle = [OneCircleViewController new];
    circle.listModel = model;
    [self.navigationController pushViewController:circle animated:YES];
}

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    __block CircleListModel *model = self.dataSource[index.row];
    
    NSInteger count = [model.likeCount integerValue];
    
    if (!model.like.length) {
        count++;
        model.like = @"1";
        [self showHint:@"点赞成功"];
    } else {
        if (count > 0) {
            count--;
        }
        model.like = @"";
        [self showHint:@"取消点赞"];
    }
    model.likeCount = [NSString stringWithFormat:@"%ld",count];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];

}

- (void)didClickCommentButtonInCell:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    CircleListModel *model = self.dataSource[index.row];
    OneCircleViewController *circle = [OneCircleViewController new];
    circle.listModel = model;
    [self.navigationController pushViewController:circle animated:YES];
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
