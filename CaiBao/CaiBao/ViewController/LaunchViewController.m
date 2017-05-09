//
//  LaunchViewController.m
//  CaiBao
//
//  Created by LC on 2017/4/12.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "LaunchViewController.h"

#define PictureNumber 1

@interface LaunchViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scroller;
@property(nonatomic,strong) UIPageControl *page;
@property(nonatomic,strong) UIButton *log;
@end

@implementation LaunchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication  sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
    UIImageView *img = [[UIImageView  alloc] initWithFrame:self.view.bounds];
    img.image = [UIImage  imageNamed:Launch];
    img.userInteractionEnabled = YES;
    [self.view  addSubview:img];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getData)
                                                 name:KNOTIFICATION_NetWork
                                               object:nil];
    
    [self getData];

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int  index = scrollView.contentOffset.x/SCREEN_WIDTH ;
    self.page.currentPage = index;
    if (self.page.currentPage == PictureNumber - 1) {
        self.log.hidden = NO;
    }else{
        self.log.hidden = YES;
    }
}


- (void)getData
{
    [self hideHud];
    [self showHudInView:self.view hint:@"加载中…"];

    NSString *urlStr = [NSString stringWithFormat:@"http://appmgr.jwoquxoc.com/frontApi/getAboutUs?appid=cbapp%@",Appid];
    [[CBHttpManager shareManager] requestWithPath:urlStr HttpRequestType:HttpRequestGet paramenters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"responseJSON == %@",responseJSON);
        
        if ([responseJSON[@"status"] isEqual:@1]) {
            if ([responseJSON[@"isshowwap"] isEqualToString:@"1"]) {
                if (self.callBack) {
                    self.callBack(YES,[responseJSON[@"wapurl"] length] ? responseJSON[@"wapurl"] : @"http://apps.cb8vip.com/");
                }
                [self hideHud];
                return;
            }else{
                if (self.callBack) {
                    self.callBack(NO,@"");
                }
                [self hideHud];
                return;
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        sleep(2);
        [self getData];
    } isHaveNetWork:^(BOOL isHave) {

    }];
}




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:KNOTIFICATION_NetWork];
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
