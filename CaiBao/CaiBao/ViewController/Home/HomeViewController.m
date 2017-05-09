//
//  HomeViewController.m
//  CaiBao
//
//  Created by LC on 2017/5/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "HomeViewController.h"
#import "CircleDetailViewController.h"
#import "CircleViewController.h"
#import "RESideMenu.h"

@interface HomeViewController ()
{
    UIButton *button_hot;
    UIButton *button_all;
    CircleDetailViewController *hot;
    CircleViewController *all;
    CBViewController *currentVC;
}
@property (nonatomic ,strong) UIView *titleView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.titleView;
    
    UIImage *image = (USER(USERIMAGE) ? [UIImage imageWithData:USER(USERIMAGE)] : [UIImage imageNamed:@"userHead"]);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.layer.cornerRadius = 20;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button_hot.userInteractionEnabled = NO;
    [self addChildController];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeAvatar)
                                                 name:KNOTIFICATION_AVATAR
                                               object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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

- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 60, 20, 120, 44)];
        
        
        button_hot = [UIButton buttonWithType:UIButtonTypeCustom];
        button_hot.frame = CGRectMake(0, 7, 60, 30);
        [button_hot setTitle:@"热帖" forState:UIControlStateNormal];
        [button_hot setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button_hot.layer.borderWidth = 1;
        button_hot.layer.borderColor = Navi_Title_Color.CGColor;
        button_hot.backgroundColor = Navi_Title_Color;
        [button_hot addTarget:self action:@selector(touchButtonHot:) forControlEvents:UIControlEventTouchUpInside];
        button_hot.titleLabel.font = [UIFont systemFontOfSize:14];
        
        
        button_all = [UIButton buttonWithType:UIButtonTypeCustom];
        button_all.frame = CGRectMake(59, 7, 60, 30);
        [button_all setTitle:@"圈子" forState:UIControlStateNormal];
        [button_all setTitleColor:Navi_Title_Color forState:UIControlStateNormal];
        button_all.layer.borderWidth = 1;
        button_all.layer.borderColor = Navi_Title_Color.CGColor;
        [button_all addTarget:self action:@selector(touchButtonAll:) forControlEvents:UIControlEventTouchUpInside];
        button_all.titleLabel.font = [UIFont systemFontOfSize:14];
        
        
        
        [_titleView addSubview:button_hot];
        [_titleView addSubview:button_all];
    }
    return _titleView;
}

- (void)addChildController
{
    hot = [[CircleDetailViewController alloc] init];
    hot.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    [self addChildViewController:hot];
    
    
    all = [[CircleViewController alloc] init];
    all.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    [self addChildViewController:all];
    
    currentVC = hot;
    [self.view addSubview:hot.view];
}

- (void)touchButtonHot:(UIButton *)button
{
    button_hot.userInteractionEnabled = NO;
    button_all.userInteractionEnabled = YES;
    
    button_hot.backgroundColor = Navi_Title_Color;
    [button_hot setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    button_all.backgroundColor = [UIColor whiteColor];
    [button_all setTitleColor:Navi_Title_Color forState:UIControlStateNormal];
    
    
    [self transitionFromOldViewController:currentVC toNewViewController:hot];
}


- (void)touchButtonAll:(UIButton *)button
{
    button_all.userInteractionEnabled = NO;
    button_hot.userInteractionEnabled = YES;
    
    
    button_all.backgroundColor = Navi_Title_Color;
    [button_all setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    button_hot.backgroundColor = [UIColor whiteColor];
    [button_hot setTitleColor:Navi_Title_Color forState:UIControlStateNormal];
    
    
    [self transitionFromOldViewController:currentVC toNewViewController:all];
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
