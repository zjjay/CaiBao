//
//  UIColor+CBExt.h
//  CaiBao
//
//  Created by LC on 2017/4/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CBExt)

+ (instancetype)colorWithHexRGBA:(NSString *)rgba;

+ (instancetype)colorWithHexRGB:(NSString *)rgb;

+ (instancetype)colorWithHexARGB:(NSString *)argb;

+ (UIColor *)randomColor;

+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha;

@end
