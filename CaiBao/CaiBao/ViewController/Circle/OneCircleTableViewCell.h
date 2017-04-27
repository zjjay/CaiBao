//
//  OneCircleTableViewCell.h
//  CaiBao
//
//  Created by LC on 2017/4/12.
//  Copyright © 2017年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OneCircleModel;
@interface OneCircleTableViewCell : UITableViewCell

@property (nonatomic ,strong) OneCircleModel *circleModel;

@property (nonatomic ,copy) NSString *level;

@end
