//
//  HomeViewModel.m
//  CaiBao
//
//  Created by LC on 2017/4/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "HomeViewModel.h"
#import "HomeModel.h"
@implementation HomeViewModel

- (void)requsetDataWithUrlStr:(NSString *)urlStr callback:(void(^)())callback
{
    [[CBHttpManager shareManager] requestWithPath:urlStr HttpRequestType:HttpRequestPost paramenters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSArray *adInfoArray = responseJSON[@"adInfo"];
        NSArray *listArray = responseJSON[@"card"][@"cardList"];
        self.headArray = [NSMutableArray new];
        self.listArray = [NSMutableArray new];
        for (NSDictionary *dic in adInfoArray) {
            HomeModel *model = [HomeModel new];
            [model setValuesForKeysWithDictionary:dic];
            
            [self.headArray addObject:model];
        }
        
        for (NSDictionary *dic in listArray) {
            HomeListModel *model = [HomeListModel new];
            [model setValuesForKeysWithDictionary:dic];
            
            NSDictionary *diction = dic[@"attribute"];
            HomeAttributeModel *attModel = [HomeAttributeModel new];
            [attModel setValuesForKeysWithDictionary:diction];
            model.attribute = attModel;
//            NSLog(@"%@",model.attribute);
            if (model.attribute.logo.length && model.attribute.cardName.length && [model.attribute.jumpUrl hasPrefix:@"http"]) {
                [self.listArray addObject:model];
            }
        }
        if (callback) {
            callback();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error == %@",error);
    } isHaveNetWork:^(BOOL isHave) {
        
    }];
}



@end
