//
//  OneCircleViewController.m
//  CaiBao
//
//  Created by LC on 2017/4/12.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "OneCircleViewController.h"
#import "MJRefresh.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CircleListModel.h"
#import "CircleDetailTableViewCell.h"
#import "OneCircleTableViewCell.h"
#import "OneCircleModel.h"
#import "CircleViewModel.h"

@interface OneCircleViewController ()<UITableViewDelegate,UITableViewDataSource,CircleDetailDelegate,UITextFieldDelegate>
{
    MJRefreshNormalHeader *headerRefresh;
    MJRefreshBackStateFooter *footerRefresh;
    NSInteger page;
}
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UITextField *textField;

@end

@implementation OneCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"举报" style:UIBarButtonItemStylePlain target:self action:@selector(jvbao)];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.textField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];//在这里注册通知
    
    WeakSelf(weakSelf);
    footerRefresh = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        OneCircleModel *model = [self.dataSource lastObject];
        
        NSString *urlStr = [NSString stringWithFormat:@"http://quanzi.caipiao.163.com/circle_postInfo.html?product=caipiao_client&mobileType=iphone&ver=4.32&channel=i4zhushou&apiVer=1.1&apiLevel=27&deviceId=278&includeLast=0&lastId=%@&postId=%@",model.commentId,self.listModel.postId];
        [CircleViewModel OneRequsetDataWithUrlStr:urlStr callback:^(NSArray *dataArray) {
            
            [weakSelf.dataSource addObjectsFromArray:dataArray];
            [weakSelf.tableView.mj_footer endRefreshing];
            page++;
            [weakSelf.tableView reloadData];
        }];
    }];
    
    self.tableView.mj_footer = footerRefresh;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!headerRefresh) {
        WeakSelf(weakSelf);
        headerRefresh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            NSString *urlStr = [NSString stringWithFormat:@"http://quanzi.caipiao.163.com/circle_postInfo.html?product=caipiao_client&mobileType=iphone&ver=4.32&channel=i4zhushou&apiVer=1.1&apiLevel=27&deviceId=278&postId=%@",self.listModel.postId];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TEXTFIELD_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[CircleDetailTableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerClass:[OneCircleTableViewCell class] forCellReuseIdentifier:@"onecell"];
    }
    return _tableView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TEXTFIELD_HEIGHT, SCREEN_WIDTH, TEXTFIELD_HEIGHT)];
        _textField.placeholder = @"说点什么吧。。。";
        _textField.returnKeyType = UIReturnKeySend;
        _textField.delegate = self;
        _textField.backgroundColor = CB_rgb(222, 222, 222);
    }
    return _textField;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self.tableView cellHeightForIndexPath:indexPath model:self.listModel keyPath:@"model" cellClass:[CircleDetailTableViewCell class] contentViewWidth:SCREEN_WIDTH];
    }else{
        OneCircleModel *model = self.dataSource[indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"circleModel" cellClass:[OneCircleTableViewCell class] contentViewWidth:SCREEN_WIDTH];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CircleDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[CircleDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.model = self.listModel;
        cell.delegate = self;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }else{
        OneCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecell"];
        if (cell == nil) {
            cell = [[OneCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"onecell"];
        }
        
        OneCircleModel *model = self.dataSource[indexPath.row];
        cell.level = [NSString stringWithFormat:@"%ld",indexPath.row + 2];
        cell.circleModel = model;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
}

#pragma mark - CircleDetailDelegate
- (void)didClickUserNameInCell:(UITableViewCell *)cell
{
    
}

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell
{
    NSInteger count = [self.listModel.likeCount integerValue];
    if (!self.listModel.like.length) {
        count++;
        self.listModel.like = @"1";
        [self showHint:@"点赞成功"];

    } else {
        if (count > 0) {
            count--;
        }
        self.listModel.like = @"";
        [self showHint:@"取消点赞"];

    }
    self.listModel.likeCount = [NSString stringWithFormat:@"%ld",count];
    [self.tableView reloadData];
}

- (void)didClickCommentButtonInCell:(UITableViewCell *)cell
{
    [self.textField becomeFirstResponder];
}

#pragma mark - 键盘

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (!textField.text.length) {
        [self.textField endEditing:YES];
        return YES;
    }
    OneCircleModel *lastModel = [self.dataSource lastObject];
    OneCircleModel *model = [[OneCircleModel alloc]init];
    model.replyerNickName = USER(USERTITLE) ? USER(USERTITLE) : @"遗失的记忆";
    model.replyerAvatarUrl = lastModel.replyerAvatarUrl;
    model.replyerUserId = lastModel.replyerUserId;
    model.text = textField.text;
    model.commentId = lastModel.commentId;
    model.createTime = [self currentTime];
    
    [self.textField endEditing:YES];
    textField.text = @"";
    
    [self.dataSource addObject:model];
    [self.tableView reloadData];
    [self showHint:@"发送成功"];
    
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.textField.frame = CGRectMake(0, SCREEN_HEIGHT - TEXTFIELD_HEIGHT, SCREEN_WIDTH, TEXTFIELD_HEIGHT);
        } else {
            self.textField.frame = CGRectMake(0, keyboardF.origin.y - TEXTFIELD_HEIGHT, SCREEN_WIDTH, TEXTFIELD_HEIGHT);
        }
    }];
}

- (void)jvbao
{
    [CBAlertHelper alertWithTitle:@"举报已提交" message:nil actionName:@"确定" viewController:self action:^{
        
    }];
}

- (NSString *)currentTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:KNOTIFICATION_AVATAR];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillChangeFrameNotification];
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
