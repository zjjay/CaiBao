//
//  CBMainViewController.h
//  CaiBao
//
//  Created by LC on 2017/4/7.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBNavigationController.h"
#import "CBViewController.h"
#import "CustomTabBar.h"
typedef NS_ENUM(NSInteger, LBMainTabbarIndex) {
    kLBMainTabbarIndexHome = 0,
    kLBMainTabbarIndexNew,
    kLBMainTabbarIndexDiscovery,
    kLBMainTabbarIndexCircle
};
@interface CBMainViewController : CBNavigationController

@property (nonatomic) CustomTabBar *tabBar;
@property (nonatomic) CBViewController *currentViewController;
- (CBViewController *)viewControllerForTabbarIndex:(NSInteger)index;

@end
