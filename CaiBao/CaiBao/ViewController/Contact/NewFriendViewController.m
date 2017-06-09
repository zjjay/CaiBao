//
//  NewFriendViewController.m
//  CaiBao
//
//  Created by LC on 2017/6/9.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "NewFriendViewController.h"
#import "NewFriendTableViewCell.h"
#import "InvitationManager.h"
static NewFriendViewController *controller = nil;


@interface NewFriendViewController ()

@end

@implementation NewFriendViewController

+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] initWithStyle:UITableViewStylePlain];
    });
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"好友申请";
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - MAIN_BOTTOM_TABBAR_HEIGHT);
    self.showRefreshHeader = YES;
    self.showRefreshFooter = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[NewFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [cell.acceptButton addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
    [cell.refuseButton addTarget:self action:@selector(refuse:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


//接受
- (void)accept:(UIButton *)button
{
    //获取当前选中cell
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    //同意好友申请
    [[EMClient sharedClient].contactManager approveFriendRequestFromUser:@"8001"
                                                              completion:^(NSString *aUsername, EMError *aError) {
                                                                  if (!aError) {
                                                                      NSLog(@"同意好友成功");
                                                                  }
                                                              }];
}

//拒绝
- (void)refuse:(UIButton *)button
{
    //拒绝好友申请
    [[EMClient sharedClient].contactManager declineFriendRequestFromUser:@"8001"
                                                              completion:^(NSString *aUsername, EMError *aError) {
                                                                  if (!aError) {
                                                                      NSLog(@"拒绝好友成功");
                                                                  }
                                                              }];
}


- (void)addNewApply:(NSDictionary *)dictionary
{
    if (dictionary && [dictionary count] > 0) {
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        ApplyStyle style = [[dictionary objectForKey:@"applyStyle"] intValue];
        
        if (applyUsername && applyUsername.length > 0) {
            for (int i = ((int)[self.dataArray count] - 1); i >= 0; i--) {
                ApplyEntity *oldEntity = [self.dataArray objectAtIndex:i];
                ApplyStyle oldStyle = [oldEntity.style intValue];
                if (oldStyle == style && [applyUsername isEqualToString:oldEntity.applicantUsername]) {
                    if(style != ApplyStyleFriend)
                    {
                        NSString *newGroupid = [dictionary objectForKey:@"groupname"];
                        if (newGroupid || [newGroupid length] > 0 || [newGroupid isEqualToString:oldEntity.groupId]) {
                            break;
                        }
                    }
                    
                    oldEntity.reason = [dictionary objectForKey:@"applyMessage"];
                    [self.dataArray removeObject:oldEntity];
                    [self.dataArray insertObject:oldEntity atIndex:0];
                    [self.tableView reloadData];
                    
                    return;
                }
            }
            
            //new apply
            ApplyEntity * newEntity= [[ApplyEntity alloc] init];
            newEntity.applicantUsername = [dictionary objectForKey:@"username"];
            newEntity.style = [dictionary objectForKey:@"applyStyle"];
            newEntity.reason = [dictionary objectForKey:@"applyMessage"];
            
            NSString *loginName = [[EMClient sharedClient] currentUsername];
            newEntity.receiverUsername = loginName;
            
            NSString *groupId = [dictionary objectForKey:@"groupId"];
            newEntity.groupId = (groupId && groupId.length > 0) ? groupId : @"";
            
            NSString *groupSubject = [dictionary objectForKey:@"groupname"];
            newEntity.groupSubject = (groupSubject && groupSubject.length > 0) ? groupSubject : @"";
            
            NSString *loginUsername = [[EMClient sharedClient] currentUsername];
            [[InvitationManager sharedInstance] addInvitation:newEntity loginUser:loginUsername];
            
            [self.dataArray insertObject:newEntity atIndex:0];
            [self.tableView reloadData];
            
        }
    }
}


- (void)loadDataSourceFromLocalDB
{
    [self.dataArray removeAllObjects];
    NSString *loginName = [self loginUsername];
    if(loginName && [loginName length] > 0)
    {
        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        [self.dataArray addObjectsFromArray:applyArray];
        
        [self.tableView reloadData];
    }
}

- (NSString *)loginUsername
{
    return [[EMClient sharedClient] currentUsername];
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
