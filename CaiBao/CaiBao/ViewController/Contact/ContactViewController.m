//
//  ContactViewController.m
//  CaiBao
//
//  Created by LC on 2017/6/9.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "ContactViewController.h"
#import "ChatListViewController.h"
#import "ContactListViewController.h"

@interface ContactViewController ()
{
    UIButton *button_chat;
    UIButton *button_contact;
    ChatListViewController *chat;
    ContactListViewController *contact;
    CBViewController *currentVC;
}
@property (nonatomic ,strong) UIView *titleView;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.titleView;
    
    button_chat.userInteractionEnabled = NO;
    [self addChildController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 60, 20, 120, 44)];
        
        
        button_chat = [UIButton buttonWithType:UIButtonTypeCustom];
        button_chat.frame = CGRectMake(0, 7, 60, 30);
        [button_chat setTitle:@"消息" forState:UIControlStateNormal];
        [button_chat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button_chat.layer.borderWidth = 1;
        button_chat.layer.borderColor = Navi_Title_Color.CGColor;
        button_chat.backgroundColor = Navi_Title_Color;
        [button_chat addTarget:self action:@selector(touchButtonHot:) forControlEvents:UIControlEventTouchUpInside];
        button_chat.titleLabel.font = [UIFont systemFontOfSize:14];
        
        
        button_contact = [UIButton buttonWithType:UIButtonTypeCustom];
        button_contact.frame = CGRectMake(59, 7, 60, 30);
        [button_contact setTitle:@"通讯录" forState:UIControlStateNormal];
        [button_contact setTitleColor:Navi_Title_Color forState:UIControlStateNormal];
        button_contact.layer.borderWidth = 1;
        button_contact.layer.borderColor = Navi_Title_Color.CGColor;
        [button_contact addTarget:self action:@selector(touchButtonAll:) forControlEvents:UIControlEventTouchUpInside];
        button_contact.titleLabel.font = [UIFont systemFontOfSize:14];
        
        
        
        [_titleView addSubview:button_chat];
        [_titleView addSubview:button_contact];
    }
    return _titleView;
}

- (void)addChildController
{
    chat = [[ChatListViewController alloc] init];
    chat.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    [self addChildViewController:chat];
    
    
    contact = [[ContactListViewController alloc] init];
    contact.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    [self addChildViewController:contact];
    
    currentVC = chat;
    [self.view addSubview:chat.view];
}

- (void)touchButtonHot:(UIButton *)button
{
    button_chat.userInteractionEnabled = NO;
    button_contact.userInteractionEnabled = YES;
    
    button_chat.backgroundColor = Navi_Title_Color;
    [button_chat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    button_contact.backgroundColor = [UIColor whiteColor];
    [button_contact setTitleColor:Navi_Title_Color forState:UIControlStateNormal];
    
    
    [self transitionFromOldViewController:currentVC toNewViewController:chat];
}


- (void)touchButtonAll:(UIButton *)button
{
    button_contact.userInteractionEnabled = NO;
    button_chat.userInteractionEnabled = YES;
    
    
    button_contact.backgroundColor = Navi_Title_Color;
    [button_contact setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    button_chat.backgroundColor = [UIColor whiteColor];
    [button_chat setTitleColor:Navi_Title_Color forState:UIControlStateNormal];
    
    
    [self transitionFromOldViewController:currentVC toNewViewController:contact];
}


//转换子视图控制器
- (void)transitionFromOldViewController:(CBViewController *)oldViewController toNewViewController:(CBViewController *)newViewController{
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.25 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            currentVC = newViewController;
        }else{
            currentVC = oldViewController;
        }
    }];
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
