//
//  NewFriendTableViewCell.h
//  CaiBao
//
//  Created by LC on 2017/6/9.
//  Copyright © 2017年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;

@end
