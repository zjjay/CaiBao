//
//  CBJPushHelper.m
//  CaiBao
//
//  Created by LC on 2017/4/12.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBJPushHelper.h"
#import "JPUSHService.h"

@implementation CBJPushHelper

+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction
  advertisingIdentifier:(NSString *)advertisingId{
    // ios8之后可以自定义category
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
    [JPUSHService setupWithOption:launchingOption appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:advertisingId];
    return;
}

+ (void)registerDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    return;
}

+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion {
    [JPUSHService handleRemoteNotification:userInfo];
    
    if (completion)
    {
        completion(UIBackgroundFetchResultNewData);
    }
    return;
}

+ (void)JPushSetTags:(NSSet *)set Alias:(NSString *)alias
{
    [JPUSHService setTags:set
                    alias:alias
         callbackSelector:nil
                   object:self];
}

@end
