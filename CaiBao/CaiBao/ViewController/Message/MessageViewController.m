//
//  MessageViewController.m
//  CaiBao
//
//  Created by LC on 2017/5/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "CommentViewController.h"
#import "LikeViewController.h"
#import "AiteViewController.h"
#import "SystemViewController.h"

#import "MyCommentViewController.h"


@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *images;
    NSArray *colors;
    NSArray *titles;
}
@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    
    images = @[@"message_notice",@"message_aite",@"message_like",@"message_comment"];
    colors = @[@"#62ABEE",@"#DC9573",@"#2E9573",@"#D8B413"];
    titles = @[@"系统通知",@"@我的",@"评论",@"喜欢"];
    [self.view addSubview:self.tableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - MAIN_BOTTOM_TABBAR_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//选择不变色

    cell.titleLabel.text = [titles objectAtIndex:indexPath.row];
    
    cell.backView.backgroundColor = [UIColor colorWithHexRGB:[colors objectAtIndex:indexPath.row]];
    cell.backView.layer.cornerRadius = 25;
    cell.backView.clipsToBounds = YES;
    
    cell.imageV.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MyCommentViewController *view = [[MyCommentViewController alloc] init];
        view.title = @"系统通知";
        [self.navigationController pushViewController:view animated:YES];
    }
    if (indexPath.row == 1) {
        CommentViewController *view = [[CommentViewController alloc] init];
        view.type = 2;
        [self.navigationController pushViewController:view animated:YES];
    }
    if (indexPath.row == 2) {
        CommentViewController *view = [[CommentViewController alloc] init];
        view.type = 3;
        [self.navigationController pushViewController:view animated:YES];
    }
    if (indexPath.row == 3) {
        CommentViewController *view = [[CommentViewController alloc] init];
        view.type = 4;
        [self.navigationController pushViewController:view animated:YES];

    }
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
