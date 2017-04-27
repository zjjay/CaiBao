//

#import "SweepViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface SweepViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) UIView *scanRectView;
@property (nonatomic ,strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preView;
@property (nonatomic, strong) UIWebView *webView;



///记录向上滑动最小边界
@property (nonatomic, assign) CGFloat minY;
///记录向下滑动最大边界
@property (nonatomic, assign) CGFloat maxY;
///扫描区域图片
@property (nonatomic, strong) UIImageView *imageV;
///扫描区域的横线是否是应该向上跑动
@property (nonatomic, assign) BOOL shouldUp;

@end

@implementation SweepViewController
- (void)viewWillAppear:(BOOL)animated {

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        [CBAlertHelper alertWithTitle:@"此功能需要访问您的相机哟!" message:nil rightName:@"不允许" leftName:@"允许" viewController:self rightAction:^{
        }
                           leftAction:^{
                               NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                               
                               if([[UIApplication sharedApplication] canOpenURL:url]) {
                                   
                                   NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                   [[UIApplication sharedApplication] openURL:url];
                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Photos"]];
                               }
                               
                           }];
        return;
    } else {
        [self sweepView];
    }
    
}
///扫描时从上往下跑动的线以及提示语
- (void)scanningAnimationWith:(CGRect) rect {
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat with = rect.size.width;
    CGFloat height = rect.size.height;
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, with, 3)];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"scanLine" ofType:@"png"];
    self.imageV.image = [UIImage imageWithContentsOfFile:imagePath];
    self.shouldUp = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(repeatAction) userInfo:nil repeats:YES];
    [self.view addSubview:self.imageV];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(x, y + height, with, 30)];
    lable.text = @"请将扫描区域对准二维码";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    [self.view addSubview:lable];
}

- (void)repeatAction {
    CGFloat num = 1;
    if (self.shouldUp == NO) {
        self.imageV.frame = CGRectMake(CGRectGetMinX(self.imageV.frame), CGRectGetMinY(self.imageV.frame) + num, CGRectGetWidth(self.imageV.frame), CGRectGetHeight(self.imageV.frame));
        if (CGRectGetMaxY(self.imageV.frame) >= self.maxY) {
            self.shouldUp = YES;
        }
    }else {
        self.imageV.frame = CGRectMake(CGRectGetMinX(self.imageV.frame), CGRectGetMinY(self.imageV.frame) - num, CGRectGetWidth(self.imageV.frame), CGRectGetHeight(self.imageV.frame));
        if (CGRectGetMinY(self.imageV.frame) <= self.minY) {
            self.shouldUp = NO;
        }
    }
}

///获取扫描区域的坐标
- (void)getCGRect:(CGRect)rect {
    CGFloat with = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat x = CGRectGetMinX(rect);
    CGFloat y = CGRectGetMinY(rect);
    CGFloat w = CGRectGetWidth(rect);
    CGFloat h = CGRectGetHeight(rect);
    [self creatFuzzyViewWith:CGRectMake(0, 0, with, y)];
    [self creatFuzzyViewWith:CGRectMake(0, y, x, h)];
    [self creatFuzzyViewWith:CGRectMake(x + w, y, with - x - w, h)];
    [self creatFuzzyViewWith:CGRectMake(0, y + h, with, height - h - y)];
}
///创建扫描区域之外的模糊效果
- (void)creatFuzzyViewWith :(CGRect)rect
{
    UIView *view11 = [[UIView alloc] initWithFrame:rect];
    view11.backgroundColor = [UIColor blackColor];
    view11.alpha = 0.4;
    [self.view addSubview:view11];
}


- (void)sweepView {
    
    ///获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (self.device)
    {
        ///创建输入流
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        ///创建输出流
        self.output = [[AVCaptureMetadataOutput alloc]init];
        ///设置代理,在主线程里面刷新
        [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        ///初始化连接对象
        self.session = [[AVCaptureSession alloc]init];
        ///高质量采集率
        [self.session setSessionPreset:(SCREEN_HEIGHT<500?AVCaptureSessionPreset640x480:AVCaptureSessionPresetHigh)];
        ///链接对象添加输入流和输出流
        [self.session addInput:self.input];
        [self.session addOutput:self.output];
        ///AVMetadataMachineReadableCodeObject对象从QR码生成返回这个常数作为他们的类型
        ///设置扫码支持的编码格式(设置条码和二维码兼容扫描)
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        ///自定义取景框
        CGSize windowSize = [UIScreen mainScreen].bounds.size;
        CGSize scanSize = CGSizeMake(windowSize.width*3/4, windowSize.width*3/4);
        CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2, (windowSize.height-scanSize.height)/2, scanSize.width, scanSize.height);
        
        /**
         *  横线开始上下滑动
         */
        [self scanningAnimationWith:scanRect];
        //创建周围模糊区域
        [self getCGRect:scanRect];
        self.minY = CGRectGetMinY(scanRect);
        self.maxY = CGRectGetMaxY(scanRect);
        
        //计算rectOfInterest 注意x,y交换位置
        scanRect = CGRectMake(scanRect.origin.y/windowSize.height, scanRect.origin.x/windowSize.width, scanRect.size.height/windowSize.height,scanRect.size.width/windowSize.width);
        self.output.rectOfInterest = scanRect;
        
        self.scanRectView = [UIView new];
        [self.view addSubview:self.scanRectView];
        self.scanRectView.frame = CGRectMake(0, 0, scanSize.width, scanSize.height);
        self.scanRectView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
        //    self.scanRectView.layer.borderColor = [UIColor purpleColor].CGColor;
        self.scanRectView.layer.borderWidth = 1;
        self.output.rectOfInterest = scanRect;
        self.preView = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.preView.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.preView.frame = [UIScreen mainScreen].bounds;
        [self.view.layer insertSublayer:self.preView atIndex:0];
        
        ///开始捕获
        [self.session startRunning];
    }else{
        [CBAlertHelper alertWithTitle:@"此功能需要访问您的相册哟!" message:nil rightName:@"不允许" leftName:@"允许" viewController:self rightAction:^{
        }
                           leftAction:^{
                               NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                               
                               if([[UIApplication sharedApplication] canOpenURL:url]) {
                                   
                                   NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                   [[UIApplication sharedApplication] openURL:url];
                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Photos"]];
                               }
            }];
    }
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    [self.session stopRunning];
    
    NSString *stringValue;
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [CBAlertHelper alertWithTitle:stringValue message:nil actionName:@"确定" viewController:self action:^{
        [self.navigationController  popViewControllerAnimated:YES];
    }];
 
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
