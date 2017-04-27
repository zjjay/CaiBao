//
//  HomeModel.m
//  CaiBao
//
//  Created by LC on 2017/4/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"newPicture"]) {
        self.nPicture = value;
    }
    if ([key isEqualToString:@"clickHref"]) {
        
    }
}

@end

@implementation HomeListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@",value];
    }
    if ([key isEqualToString:@"type"]) {
        self.type = [NSString stringWithFormat:@"%@",value];
    }
    
}

@end

@implementation HomeAttributeModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"rankMax"]) {
        self.rankMax = [NSString stringWithFormat:@"%@",value];
    }
    if ([key isEqualToString:@"rankMin"]) {
        self.rankMin = [NSString stringWithFormat:@"%@",value];
    }
    
}

@end

