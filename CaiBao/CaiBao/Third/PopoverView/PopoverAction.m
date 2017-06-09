//
//  PopoverAction.m
//  Popover
//
//  Created by StevenLee on 2016/12/10.
//  Copyright © 2016年 lifution. All rights reserved.
//

#import "PopoverAction.h"

@interface PopoverAction ()

@property (nonatomic, strong, readwrite) UIImage *image; ///< 图标
@property (nonatomic, copy, readwrite) NSString *title; ///< 标题

@end

@implementation PopoverAction

+ (instancetype)actionWithTitle:(NSString *)title
{
    return [self actionWithImage:nil title:title];
}

+ (instancetype)actionWithImage:(NSString *)image title:(NSString *)title{
    PopoverAction *action = [[self alloc] init];
    action.image = [UIImage imageNamed:image];
    action.title = title ? : @"";
    
    return action;
}

@end
