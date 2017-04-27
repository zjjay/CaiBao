//
//  AppDelegate+JPushSDK.h
//  
//
//  Created by LC on 2017/4/12.
//
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate (JPushSDK)<JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>
-(void)JPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end


