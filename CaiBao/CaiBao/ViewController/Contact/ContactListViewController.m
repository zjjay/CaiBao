//
//  ContactListViewController.m
//  CaiBao
//
//  Created by LC on 2017/6/9.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "ContactListViewController.h"
#import "NewFriendViewController.h"
#import "GroupListViewController.h"


@interface ContactListViewController ()

@property (nonatomic ,strong) NSMutableArray *contactArray;

@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - MAIN_BOTTOM_TABBAR_HEIGHT);
    self.showRefreshHeader = YES;
    
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return self.contactArray.count - 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = self.contactArray[indexPath.row];

    }else{
        cell.imageView.image = [UIImage imageNamed:Launch];
        cell.textLabel.text = self.contactArray[indexPath.row - 2];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NewFriendViewController *newFriend = [[NewFriendViewController alloc] init];
            newFriend.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newFriend animated:YES];
        }
        if (indexPath.section == 1) {
            GroupListViewController *groupList = [[GroupListViewController alloc] init];
            groupList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:groupList animated:YES];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除好友
        [[EMClient sharedClient].contactManager deleteContact:@"8001"
                                         isDeleteConversation: YES
                                                   completion:^(NSString *aUsername, EMError *aError) {
                                                       if (!aError) {
                                                           NSLog(@"删除成功");
                                                       }
                                                   }];
    }
}



//刷新
- (void)tableViewDidTriggerHeaderRefresh
{
    //从服务器获取所有的好友
    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        if (!aError) {
            [self.contactArray removeAllObjects];
            
            [self.contactArray addObjectsFromArray:@[@"新的朋友",@"群聊"]];
            [self.contactArray addObjectsFromArray:aList];

            NSLog(@"22 %@",aList);
            NSLog(@"获取成功");
        }
    }];
    //从数据库获取所有的好友
    NSArray *userlist = [[EMClient sharedClient].contactManager getContacts];
    NSLog(@"11 %@",userlist);
    [self.contactArray addObjectsFromArray:userlist];
    [self.tableView reloadData];
    [self tableViewDidFinishTriggerHeader:YES reload:NO];

}


- (NSMutableArray *)contactArray
{
    if (!_contactArray) {
        _contactArray = [NSMutableArray array];
    }
    return _contactArray;
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
