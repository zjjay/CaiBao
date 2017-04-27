//
//  CircleDetailTableViewCell.h
//  CaiBao
//
//  Created by LC on 2017/4/10.
//  Copyright © 2017年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleDetailDelegate <NSObject>

//点赞
- (void)didClickLikeButtonInCell:(UITableViewCell *)cell;
//评论
- (void)didClickCommentButtonInCell:(UITableViewCell *)cell;
//用户
- (void)didClickUserNameInCell:(UITableViewCell *)cell;


@end

@class CircleListModel;
@interface CircleDetailTableViewCell : UITableViewCell

@property (nonatomic ,strong) CircleListModel *model;

@property (nonatomic ,weak) id<CircleDetailDelegate> delegate;
@end
