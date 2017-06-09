//
//  Common.h
//  CaiBao
//
//  Created by LC on 2017/6/9.
//  Copyright © 2017年 LC. All rights reserved.
//

#ifndef Common_h
#define Common_h

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

#endif /* Common_h */
