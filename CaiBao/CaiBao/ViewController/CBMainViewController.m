//
//  CBMainViewController.m
//  CaiBao
//
//  Created by LC on 2017/4/7.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBMainViewController.h"
//#import "NewViewController.h"
#import "CircleViewController.h"
#import "MineViewController.h"
#import "PublishViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ContactViewController.h"

#import "ChatDemoHelper.h"
#define TAB_ITEM_NUM 4

@interface CBMainViewController ()<UITabBarDelegate, UINavigationControllerDelegate>

@end

@implementation CBMainViewController
{
    CBViewController *tabBarViewControllers[TAB_ITEM_NUM];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tabBar = [[CustomTabBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - MAIN_BOTTOM_TABBAR_HEIGHT, SCREEN_WIDTH, MAIN_BOTTOM_TABBAR_HEIGHT)];
    WeakSelf(weakSelf);
    self.tabBar.clickBlock = ^(){
        PublishViewController *plus = [[PublishViewController alloc]init];
        [weakSelf presentViewController:plus animated:YES completion:nil];
        
    };
    [self.tabBar setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexRGB:@"#2C2C2C"]]];
    self.tabBar.opaque = YES;

    self.tabBar.delegate = self;
    [self setupTabbarItems];
    self.tabBar.selectedItem = self.tabBar.items[0];
    
    self.currentViewController = [self viewControllerForTabbarIndex:0];
    self.delegate = self;
}

- (void)setCurrentViewController:(CBViewController *)currentViewController
{
    if (_currentViewController == currentViewController)
        return;
    
    _currentViewController = currentViewController;
    [self setViewControllers:@[_currentViewController] animated:NO];
    [_currentViewController.view addSubview:self.tabBar];
}

- (void)setupTabbarItems
{
    NSArray *images = @[@"tabbar_home", @"tabbar_new", @"tabbar_message", @"tabbar_circle"];
    
    NSArray *selectedImages =  @[@"tabbar_home_select", @"tabbar_new_select", @"tabbar_message_select", @"tabbar_circle_select"];
    
    NSArray *titles = @[@"首页", @"宝友", @"消息", @"我的"];
    
    NSMutableArray<UITabBarItem *> *items = [NSMutableArray array];
    for (NSInteger i = 0; i < titles.count; i++) {
        UIImage *image = [UIImage imageNamed:images[i]];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage *imageHL = [UIImage imageNamed:selectedImages[i]];
        imageHL = [imageHL imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem *item = [[UITabBarItem alloc]
                              initWithTitle:titles[i]
                              image:image
                              selectedImage:imageHL];
        item.tag = i;
        
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
        
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexRGB:@"#F4EA2A"]} forState:UIControlStateSelected];
        
        [items addObject:item];
    }
    
    self.tabBar.items = items;
    
}

- (CBViewController *)viewControllerForTabbarIndex:(NSInteger)index
{
    if (tabBarViewControllers[index]) {
        return tabBarViewControllers[index];
    }
    
    CBViewController *viewController;
    switch (index) {
        case 0: {
            viewController = [[HomeViewController alloc] init];
            break;
        }
        case 1: {
            viewController = [[ContactViewController alloc] init];
            break;
        }
        case 2 :{
            viewController = [[MessageViewController alloc] init];
            break;
        }
        case 3: {
            viewController = [[MineViewController alloc] init];
            break;
        }
            
        default:
            break;
    }
    
    tabBarViewControllers[index] = viewController;
    
    ContactListViewController *contactList = [[ContactListViewController alloc] init];
    [ChatDemoHelper shareHelper].contactListVC = contactList;
    ChatListViewController *chatList = [[ChatListViewController alloc] init];
    [ChatDemoHelper shareHelper].chatListVC = chatList;
    
    return viewController;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    CBViewController *targetVC = [self viewControllerForTabbarIndex:item.tag];
    if (self.currentViewController != targetVC) {
        self.currentViewController = targetVC;
    }
}


- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)setTabbarBadgeValue:(NSInteger)badge tabbarIndex:(LBMainTabbarIndex)tabbarIndex {
    self.tabBar.items[tabbarIndex].badgeValue = badge > 0 ? [NSString stringWithFormat:@"%ld", (long)badge] : nil;
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
