//
//  CBMainViewController.m
//  CaiBao
//
//  Created by LC on 2017/4/7.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBMainViewController.h"
#import "HomeViewController.h"
#import "NewViewController.h"
#import "CircleViewController.h"
#import "CircleDetailViewController.h"
#import "MineViewController.h"
#import "PublishViewController.h"

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
    
//    NSArray *array = @[@"#50A260",@"#1C4F82",@"#3694DA",@"#58534C",@"#E93F33",@"#EC6252",@"#EC62C5",@"#7962C5",@"#796200",@"#5B0000"];
//    
//    self.naviBackView.backgroundColor = [UIColor colorWithHexRGB:[array objectAtIndex:[NavigationColor integerValue]]];
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

- (void)setupTabbarItems {
    NSArray *images = @[@"tabbar_home", @"tabbar_new", @"tabbar_discover", @"tabbar_circle"];
    
    NSArray *selectedImages =  @[@"tabbar_home_select", @"tabbar_new_select", @"tabbar_discover_select", @"tabbar_circle_select"];
    
    NSArray *titles = @[@"热帖", @"圈子", @"资讯", @"我的"];
    
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
            viewController = [[CircleDetailViewController alloc] init];
            break;
        }
        case 1: {
            viewController = [[CircleViewController alloc] init];
            break;
        }
        case 2 :{
            viewController = [[NewViewController alloc] init];
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