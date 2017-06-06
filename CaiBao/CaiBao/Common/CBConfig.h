//
//  CBConfig.h
//  CaiBao
//
//  Created by LC on 2017/4/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#ifndef CBConfig_h
#define CBConfig_h

#define is_IPHONE4 (([[UIScreen mainScreen]bounds].size.height < 568)?YES:NO)
#define is_IPHONE5 (([[UIScreen mainScreen]bounds].size.height == 568)?YES:NO)
#define is_IPHONE6 (([[UIScreen mainScreen]bounds].size.height > 568)?YES:NO)

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define NAVIGATION_BAR_HEIGHT 64
#define MAIN_BOTTOM_TABBAR_HEIGHT 49
#define TEXTFIELD_HEIGHT 40


#define CB_hexColor(colorV)   [UIColor colorWithHexColorString:@#colorV]
#define CB_rgb(r,g,b)    [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define CB_rgba(r,g,b,a)    [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:a]
#define CB_rgb_hex(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ALLVIEWBACKCOLOR          CB_rgb(239, 238, 244)

#define Navi_Title_Color          CB_rgb(15, 136, 235)




#define  WeakSelf(x)   __weak typeof(*&self)x = self

#define USER(x) [[NSUserDefaults standardUserDefaults] objectForKey:x]
#define KNOTIFICATION_LOGIN     @"caibaologin"
#define KNOTIFICATION_NetWork     @"network"

#define KNOTIFICATION_AVATAR    @"userAvatar"
#define USERNAME                @"username"
#define PASSWORD                @"password"
#define USERIMAGE               @"userAvatar"
#define USERTITLE               @"usertitle"

#define QQAPPID                 @"101393519"
#define QQAPPKey                @"5b7374f4df3e0b777639c0a173b2f23e"
#define QQURL                   @"https://www.shiyanlou.com/"



#if CB157

#define JPushAppKey              @"7a55bf8e27dcc6b3039321e4"
#define Appid                    @"157"
#define Launch                   @"launch1"
#define LoginBackImage           @"loginbackground12"
#define MyBackIamge              @"mybackimage2"
#define NavigationColor          @"0"



#elif CB227

#define JPushAppKey              @"73c9ac2e28039bcea710257e"
#define Appid                    @"227"
#define Launch                   @"launch2"
#define LoginBackImage           @"loginbackground2"
#define MyBackIamge              @"mybackimage2"
#define NavigationColor          @"1"



#elif CB203

#define JPushAppKey              @"eeada2903ba9b6c8453574e1"
#define Appid                    @"203"
#define Launch                   @"launch3"
#define LoginBackImage           @"loginbackground3"
#define MyBackIamge              @"mybackimage3"
#define NavigationColor          @"2"



#elif CB270

#define JPushAppKey              @"bc5dd56aba23721ad166c33e"
#define Appid                    @"270"
#define Launch                   @"launch1"
#define LoginBackImage           @"loginbackground11"
#define MyBackIamge              @"mybackimage2"
#define NavigationColor          @"3"



#elif CB184

#define JPushAppKey              @"b0ba271f0eb44af6d8413f15"
#define Appid                    @"184"
#define Launch                   @"launch2"
#define LoginBackImage           @"loginbackground5"
#define MyBackIamge              @"mybackimage5"
#define NavigationColor          @"4"



#elif CB278

#define JPushAppKey              @"03359d8eb178f40d21c3ecde"
#define Appid                    @"278"
#define Launch                   @"launch3"
#define LoginBackImage           @"loginbackground11"
#define MyBackIamge              @"mybackimage6"
#define NavigationColor          @"5"



#elif CB279

#define JPushAppKey              @"5ed6e276b0d80558c15b7ce7"
#define Appid                    @"279"
#define Launch                   @"launch1"
#define LoginBackImage           @"loginbackground7"
#define MyBackIamge              @"mybackimage7"
#define NavigationColor          @"6"

#elif c66app13

#define JPushAppKey              @"1ea61aa0eb2a88f9080fef9f"
#define Appid                    @"c66app13"
#define Launch                   @"launch4"
#define LoginBackImage           @"loginbackground12"
#define MyBackIamge              @"mybackimage2"
#define NavigationColor          @"0"


#endif






#import "UIColor+CBExt.h"


#import "CBHttpManager.h"
#import "CBAlertHelper.h"


#import "UIViewController+HUD.h"
#import "UIImageView+WebCache.h"

#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>


#endif /* CBConfig_h */
