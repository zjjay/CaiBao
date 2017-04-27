//
//  HomeViewController.m
//  CaiBao
//
//  Created by LC on 2017/4/8.
//  Copyright © 2017年 LC. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewModel.h"
#import "HomeCollectionViewCell.h"
#import "SDCycleScrollView.h"
#import "HomeHeadView.h" 
#import "HomeModel.h"
#import "HomeDetailViewController.h"
#define HeadHeight SCREEN_WIDTH*26/64
@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>
{
    HomeViewModel *viewModel;
    NSMutableArray *cycleImageArray;
}

@property (nonatomic ,strong) UICollectionView *collectionView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"彩宝大厅";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"leftAvatar"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];

    viewModel = [[HomeViewModel alloc] init];
    [viewModel requsetDataWithUrlStr:@"http://api.caipiao.163.com/clientHall_hallInfoAll.html?product=caipiao_client&mobileType=iphone&ver=4.32&channel=i4zhushou&apiVer=1.1&apiLevel=27&deviceId=27&activityId=cs40&userName=tencent.163.com&version=b0e41ff827fc6d102d6bb69f951558db" callback:^{
        cycleImageArray = [NSMutableArray new];
        for (HomeModel *model in viewModel.headArray) {
            [cycleImageArray addObject:model.picture];
        }
        [self.view addSubview:self.collectionView];
        
    }];
    
}



- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        //1.初始化layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置collectionView滚动方向
        //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //设置headerView的尺寸大小
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, HeadHeight);
        //该方法也可以设置itemSize
        //    layout.itemSize =CGSizeMake(0, 150);
        
        //2.初始化collectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - MAIN_BOTTOM_TABBAR_HEIGHT - NAVIGATION_BAR_HEIGHT) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        
        //3.注册collectionViewCell
        //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
        [_collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[HomeHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];

        //4.设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return viewModel.listArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    HomeListModel *model = viewModel.listArray[indexPath.row];
    cell.model = model;
    return cell;
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/2 - 15, 50);
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section

{
    return 10;
}
//点击item方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeListModel *model = viewModel.listArray[indexPath.row];
    HomeDetailViewController *new = [[HomeDetailViewController alloc] init];
    new.urlStr = model.attribute.jumpUrl;
    new.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:new animated:YES];
}
//headView/footView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader){
        HomeHeadView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];
        // 网络加载 --- 创建不带标题的图片轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeadHeight) imageURLStringsGroup:nil];
        
        cycleScrollView.infiniteLoop = YES;
        //    _cycleScrollView
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.delegate = self;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        cycleScrollView.autoScrollTimeInterval = 2.5; // 轮播时间间隔，默认1.0秒，可自定义
        cycleScrollView.imageURLStringsGroup = cycleImageArray;
        cycleScrollView.pageDotColor = CB_rgba(255, 255, 255, 0.5);
        cycleScrollView.currentPageDotColor = CB_rgb(255, 255, 255);
        cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:cycleScrollView];
        return view;
    }
    if (kind == UICollectionElementKindSectionFooter){
        
    }
    return nil;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    HomeModel *model = viewModel.headArray[index];
    HomeDetailViewController *new = [[HomeDetailViewController alloc] init];
    new.urlStr = model.clickHref;
    new.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:new animated:YES];
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
