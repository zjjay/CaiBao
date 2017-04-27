//
//  MineViewController.m
//  CaiBao
//
//  Created by LC on 2017/4/18.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "MineViewController.h"
#import "MyCommentViewController.h"
#import "SweepViewController.h"
#import "SettingViewController.h"
#import "FeedBackViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CGFloat headViewHeight;
    CGFloat avatarImageViewHeight;
    
    NSArray *titleArray;
    NSArray *imageArray;
    NSArray *controllerArray;
}
@property(strong,nonatomic)UIImagePickerController *imagePicker;
@property (nonatomic ,strong) UIImageView *tableHeadView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIImageView *avatarImageView;
@property (nonatomic ,strong) UIButton *nameButton;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    titleArray = @[@[@"我的评论",@"扫一扫"],@[@"通知",@"设置"],@[@"意见反馈",@"退出登录"]];
    imageArray = @[@[@"icon_edu",@"icon_scan"],@[@"icon_notice",@"icon_setting"],@[@"icon_feedback",@"icon_exit"]];
    controllerArray = @[@[@"MyComment",@"Sweep"],@[@"MyComment",@"Setting"],@[@"FeedBack",@"Exit"]];
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.tableHeadView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MAIN_BOTTOM_TABBAR_HEIGHT) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *emptyTableHeaderView = [[UIView alloc] initWithFrame:self.tableHeadView.frame];
        _tableView.tableHeaderView = emptyTableHeaderView;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (UIImageView *)tableHeadView
{
    if (!_tableHeadView) {
        _tableHeadView = [[UIImageView alloc ]initWithFrame:(CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200))];
        _tableHeadView.contentMode = UIViewContentModeScaleAspectFill;
        _tableHeadView.clipsToBounds = YES;
        _tableHeadView.image = [UIImage imageNamed:MyBackIamge];
        _tableHeadView.userInteractionEnabled = YES;
        [_tableHeadView addSubview:self.avatarImageView];
        [_tableHeadView addSubview:self.nameButton];
        headViewHeight = self.tableHeadView.frame.size.height;
    }
    return _tableHeadView;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, 60, 60))];
        _avatarImageView.center = _tableHeadView.center;
        _avatarImageView.layer.cornerRadius=30;
        _avatarImageView.layer.masksToBounds=YES;
        _avatarImageView.userInteractionEnabled = YES;
        
        UIImage *image = (USER(USERIMAGE) ? [UIImage imageWithData:USER(USERIMAGE)] : [UIImage imageNamed:@"userHead"]);

        _avatarImageView.image = image;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatar)];
        [_avatarImageView addGestureRecognizer:tap];
        
        avatarImageViewHeight = self.avatarImageView.frame.size.height;
    }
    return _avatarImageView;
}

- (UIButton *)nameButton
{
    if (!_nameButton) {
        _nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nameButton.frame = CGRectMake(20, self.avatarImageView.center.y + 50, SCREEN_WIDTH - 40, 20);
        [_nameButton addTarget:self action:@selector(changeName) forControlEvents:UIControlEventTouchUpInside];
        NSString *name = USER(USERTITLE) ? USER(USERTITLE) : @"失去的记忆";
        [_nameButton setTitle:name forState:UIControlStateNormal];
    }
    return _nameButton;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    cell.imageView.image = [UIImage imageNamed:[imageArray[indexPath.section] objectAtIndex:indexPath.row]];
    cell.textLabel.text = [titleArray[indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *leiStr = [NSString  stringWithFormat:@"%@ViewController",controllerArray[indexPath.section][indexPath.row]];
    Class  myClass = NSClassFromString(leiStr);
    UIViewController *vc = [[myClass  alloc] init];
    
    //是否为扫一扫的类
    if ([leiStr  isEqualToString:@"SweepViewController"])
    {
        //判断摄像头
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
            UIAlertController *altC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查设备相机!" preferredStyle:UIAlertControllerStyleAlert];
            [altC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:altC animated:YES completion:nil];
            return;
        }else{
            SweepViewController *sweepV = [[SweepViewController alloc] init];
            sweepV.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sweepV animated:YES];
        }
        
    }else if ([leiStr  isEqualToString:@"ExitViewController"]) {
        [[NSNotificationCenter  defaultCenter] postNotificationName:KNOTIFICATION_LOGIN object:nil userInfo:nil];
    }else{
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController  pushViewController:vc animated:YES];
    }
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y < 0) {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        
        CGFloat headHeight = headViewHeight + offsetY;
        CGFloat avatarHeight = avatarImageViewHeight + offsetY;
        
        self.avatarImageView.frame = CGRectMake(self.avatarImageView.frame.origin.x, self.avatarImageView.frame.origin.y, avatarHeight, avatarHeight);
        self.tableHeadView.frame = CGRectMake(self.tableHeadView.frame.origin.x, offsetY * -1, self.tableHeadView.frame.size.width, headHeight);
        self.avatarImageView.center = CGPointMake(self.tableHeadView.center.x, self.avatarImageView.frame.origin.y + avatarHeight/2);
        self.avatarImageView.layer.cornerRadius = avatarHeight*0.5;
        
        self.nameButton.frame = CGRectMake(self.nameButton.frame.origin.x, self.avatarImageView.center.y + avatarHeight/2 + 20, self.nameButton.frame.size.width, 20);
    }
}


- (void)changeName
{
    [CBAlertHelper addTextFieldWithTitle:@"修改昵称" message:nil rightName:@"确定" leftName:@"取消" placeholder:@"请输入你的昵称" viewController:self rightAction:^(NSString *text) {
        [self.nameButton setTitle:text forState:UIControlStateNormal];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:text forKey:USERTITLE];
        [user synchronize];
    } leftAction:^(NSString *text) {
        
    }];
}

- (void)changeAvatar
{
    [CBAlertHelper sheetAlertWithOne:@"打开相机" two:@"打开相册" viewController:self oneAction:^{
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            [self alertWithTitle:@"无法使用相机" message:@"请在iPhone的'设置-隐私-相机'中允许访问相机" urlString:@"prefs:root=Privacy&path=CAMERA"];
            
            
        }else{
            self.imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }
    } twoAction:^{
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
        {
            [self alertWithTitle:@"无法使用相册" message:@"请在iPhone的'设置-隐私-相册'中允许访问相册" urlString:@"prefs:root=Privacy&path=PHOTOS"];
        }else{
            self.imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }
    }];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message urlString:(NSString *)urlString
{
    [CBAlertHelper alertWithTitle:title message:message rightName:@"去设置" leftName:@"取消" viewController:self rightAction:^{
        NSURL *url = [NSURL URLWithString:urlString];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    } leftAction:nil];
}
-(UIImagePickerController *)imagePicker
{
    if(!_imagePicker){
        _imagePicker=[[UIImagePickerController alloc] init];
        [_imagePicker setModalPresentationStyle:UIModalPresentationFullScreen];
        [_imagePicker setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    self.avatarImageView.image = image;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:UIImagePNGRepresentation(image) forKey:USERIMAGE];
    [user synchronize];
    [[NSNotificationCenter  defaultCenter] postNotificationName:KNOTIFICATION_AVATAR object:nil userInfo:nil];

    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
