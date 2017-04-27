//
//  HomeModel.h
//  CaiBao
//
//  Created by LC on 2017/4/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBObject.h"

@class HomeListModel,HomeAttributeModel;
@interface HomeModel : CBObject

@property (nonatomic ,copy) NSString *clickHref;
@property (nonatomic ,copy) NSString *nPicture;
@property (nonatomic ,copy) NSString *picture;

@end

@interface HomeListModel : CBObject

@property (nonatomic ,copy) NSString *ID;

@property (nonatomic ,copy) NSString *type;

@property (nonatomic ,strong) HomeAttributeModel *attribute;


@end

@interface HomeAttributeModel : CBObject

@property (nonatomic ,copy) NSString *activityColor;
@property (nonatomic ,copy) NSString *activityText;
@property (nonatomic ,copy) NSString *activityTextColor;
@property (nonatomic ,copy) NSString *badgeIcon;
@property (nonatomic ,copy) NSString *cardDesc;
@property (nonatomic ,copy) NSString *cardName;
@property (nonatomic ,copy) NSString *jumpUrl;
@property (nonatomic ,copy) NSString *logo;
@property (nonatomic ,copy) NSString *rankMax;
@property (nonatomic ,copy) NSString *rankMin;
@property (nonatomic ,copy) NSString *shiftLeft;

@end

