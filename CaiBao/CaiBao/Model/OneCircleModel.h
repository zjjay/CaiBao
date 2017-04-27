//
//  OneCircleModel.h
//  CaiBao
//
//  Created by LC on 2017/4/12.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBObject.h"

@interface OneCircleModel : CBObject

@property (nonatomic ,copy) NSString *replyerNickName;
@property (nonatomic ,copy) NSString *replyerAvatarUrl;
@property (nonatomic ,copy) NSString *replyerUserId;
@property (nonatomic ,copy) NSString *createTime;
@property (nonatomic ,copy) NSString *text;
@property (nonatomic ,copy) NSString *commentId;

@end
