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

//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//        //第一次启动
//        self.scroller = [[UIScrollView  alloc] initWithFrame:self.view.bounds];
//        self.scroller.backgroundColor = [UIColor  whiteColor];
//        self.scroller.contentSize = CGSizeMake(SCREEN_WIDTH * PictureNumber, SCREEN_HEIGHT);
//        self.scroller.contentOffset = CGPointMake(0, 0);
//        self.scroller.pagingEnabled = YES;
//        self.scroller.delegate = self;
//        self.scroller.showsHorizontalScrollIndicator = NO;
//        [self.view  addSubview:self.scroller];
//        
//        self.page = [[UIPageControl  alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 30)];
//        self.page.numberOfPages = PictureNumber;
//        self.page.currentPage = 0;
//    self.page.pageIndicatorTintColor = CB_rgb(169, 226, 100);
//    self.page.currentPageIndicatorTintColor = CB_rgb(241, 109, 0);
//        [self.view  addSubview:self.page];
//        
//        
//        for (int i =1; i <= 3; i++)
//        {
//            UIImageView * imageV = [[UIImageView  alloc] initWithFrame:CGRectMake((i-1)*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            imageV.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"%@%d",@"launch",i]];
//            [self.scroller   addSubview:imageV];
//        }
//        //创建一button
//        self.log= [UIButton   buttonWithType: UIButtonTypeCustom ];
//        self.log.frame = CGRectMake((SCREEN_WIDTH - 100)/2, SCREEN_HEIGHT - 60,100, 30);
//    self.log.hidden = (PictureNumber == 1 ? NO : YES);
//        self.log.layer.cornerRadius = PictureNumber;
//        self.log.clipsToBounds = YES;
//        [self.log   setTitle:@"立即体验" forState:UIControlStateNormal];
//        [self.log  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.log  addTarget:self action:@selector(getData) forControlEvents:UIControlEventTouchUpInside];
//        [self.log  setBackgroundColor:CB_rgb(241, 109, 0)];
//        [self.view  addSubview:self.log];
//    }else{
//        //不是第一次启动了
//        [self getData];
//    }
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
        
        
//        if (self.callBack) {
//            self.callBack(YES,@"http://apps.cb8vip.com/");
//        }
//        [self hideHud];
//        return;
        
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
//        sleep(2);
//        [self getData];

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
