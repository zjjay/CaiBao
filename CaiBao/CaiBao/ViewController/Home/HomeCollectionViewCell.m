//
//  HomeCollectionViewCell.m
//  CaiBao
//
//  Created by LC on 2017/4/10.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "HomeModel.h"
@interface HomeCollectionViewCell ()

@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *detailLabel;
@end

@implementation HomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = [UIColor lightGrayColor];
    self.detailLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.detailLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 10, 50, 50);
    self.titleLabel.frame = CGRectMake(55, 10, SCREEN_WIDTH/2 - 60, 20);
    self.detailLabel.frame = CGRectMake(55, 35, SCREEN_WIDTH/2 - 60, 20);
}

- (void)setModel:(HomeListModel *)model
{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.attribute.logo] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLabel.text = model.attribute.cardName;
    self.detailLabel.text = model.attribute.cardDesc;
    
}

@end
