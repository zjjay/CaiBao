//
//  OneCircleTableViewCell.m
//  CaiBao
//
//  Created by LC on 2017/4/12.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "OneCircleTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "OneCircleModel.h"
@interface OneCircleTableViewCell ()
{
    UIImageView *avatarImageView;
    UILabel *nameLabel;
    UILabel *textLabel;
    UILabel *timeLabel;
    UILabel *levelLabel;
}
@end

@implementation OneCircleTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createView
{
    //头像
    avatarImageView = [UIImageView new];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.clipsToBounds = YES;
    avatarImageView.userInteractionEnabled = YES;
    avatarImageView.layer.cornerRadius = 20;
    avatarImageView.clipsToBounds = YES;
    
    nameLabel = [UILabel new];
    nameLabel.font = [UIFont systemFontOfSize:15];
    
    timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = [UIColor lightGrayColor];
    
    textLabel = [UILabel new];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.numberOfLines = 0;
    
    levelLabel = [UILabel new];
    levelLabel.font = [UIFont systemFontOfSize:14];
    
    NSArray *array = @[avatarImageView,nameLabel,timeLabel,textLabel,levelLabel];
    [self.contentView sd_addSubviews:array];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    avatarImageView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .widthIs(40)
    .heightIs(40);
    
    nameLabel.sd_layout
    .leftSpaceToView(avatarImageView, margin)
    .topEqualToView(avatarImageView)
    .heightIs(20);
    [nameLabel setSingleLineAutoResizeWithMaxWidth:1000];
    
    timeLabel.sd_layout
    .leftEqualToView(nameLabel)
    .topSpaceToView(nameLabel, margin*0.5)
    .heightIs(20);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:1000];

    levelLabel.sd_layout
    .rightSpaceToView(contentView, margin)
    .topEqualToView(nameLabel)
    .heightIs(20);
    [levelLabel setSingleLineAutoResizeWithMaxWidth:1000];

    textLabel.sd_layout
    .leftEqualToView(nameLabel)
    .topSpaceToView(timeLabel, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setCircleModel:(OneCircleModel *)circleModel
{
    _circleModel = circleModel;
    
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:circleModel.replyerAvatarUrl] placeholderImage:[UIImage imageNamed:@"avatar"]];
    nameLabel.text = circleModel.replyerNickName;
    timeLabel.text = circleModel.createTime;
    textLabel.text = circleModel.text;
    levelLabel.text = _level;
    [self setupAutoHeightWithBottomView:textLabel bottomMargin:5];
}

- (void)setLevel:(NSString *)level
{
    _level = level;
    levelLabel.text = level;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
