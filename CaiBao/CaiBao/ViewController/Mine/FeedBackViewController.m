//
//  FeedBackViewController.m
//  Custom
//
//  Created by xiu&yun on 16/8/29.
//  Copyright © 2016年 xiu&yun. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()<UITextViewDelegate>

@property (nonatomic,strong)UILabel *lab;
@property (nonatomic,strong)UIButton *right;

@end

@implementation FeedBackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"反馈";
    self.view.backgroundColor = ALLVIEWBACKCOLOR;
    self.ContentT.delegate = self;
    [self customRight];
}

//设置右边按钮
- (void)customRight
{
    self.right = [[UIButton  alloc] initWithFrame:CGRectMake(-40, 0,50, 20)];
    [self.right  setTitle:@"发送" forState:UIControlStateNormal];
    [self.right  setTintColor:[UIColor  whiteColor]];
    self.right.titleLabel.font = [UIFont  systemFontOfSize:15];
    [self.right  addTarget:self action:@selector(SendSuggest:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem  alloc]initWithCustomView:self.right];
}

#pragma mark---textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入反馈内容"])
    {
        textView.text = @"";
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    textView.textColor = [UIColor  blackColor];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1)
    {
        textView.text = @"请输入反馈内容";
        textView.textColor = [UIColor  lightGrayColor];
    }
}
#pragma mark----逻辑事件
//发送
- (void)SendSuggest:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (![self.TitleT.text isEqualToString:@""] && ![self.ContentT.text isEqualToString:@""] && ![self.ContentT.text  isEqualToString:@"请输入反馈内容"]) {
        [self showHudInView:self.view hint:@"发送中"];
        sleep(1);
        [self hideHud];
        [self showHint:@"发送成功"];
    } else {
        self.lab = [[UILabel  alloc] init];
        self.lab.text = @"  请补全标题或内容信息   ";
        self.lab.frame = CGRectMake((SCREEN_WIDTH - self.lab.intrinsicContentSize.width)/2, SCREEN_HEIGHT-80, self.lab.intrinsicContentSize.width, 30);
        self.lab.backgroundColor = CB_rgb(119, 119, 121);
        self.lab.textColor = [UIColor whiteColor];
        self.lab.layer.cornerRadius = 15;
        self.lab.clipsToBounds = YES;
        self.lab.font = [UIFont systemFontOfSize:14];
        self.lab.textAlignment = NSTextAlignmentCenter;
        [self.view  addSubview:self.lab];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
    }
    
}

- (void)delayMethod
{
    [self.lab  removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
