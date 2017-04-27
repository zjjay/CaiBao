//
//  HomeViewModel.h
//  CaiBao
//
//  Created by LC on 2017/4/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBObject.h"

@interface HomeViewModel : CBObject

@property (nonatomic ,strong) NSMutableArray *headArray;
@property (nonatomic ,strong) NSMutableArray *listArray;

- (void)requsetDataWithUrlStr:(NSString *)urlStr callback:(void(^)())callback;


@end
