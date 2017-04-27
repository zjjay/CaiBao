//
//  CircleViewModel.h
//  CaiBao
//
//  Created by LC on 2017/4/10.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBObject.h"

@interface CircleViewModel : CBObject

+ (void)requsetDataWithUrlStr:(NSString *)urlStr callback:(void(^)(NSArray *dataArray))callback;
+ (void)DetailRequsetDataWithUrlStr:(NSString *)urlStr callback:(void(^)(NSArray *dataArray))callback;
+ (void)OneRequsetDataWithUrlStr:(NSString *)urlStr callback:(void (^)(NSArray *dataArray))callback;

@end
