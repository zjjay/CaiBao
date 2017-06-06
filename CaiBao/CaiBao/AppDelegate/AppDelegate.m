//
//  AppDelegate.m
//  CaiBao
//
//  Created by LC on 2017/4/7.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+JPushSDK.h"
#import "CBJPushHelper.h"
#import "ViewController.h"
#import "LaunchViewController.h"
#import "LoginViewController.h"
#import "RESideMenu.h"
#import "LeftViewController.h"

@interface AppDelegate ()<RESideMenuDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //注册极光推送
    [self JPushApplication:application didFinishLaunchingWithOptions:launchOptions];
    [CBJPushHelper JPushSetTags:[NSSet set] Alias:@"caibao"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeRootViewController:)
                                                 name:KNOTIFICATION_LOGIN
                                               object:nil];
    
    LaunchViewController *viewController = [LaunchViewController new];
    viewController.callBack = ^(BOOL isSuccess, NSString *urlStr) {
        if (isSuccess) {
            ViewController *view = [[ViewController alloc] init];
            view.urlStr = urlStr;
            self.window.rootViewController = view;
        }else{
            [self changeRootViewController:nil];
        }
    };
    
    self.window.rootViewController = viewController;
    return YES;
}

- (void)changeRootViewController:(NSNotification *)sender
{
    
    if (sender.userInfo) {
        
        self.mainViewController = [[CBMainViewController alloc] init];
        
        LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
        
        RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:self.mainViewController
                                                                        leftMenuViewController:leftMenuViewController
                                                                       rightMenuViewController:nil];
        sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
        sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
        sideMenuViewController.delegate = self;
        sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
        sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
        sideMenuViewController.contentViewShadowOpacity = 1;
        sideMenuViewController.contentViewShadowRadius = 12;
        sideMenuViewController.contentViewShadowEnabled = YES;
        sideMenuViewController.contentViewScaleValue = 1;
        self.window.rootViewController = sideMenuViewController;

    }else{
        self.window.rootViewController = [LoginViewController new];
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}




#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}



@end


