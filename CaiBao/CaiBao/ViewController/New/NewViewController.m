//
//  NewViewController.m
//  CaiBao
//
//  Created by LC on 2017/4/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "NewViewController.h"
#import "AFNetworking.h"
#import "RESideMenu.h"

@interface NewViewController ()<UIWebViewDelegate>
{
    NSArray *urlArray;
    BOOL isBack;
}
@property(nonatomic,strong) UIWebView *webView;
@property (nonatomic ,strong) UIView *leftview;

@property (nonatomic ,strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation NewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"资讯";
    UIImage *image = (USER(USERIMAGE) ? [UIImage imageWithData:USER(USERIMAGE)] : [UIImage imageNamed:@"userHead"]);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.layer.cornerRadius = 20;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    isBack = NO;
    urlArray = @[@"http://zxwap.caipiao.163.com/",
                 @"http://zxwap.caipiao.163.com/hangye",
                 @"http://zxwap.caipiao.163.com/dongtai",
                 @"http://zxwap.caipiao.163.com/ssq",
                 @"http://zxwap.caipiao.163.com/dlt",
                 @"http://zxwap.caipiao.163.com/jingcai",
                 @"http://zxwap.caipiao.163.com/lancai",
                 @"http://zxwap.caipiao.163.com/news",
                 @"http://zxwap.caipiao.163.com/yiyan",
                 @"http://zxwap.caipiao.163.com/3d",
                 @"http://zxwap.caipiao.163.com/pl3",
                 @"http://zxwap.caipiao.163.com/world",
                 @"http://zxwap.caipiao.163.com/china",
                 @"http://zxwap.caipiao.163.com/nba",
                 @"http://zxwap.caipiao.163.com/cba",
                 @"http://zxwap.caipiao.163.com/gundong",
                 @"http://zxwap.caipiao.163.com/11xuan5",
                 @"http://zxwap.caipiao.163.com/ssc",
                 @"http://zxwap.caipiao.163.com/kuai3",
                 @"http://zxwap.caipiao.163.com/kuaile12",
                 @"http://zxwap.caipiao.163.com/kl8",
                 @"http://zxwap.caipiao.163.com/kuailepuke",
                 @"http://zxwap.caipiao.163.com/klsf",
                 @"http://zxwap.caipiao.163.com/toutiao",
                 @"http://zxwap.caipiao.163.com/sfc"];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.activityIndicator];

    NSURLRequest *request;
    if (self.urlStr.length) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:self.leftview];
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    }else{
        NSString *url = [NSString stringWithFormat:@"http://zxwap.caipiao.163.com/hangye"];
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    }
    [self.webView loadRequest:request];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeAvatar)
                                                 name:KNOTIFICATION_AVATAR
                                               object:nil];
}


- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.center = self.view.center;
        _activityIndicator.hidesWhenStopped = YES;
        

    }
    return _activityIndicator;
}

- (void)changeAvatar
{
    UIImage *image = (USER(USERIMAGE) ? [UIImage imageWithData:USER(USERIMAGE)] : [UIImage imageNamed:@"userHead"]);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.layer.cornerRadius = 20;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (UIWebView *)webView
{
    if (!_webView) {
        if(self.urlStr.length){
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT)];
        }else{
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT - MAIN_BOTTOM_TABBAR_HEIGHT - NAVIGATION_BAR_HEIGHT)];
        }
        _webView.delegate = self;
    }
    
    return _webView;
}

//左边视图
- (UIView *)leftview
{
    if (!_leftview) {
        _leftview = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 70, 44)];
        
        UIButton *left = [UIButton  buttonWithType:UIButtonTypeCustom];
        left.frame = CGRectMake(0,7,30,30);
        [left  setImage:[UIImage  imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_leftview  addSubview:left];
        
        UIButton *back = [UIButton  buttonWithType:UIButtonTypeCustom];
        back.frame = CGRectMake(30, 0, 40, 44);
        [back  setTitle:@"关闭" forState:UIControlStateNormal];
        [_leftview  addSubview:back];
        
        [left  addTarget:self action:@selector(backToTop:) forControlEvents:UIControlEventTouchUpInside];
        [back  addTarget:self action:@selector(backToTop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftview;
}

- (void)backToTop:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark---webDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *string = request.URL.absoluteString;
    NSLog(@"string == %@",string);
    
    for (NSString *str in urlArray) {
        if ([string isEqualToString:str]) {
            [self requestDataWithUrlStr:string];
            return NO;
        }
    }
    if (!self.urlStr.length) {
        if ([string isEqualToString:@"about:blank"]) {
            return NO;
        }
        if (!isBack && ![string isEqualToString:@"file:///"]) {
            NewViewController *new = [[NewViewController alloc] init];
            new.urlStr = string;
            new.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:new animated:YES];
            return NO;
        }else{
            isBack = NO;
            
            return YES;
        }        
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    NSLog(@"加载完成");
    [self hideHud];
}

- (void)requestDataWithUrlStr:(NSString *)urlStr
{
    if (self.urlStr.length) {
        [self.navigationController popViewControllerAnimated:YES];
    }

    [self.activityIndicator startAnimating];
    [[CBHttpManager shareManager] requestWithPath:urlStr HttpRequestType:HttpRequestGet paramenters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSRange rangeHead = [string rangeOfString:@"<header"];//匹配得到的下标
        NSRange rangeFoot = [string rangeOfString:@"header>"];
        NSRange rang = {rangeHead.location,rangeFoot.location - rangeHead.location + rangeFoot.length};
        string = [string stringByReplacingCharactersInRange:rang withString:@""];
        [self.webView loadHTMLString:string baseURL:[NSURL URLWithString:@""]];
        [self.activityIndicator stopAnimating];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self.activityIndicator stopAnimating];
        
    } isHaveNetWork:^(BOOL isHave) {
        [self.activityIndicator stopAnimating];
        
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:KNOTIFICATION_AVATAR];
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
