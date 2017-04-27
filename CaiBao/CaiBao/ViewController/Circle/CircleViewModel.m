//
//  CircleViewModel.m
//  CaiBao
//
//  Created by LC on 2017/4/10.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CircleViewModel.h"
#import "CirclrModel.h"
#import "CircleListModel.h"
#import "OneCircleModel.h"
@implementation CircleViewModel

+ (void)requsetDataWithUrlStr:(NSString *)urlStr callback:(void(^)(NSArray *))callback
{
    [[CBHttpManager shareManager] requestWithPath:urlStr HttpRequestType:HttpRequestPost paramenters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSArray *array = [responseJSON objectForKey:@"boards"];
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            CirclrModel *model = [CirclrModel new];
            [model setValuesForKeysWithDictionary:dic];
            if ([model.boardName isEqualToString:model.desc]) {
                [resultArray addObject:model];
            }
        }
        if (callback) {
            callback(resultArray);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } isHaveNetWork:^(BOOL isHave) {
        
    }];
}

+ (void)DetailRequsetDataWithUrlStr:(NSString *)urlStr callback:(void (^)(NSArray *))callback
{
    [[CBHttpManager shareManager] requestWithPath:urlStr HttpRequestType:HttpRequestPost paramenters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSArray *array = [responseJSON objectForKey:@"posts"];
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            CircleListModel *model = [CircleListModel new];
            [model setValuesForKeysWithDictionary:dic];
            
            NSMutableArray *resultImageArray = [NSMutableArray array];
            NSArray *imageArray = dic[@"imageList"];
            for (NSDictionary *diction in imageArray) {
                CircleImageModel *imageModel = [CircleImageModel new];
                [imageModel setValuesForKeysWithDictionary:diction];
                [resultImageArray addObject:imageModel];
            }
            
            model.imageList = resultImageArray;
            if ([model.showTag isEqualToString:@"0"]) {
                [resultArray addObject:model];
            }
        }
        if (callback) {
            callback(resultArray);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } isHaveNetWork:^(BOOL isHave) {
        
    }];

}


+ (void)OneRequsetDataWithUrlStr:(NSString *)urlStr callback:(void (^)(NSArray *))callback
{
    [[CBHttpManager shareManager] requestWithPath:urlStr HttpRequestType:HttpRequestPost paramenters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSArray *array = [[responseJSON objectForKey:@"post"] objectForKey:@"comments"];
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            
            OneCircleModel *model = [OneCircleModel new];
            [model setValuesForKeysWithDictionary:dic];
            [resultArray addObject:model];
            
        }
        if (callback) {
            callback(resultArray);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } isHaveNetWork:^(BOOL isHave) {
        
    }];
}

@end
