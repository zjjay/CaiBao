//
//  CircleListModel.h
//  CaiBao
//
//  Created by LC on 2017/4/10.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBObject.h"
@class CircleImageModel;
@interface CircleListModel : CBObject

@property (nonatomic ,copy) NSString *accountId;
@property (nonatomic ,copy) NSString *avatarUrl;
@property (nonatomic ,copy) NSString *nickName;
@property (nonatomic ,copy) NSString *userId;

@property (nonatomic ,copy) NSString *boardId;
@property (nonatomic ,copy) NSString *boardName;
@property (nonatomic ,copy) NSString *boardUrl;

@property (nonatomic ,copy) NSString *text;
@property (nonatomic ,copy) NSString *commentCount;
@property (nonatomic ,copy) NSString *likeCount;
@property (nonatomic ,copy) NSString *like;
@property (nonatomic ,copy) NSString *createTime;
@property (nonatomic ,copy) NSString *postId;
@property (nonatomic ,copy) NSString *id;

@property (nonatomic ,copy) NSString *showTag;
@property (nonatomic ,strong) NSArray<CircleImageModel *> *imageList;

@end

@interface CircleImageModel : CBObject

@property (nonatomic ,copy) NSString *originalHeight;
@property (nonatomic ,copy) NSString *originalWidth;
@property (nonatomic ,copy) NSString *originalUrl;

@property (nonatomic ,copy) NSString *thumbnailHeight;
@property (nonatomic ,copy) NSString *thumbnailWidth;
@property (nonatomic ,copy) NSString *thumbnailUrl;

@end
