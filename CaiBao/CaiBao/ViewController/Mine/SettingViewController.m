//
//  SettingViewController.m
//  Custom
//
//  Created by xiu&yun on 16/7/29.
//  Copyright © 2016年 xiu&yun. All rights reserved.
//

#import "SettingViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  creatUI];
}

- (void)creatUI{
    self.title = @"设置";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionL.text = [NSString  stringWithFormat:@"%@ %@",app_Name,app_Version];
    self.versionL.textAlignment = NSTextAlignmentCenter;
    self.cunL.text = [NSString stringWithFormat:@"%.2fM",[self filePath]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(claerFile:)];
    [self.clearL  addGestureRecognizer:tap];
    
    [self.swith1  addTarget:self action:@selector(swith1Chang:) forControlEvents:UIControlEventValueChanged];
    [self.swith1  setOn:YES animated:YES];
    [self.swith2  addTarget:self action:@selector(swith2Change:) forControlEvents:UIControlEventValueChanged];
    [self.swith2  setOn:YES animated:YES];
}


#pragma mark---逻辑事件
//点击清理缓存视图
- (void)claerFile:(UITapGestureRecognizer *)tap{
    [self  cleanClick];
}

- (void)swith2Change:(UISwitch *)swith1
{

}

- (void)swith1Chang:(UISwitch *)swith2
{
    
}

#pragma mark---清理缓存
//点击清理缓存
-(void)cleanClick{
    UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"是否清除缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alv.alertViewStyle = UIAlertViewStyleDefault;//设置警告框的样式
    [alv show];
}
#pragma mark-UIAlertViewDelegate协议方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //YES-1  NO-0
    if (buttonIndex==1) {
        //下面做清除缓存的处理
        [self clearFile];
    }
}
#pragma mark-清理缓存相关代码
//1:首先计算单个文件的大小
- (long long)fileSizeAtPath:(NSString *) filePath{
    //创建文件管理器对象(是一个单例对象)
    NSFileManager *manager=[NSFileManager defaultManager];
    //测试文件是否存在
    if ([manager fileExistsAtPath :filePath]){
        //获取文件信息(属性和权限) 返回文件的大小
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0 ;
}

//2:遍历文件夹获得文件夹大小,返回多少M
-(float)folderSizeAtPath:(NSString *)folderPath{
    NSFileManager *manager=[NSFileManager defaultManager];
    //文件夹不存在,返回零
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    
    NSEnumerator *childFilesEnumerator=[[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ])!=nil){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

// 显示缓存大小
- (float)filePath
{
    //通常使用Documents目录进行数据持久化的保存,而这个Documents目录可以通过以下方法获得
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString * cachPath =[NSSearchPathForDirectoriesInDomains (NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    return [self folderSizeAtPath:cachPath];
}

//清理缓存
- (void)clearFile
{
    NSString * cachPath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask ,YES) firstObject];
    //subpathsAtPath用来获取指定目录下的子项(文件或文件夹)列表 (以递归的方式获取子项列表)
    NSArray * files = [[NSFileManager defaultManager]subpathsAtPath:cachPath];
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager]fileExistsAtPath :path]){
            [[NSFileManager defaultManager]removeItemAtPath :path error:&error];
        }
    }
    //以下方法的作用是在主线程中，执行制定的方法（代码块）
    [self performSelectorOnMainThread:@selector(clearCachSuccess)withObject:nil waitUntilDone:YES];
}
-(void)clearCachSuccess
{
    self.cunL.text =[NSString stringWithFormat:@"%.2fM",[self filePath]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
