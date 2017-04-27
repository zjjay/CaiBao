//
//  CBNavigationController.m
//  CaiBao
//
//  Created by LC on 2017/4/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBNavigationController.h"

@interface CBNavigationController ()

@end

@implementation CBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *array = @[@"#50A260",@"#1C4F82",@"#3694DA",@"#58534C",@"#E93F33",@"#EC6252",@"#EC62C5",@"#7962C5",@"#796200",@"#5B0000"];
    
    self.navigationBar.barTintColor = [UIColor colorWithHexRGB:[array objectAtIndex:[NavigationColor integerValue]]];

    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor  whiteColor]}];

 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return self.topViewController.prefersStatusBarHidden;
}


//FIXME:这样做防止主界面卡顿时，导致一个ViewController被push多次
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (self.childViewControllers.count > 0) {
//        if ([[self.childViewControllers lastObject] isKindOfClass:[viewController class]]) {
//            return;
//        }
//    }
    
    [super pushViewController:viewController animated:animated];
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
