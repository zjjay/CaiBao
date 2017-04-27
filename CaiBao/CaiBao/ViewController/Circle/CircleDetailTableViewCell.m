//
//  CircleDetailTableViewCell.m
//  CaiBao
//
//  Created by LC on 2017/4/10.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CircleDetailTableViewCell.h"
#import "CirclephoneView.h"
#import "UIView+SDAutoLayout.h"
#import "CircleListModel.h"
@interface CircleDetailTableViewCell ()
{
    UIImageView *avatarImageView;
    UIButton *nameButton;
    UILabel *textLabel;
    UILabel *timeLabel;
    UIButton *likeButton;
    UILabel *likeNumLabel;
    UIButton *commentButton;
    UILabel *commentNumLabel;
    CirclephoneView *phoneView;
}

@end

@implementation CircleDetailTableViewCell


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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userNameClicked)];
    [avatarImageView addGestureRecognizer:tap];
    
    //昵称
    nameButton = [UIButton new];
    [nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nameButton addTarget:self action:@selector(userNameClicked) forControlEvents:UIControlEventTouchUpInside];
    nameButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    //发表内容
    textLabel = [UILabel new];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.numberOfLines = 0;
    
    //时间
    timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor lightGrayColor];
    
    //点赞按钮
    likeButton = [UIButton new];
    [likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [likeButton setImage:[UIImage imageNamed:@"like_select"] forState:UIControlStateSelected];
    [likeButton addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //点赞人数
    likeNumLabel = [UILabel new];
    likeNumLabel.font = [UIFont systemFontOfSize:12];
    likeNumLabel.textColor = [UIColor blackColor];
    
    //评论按钮
    commentButton = [UIButton new];
    [commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    commentNumLabel = [UILabel new];
    commentNumLabel.text = @"评论";
    commentNumLabel.font = [UIFont systemFontOfSize:12];
    commentNumLabel.textColor = [UIColor blackColor];
    commentNumLabel.userInteractionEnabled = YES;
    
    phoneView = [CirclephoneView new];
    
    NSArray *array = @[avatarImageView,nameButton,textLabel,timeLabel,likeButton,likeNumLabel,commentButton,commentNumLabel,phoneView];
    [self.contentView sd_addSubviews:array];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    avatarImageView.sd_layout
    .leftSpaceToView(contentView, margin*2)
    .topSpaceToView(contentView, margin*2)
    .widthIs(40)
    .heightIs(40);
    
    nameButton.sd_layout
    .leftSpaceToView(avatarImageView, margin)
    .topEqualToView(avatarImageView)
    .heightIs(20);
    [nameButton setSd_maxWidth:@300];

    
    textLabel.sd_layout
    .leftEqualToView(nameButton)
    .topSpaceToView(nameButton, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    phoneView.sd_layout
    .leftEqualToView(nameButton);
    
    timeLabel.sd_layout
    .leftEqualToView(nameButton)
    .topSpaceToView(phoneView, margin)
    .heightIs(20);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:1000];
    
    commentNumLabel.sd_layout
    .rightSpaceToView(contentView, margin)
    .topEqualToView(timeLabel)
    .heightIs(20);
    [commentNumLabel setSingleLineAutoResizeWithMaxWidth:1000];

    commentButton.sd_layout
    .rightSpaceToView(commentNumLabel, margin)
    .topEqualToView(timeLabel)
    .heightIs(20)
    .widthIs(20);
    
    likeNumLabel.sd_layout
    .rightSpaceToView(commentButton, margin)
    .topEqualToView(timeLabel)
    .heightIs(20);
    [likeNumLabel setSingleLineAutoResizeWithMaxWidth:1000];
    
    likeButton.sd_layout
    .rightSpaceToView(likeNumLabel, margin)
    .topEqualToView(timeLabel)
    .heightIs(20)
    .widthIs(20);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}


- (void)setModel:(CircleListModel *)model
{
    _model = model;
    
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar"]];
    [nameButton setTitle:model.nickName forState:UIControlStateNormal];
    [nameButton sizeToFit];
    
    textLabel.text = model.text;
    if ([model.like intValue]) {
        likeButton.selected = YES;
    }else{
        likeButton.selected = NO;
    }
    likeNumLabel.text = model.likeCount;
    commentNumLabel.text = model.commentCount;
    timeLabel.text = model.createTime;
    
    phoneView.photoArray = model.imageList;
    CGFloat photoTopMargin = 0;
    if (model.imageList.count) {
        photoTopMargin = 10;
    }
    
    phoneView.sd_layout.topSpaceToView(textLabel, photoTopMargin);
    
    [self setupAutoHeightWithBottomView:timeLabel bottomMargin:15];

}

- (void)userNameClicked
{
    if ([self.delegate respondsToSelector:@selector(didClickUserNameInCell:)]) {
        [self.delegate didClickUserNameInCell:self];
    }
}

- (void)likeButtonClicked
{
    if ([self.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
        [self.delegate didClickLikeButtonInCell:self];
    }
}

- (void)commentButtonClicked
{
    if ([self.delegate respondsToSelector:@selector(didClickCommentButtonInCell:)]) {
        [self.delegate didClickCommentButtonInCell:self];
    }
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
