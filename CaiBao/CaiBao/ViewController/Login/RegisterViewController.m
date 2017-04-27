//
//  RegisterViewController.m
//  CaiBao
//
//  Created by LC on 2017/4/15.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textFiled2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UIView *naviBackView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[@"#50A260",@"#1C4F82",@"#3694DA",@"#58534C",@"#E93F33",@"#EC6252",@"#EC62C5",@"#7962C5",@"#796200",@"#5B0000"];

    self.naviBackView.backgroundColor = [UIColor colorWithHexRGB:[array objectAtIndex:[NavigationColor integerValue]]];
}
- (IBAction)closed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registerAction:(id)sender {
    [self.view endEditing:YES];
    if (!self.textField1.text.length) {
        [self showHint:@"请输入账号！"];
        return;
    }
    if (!self.textFiled2.text.length) {
        [self showHint:@"请输入密码！"];
        return;
    }
    if (![self.textFiled2.text isEqualToString:self.textField3.text]) {
        [self showHint:@"两次输入密码不一致！"];
        return;
    }
    
    [self showHint:@"注册成功"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:self.textField1.text forKey:USERNAME];
    [user setValue:self.textFiled2.text forKey:PASSWORD];
    [user synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
