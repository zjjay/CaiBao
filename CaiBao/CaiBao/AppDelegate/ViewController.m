//
//  ViewController.m
//  CaiBao
//
//  Created by LC on 2017/4/7.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "ViewController.h"
#import "GDTSplashAd.h"
#import "GDTTrack.h"
#import "WebKit/WebKit.h"


@interface ViewController ()<WKNavigationDelegate,WKUIDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    if (self.urlStr.length) {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake( 0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-1)];

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
        [webView loadRequest:request];
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        [self.view addSubview:webView];
        
    }else{
        NSArray *array = @[@"#50A260",@"#1C4F82",@"#3694DA",@"#58534C",@"#E93F33",@"#EC6252",@"#EC62C5",@"#7962C5",@"#796200",@"#5B0000"];
        
        UIView *naviview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        naviview.backgroundColor = [UIColor colorWithHexRGB:[array objectAtIndex:[NavigationColor integerValue]]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 60, 24, 120, 40)];
        label.text = @"使用协议";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:20];
        [naviview addSubview:label];
        
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(10, 24, 60, 40);
        [button1 setTitle:@"返回" forState:0];
        [button1 setTitleColor:[UIColor whiteColor] forState:0];
        [button1 addTarget:self action:@selector(closeTheView) forControlEvents:UIControlEventTouchUpInside];
        button1.titleLabel.textAlignment = NSTextAlignmentLeft;
        [naviview addSubview:button1];
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(SCREEN_WIDTH - 70, 24, 60, 40);
        [button2 setTitle:@"确定" forState:0];
        [button2 setTitleColor:[UIColor whiteColor] forState:0];
        [button2 addTarget:self action:@selector(closeTheView) forControlEvents:UIControlEventTouchUpInside];
        button2.titleLabel.textAlignment = NSTextAlignmentRight;
        [naviview addSubview:button2];
        
        
        
        
        
        
        
        [self.view addSubview:naviview];
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake( 0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];

        NSString *path = [[NSBundle mainBundle] pathForResource:@"userInfo" ofType:@"html"];

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
        [webView loadRequest:request];
        [self.view addSubview:webView];


    }
    
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    NSLog(@"createWebViewWithConfiguration");
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }

    return nil;
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
//        [webView loadRequest:navigationAction.request];
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        
        
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)closeTheView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
