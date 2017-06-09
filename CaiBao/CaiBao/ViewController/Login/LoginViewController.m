//
//  LoginViewController.m
//  CaiBao
//
//  Created by LC on 2017/4/26.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "LoginViewController.h"
#import "WSLoginView.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<TencentSessionDelegate>
{
    TencentOAuth *tencentOAuth;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WSLoginView *wsLoginV = [[WSLoginView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    wsLoginV.titleLabel.text = @"我是一头猫头鹰";
    wsLoginV.titleLabel.textColor = [UIColor whiteColor];
    wsLoginV.textField1.text = USER(USERNAME);
    wsLoginV.textField2.text = USER(PASSWORD);
    wsLoginV.hideEyesType = AllEyesHide;
    
    [self.view insertSubview:wsLoginV atIndex:0];
    
    [wsLoginV setLoginBlock:^(NSString *textField1Text, NSString *textField2Text) {
        if (!textField1Text.length || !textField2Text.length ) {
            [self showHint:@"请输入正确的账号和密码！"];
            return;
        }
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:textField1Text forKey:USERNAME];
        [user setObject:textField2Text forKey:PASSWORD];

        [user synchronize];
        
        
        [self loginWithUserName:textField1Text Password:textField2Text];
        
    }];
    
    [wsLoginV setRegisterBlock:^{
        RegisterViewController *controller = [[RegisterViewController alloc] init];
        [self  presentViewController:controller  animated:YES completion:nil];
    }];
    
    //qq登录
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAPPID andDelegate:self];
    tencentOAuth.redirectURI = QQURL;
}
- (IBAction)QQLogin:(id)sender {
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            //                            kOPEN_PERMISSION_ADD_ALBUM,
                            //                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            //                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            //                            kOPEN_PERMISSION_LIST_ALBUM,
                            //                            kOPEN_PERMISSION_UPLOAD_PIC,
                            //                            kOPEN_PERMISSION_GET_VIP_INFO,
                            //                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    //授权登录
    [tencentOAuth setAuthShareType:AuthShareType_QQ];
    [tencentOAuth authorize:permissions];
}
- (void)tencentDidLogin
{
    if ([tencentOAuth.accessToken length] > 0 && tencentOAuth.accessToken) {
        // 获取用户信息
        [tencentOAuth getUserInfo];
    } else {
        [self showHint:@"登录不成功 没有获取accesstoken"];
    }
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    //    NSLog(@"--->respons:%@",response.jsonResponse);
    //登录成功
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:[response.jsonResponse objectForKey:@"nickname"] forKey:USERTITLE];
    [user synchronize];
    [[NSNotificationCenter  defaultCenter] postNotificationName:KNOTIFICATION_LOGIN object:nil userInfo:@{@"userName":[response.jsonResponse objectForKey:@"nickname"],@"password":[response.jsonResponse objectForKey:@"nickname"]}];
    
}


- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled){
        [self showHint:@"取消登录"];
    }else{
        [self showHint:@"登录失败"];
    }
}
- (void)tencentDidNotNetWork
{
    [self showHint:@"无网络连接，请设置网络"];
}



- (void)loginWithUserName:(NSString *)userName Password:(NSString *)password
{
    [[EMClient sharedClient] loginWithUsername:userName
                                      password:password
                                    completion:^(NSString *aUsername, EMError *aError) {
                                        if (!aError) {
                                            [[NSNotificationCenter  defaultCenter] postNotificationName:KNOTIFICATION_LOGIN object:nil userInfo:@{@"userName":userName,@"password":password}];
                                            
                                            NSLog(@"登录成功");
                                        } else {
                                            [self showHint:@"登录失败"];
                                            NSLog(@"登录失败");
                                        }
                                    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
