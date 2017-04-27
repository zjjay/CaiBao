//
//  CirclephoneView.m
//  CaiBao
//
//  Created by LC on 2017/4/11.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CirclephoneView.h"
#import "UIView+SDAutoLayout.h"
#import "SDPhotoBrowser.h"
#import "CircleListModel.h"
@interface CirclephoneView ()<SDPhotoBrowserDelegate>

@property (nonatomic ,strong) NSArray *imagesArray;
@property (nonatomic ,strong) UIButton *button;

@end

@implementation CirclephoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [tempArray addObject:imageView];
    }
    self.imagesArray = [tempArray copy];
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton new];
        [_button setTitle:@"查看全图" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        _button.userInteractionEnabled = NO;
    }
    return _button;
}
- (void)setPhotoArray:(NSArray *)photoArray
{
    _photoArray = photoArray;
    for (long i = photoArray.count; i < self.imagesArray.count; i++) {
        UIImageView *imageView = [self.imagesArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (photoArray.count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemWidth = [self itemWidthForPhotoArray:photoArray];
    CGFloat itemHeight = 0;
    if (photoArray.count == 1)
    {
        if (itemWidth == 100) {
            itemHeight = 200;
        }else{
            CircleImageModel *model = [photoArray firstObject];
            itemHeight = [model.thumbnailHeight floatValue] / [model.thumbnailWidth floatValue] * itemWidth;
        }
    }else
    {
        itemHeight = itemWidth;
    }
    
    long perRowItemCount = [self perRowItemCountForPhotoArray:photoArray];
    CGFloat margin = 5;
    
    for (int i = 0; i < (photoArray.count >= 9 ? 9 : photoArray.count); i++) {
        CircleImageModel *model = photoArray[i];
        long columnIndex = i % perRowItemCount;
        long rowIndex = i / perRowItemCount;
        UIImageView *imageView = [self.imagesArray objectAtIndex:i];
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        imageView.frame = CGRectMake(columnIndex * (itemWidth + margin), rowIndex * (itemHeight + margin), itemWidth, itemHeight);
        if (photoArray.count == 1 && itemWidth == 100)
        {
            self.button.frame = CGRectMake(0, imageView.frame.size.height - 20, imageView.frame.size.width, 20);
            [imageView addSubview:self.button];
        }else
        {
            [self.button removeFromSuperview];
        }
    }
    
    CGFloat width = perRowItemCount * itemWidth + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(photoArray.count * 1.0 / perRowItemCount);
    if (columnCount > 3) columnCount = 3;
    CGFloat height = columnCount * itemHeight + (columnCount - 1) * margin;
    self.width = width;
    self.height = height;
    
    self.fixedWidth = @(width);
    self.fixedHeight = @(height);
    
}

- (CGFloat)itemWidthForPhotoArray:(NSArray *)phtotArray
{
    if (phtotArray.count == 1)
    {
        CircleImageModel *model = [phtotArray firstObject];
        if ([model.thumbnailHeight floatValue] <= [model.thumbnailWidth floatValue]) {
            return SCREEN_WIDTH / 2;
        }else if ([model.thumbnailHeight floatValue] / [model.thumbnailWidth floatValue] > 2){
            return 100;
        }else{
            return SCREEN_WIDTH / 2 * 0.8;
        }
        return SCREEN_WIDTH / 2;
    }else
    {
        CGFloat width = SCREEN_WIDTH > 320 ? 80 : 70;
        return width;
    }
}

- (NSInteger)perRowItemCountForPhotoArray:(NSArray *)photoArray
{
    if (photoArray.count < 3) {
        return photoArray.count;
    }else if (photoArray.count < 5){
        return 2;
    }else{
        return 3;
    }
}

#pragma mark - SDPhotoBrowserDelegate
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    CircleImageModel *model = self.photoArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:model.originalUrl withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}


- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.photoArray.count;
    browser.delegate = self;
    [browser show];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
