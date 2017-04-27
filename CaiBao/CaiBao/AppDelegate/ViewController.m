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
@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic ,strong) UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication  sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];

    [self.view addSubview:self.webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake( 0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-1)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
//        [_webView scalesPageToFit];
//        [_webView sizeToFit];
    }
    
    return _webView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
