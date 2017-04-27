//
//  CircleViewController.m
//  CaiBao
//
//  Created by LC on 2017/4/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CircleViewController.h"
#import "CircleViewModel.h"
#import "CircleTableViewCell.h"
#import "CirclrModel.h"
#import "MJRefresh.h"
#import "CircleDetailViewController.h"
#import "RESideMenu.h"

@interface CircleViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CircleViewModel *viewModel;
    MJRefreshNormalHeader *headerRefresh;

}
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"圈子";
    UIImage *image = (USER(USERIMAGE) ? [UIImage imageWithData:USER(USERIMAGE)] : [UIImage imageNamed:@"userHead"]);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.layer.cornerRadius = 20;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeAvatar)
                                                 name:KNOTIFICATION_AVATAR
                                               object:nil];
    [self.view addSubview:self.tableView];
}

- (void)changeAvatar
{
    UIImage *image = (USER(USERIMAGE) ? [UIImage imageWithData:USER(USERIMAGE)] : [UIImage imageNamed:@"userHead"]);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.layer.cornerRadius = 20;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
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
            [CircleViewModel requsetDataWithUrlStr:@"http://quanzi.caipiao.163.com/circle_getBoardList.html?product=caipiao_client&mobileType=iphone&ver=4.32&channel=i4zhushou&apiVer=1.1&apiLevel=27&deviceId=27" callback:^(NSArray *dataArray) {
                weakSelf.dataSource = [NSMutableArray arrayWithArray:dataArray];
                [self.tableView.mj_header endRefreshing];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - MAIN_BOTTOM_TABBAR_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerNib:[UINib nibWithNibName:@"CircleTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

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
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[CircleTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    CirclrModel *model = self.dataSource[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.boardIconUrl] placeholderImage:[UIImage imageNamed:@""]];
    cell.titleLabel.text = model.boardName;
    cell.peopleLabel.text = [NSString stringWithFormat:@"人数:%@",model.peopleNum];
    cell.postLabel.text = [NSString stringWithFormat:@"帖子:%@",model.postsNum];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CirclrModel *model = self.dataSource[indexPath.row];
    CircleDetailViewController *detail = [[CircleDetailViewController alloc] init];
    detail.circleModel = model;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:KNOTIFICATION_AVATAR];
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
