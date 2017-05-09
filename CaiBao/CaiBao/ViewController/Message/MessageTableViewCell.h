//
//  MessageTableViewCell.h
//  CaiBao
//
//  Created by LC on 2017/5/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end
