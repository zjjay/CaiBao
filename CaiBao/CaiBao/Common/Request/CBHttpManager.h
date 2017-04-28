//
//  CBHttpManager.h
//  CaiBao
//
//  Created by LC on 2017/4/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBObject.h"

//HTTP请求类别
typedef NS_ENUM(NSInteger,HttpRequestType) {
    HttpRequestGet,
    HttpRequestPost,
    HttpRequestPut,
    HttpRequestDelete,
};

typedef void(^SuccessBlock)(NSURLSessionDataTask * task, id responseObject);

typedef void(^FailureBlock)(NSURLSessionDataTask * task, NSError * error);

typedef void(^DownLoadProgressBlock)(NSProgress * downloadProgress);

typedef void(^UpLoadProgressBlock)(NSProgress * uploadProgress);

@interface CBHttpManager : CBObject

/**
 单例
 
 @return 实例对象
 */
+ (CBHttpManager *)shareManager;

/**
 HTTP请求（GET,POST,PUT,DELETE）

 @param url <#url description#>
 @param HttpRequestType <#HttpRequestType description#>
 @param params <#params description#>
 @param success <#success description#>
 @param failure <#failure description#>
 @param netWork <#netWork description#>
 */
- (void)requestWithPath:(NSString *)url
        HttpRequestType:(HttpRequestType)HttpRequestType
            paramenters:(NSDictionary *)params
                success:(SuccessBlock)success
                failure:(FailureBlock)failure
          isHaveNetWork:(void(^) (BOOL isHave))netWork;

- (void)cancelNetWork;
@end
