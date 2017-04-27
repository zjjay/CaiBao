//
//  LaunchViewController.h
//  CaiBao
//
//  Created by LC on 2017/4/12.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBViewController.h"

typedef void(^CallBackBlock)(BOOL isSuccess, NSString *urlStr);


@interface LaunchViewController : CBViewController

@property (nonatomic ,copy) CallBackBlock callBack;

@end
