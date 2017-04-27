//
//  CBHttpManager.m
//  CaiBao
//
//  Created by LC on 2017/4/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "CBHttpManager.h"
#import "AFNetworking.h"

@interface CBHttpManager ()
@property (nonatomic, strong) AFHTTPSessionManager * manager;
@property (nonatomic, assign) BOOL isConnect;

@end

@implementation CBHttpManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
        
        //设置请求类型
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //设置响应类型
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"text/javascript",@"application/json",@"text/html",@"image/jpg",@"image/png",@"image/gif",@"application/octet-stream",@"application/xhtml+xml",@"*/*",@"application/xhtml+xml",@"image/webp",@"text/html", nil];

        self.manager.requestSerializer.timeoutInterval = 5;//默认是60秒
        
        //开启监听
        [self openNetMonitoring];
        
    }
    return self;
}

#pragma mark  -----监听网络-----
- (void)openNetMonitoring {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.isConnect = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self.isConnect = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.isConnect = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.isConnect = YES;
                break;
            default:
                break;
        }
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    self.isConnect = YES;
}

#pragma mark  -----单例-----
/**
 单例
 
 @return 实例对象
 */
+ (CBHttpManager *)shareManager {
    
    static CBHttpManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)requestWithPath:(NSString *)url
        HttpRequestType:(HttpRequestType)HttpRequestType
            paramenters:(NSDictionary *)params
                success:(SuccessBlock)success
                failure:(FailureBlock)failure
          isHaveNetWork:(void(^) (BOOL isHave))netWork;
{
    if (![self isConnectionAvailable]) {
        //无网
        if (netWork) {
            netWork(NO);
        }
        return;
    }
    switch (HttpRequestType) {
        case HttpRequestGet:
            self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [self.manager GET:url parameters:params progress:nil success:success failure:failure];
            break;
        case HttpRequestPost:
            self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [self.manager POST:url parameters:params progress:nil success:success failure:failure];
            break;
        case HttpRequestPut:
            [self.manager PUT:url parameters:params success:success failure:failure];
            break;
        case HttpRequestDelete:
            [self.manager DELETE:url parameters:params success:success failure:failure];
            break;
        default:
            break;
    }
}

#pragma mark  -----是否有网-----
/**
 是否有网
 
 @return 是否有网
 */
- (BOOL)isConnectionAvailable {
    
    return self.isConnect;
}

@end
