//
//  CirclrModel.h
//  CaiBao
//
//  Created by LC on 2017/4/10.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBObject.h"

@interface CirclrModel : CBObject

@property (nonatomic ,copy) NSString *boardIconUrl;
@property (nonatomic ,copy) NSString *boardId;
@property (nonatomic ,copy) NSString *boardName;
@property (nonatomic ,copy) NSString *circle;
@property (nonatomic ,copy) NSString *desc;
@property (nonatomic ,copy) NSString *peopleNum;
@property (nonatomic ,copy) NSString *postsNum;

@end
