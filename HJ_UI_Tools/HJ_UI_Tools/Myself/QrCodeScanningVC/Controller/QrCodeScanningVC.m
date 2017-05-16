//
//  QrCodeScanningVC.m
//  KuGuan
//
//  Created by ceyu on 16/7/21.
//  Copyright © 2016年 吴宏佳. All rights reserved.
//

#import "QrCodeScanningVC.h"
#import "QrCodeLayer.h"
#import "GrayBackgroundLayer.h"
#import "UIView+HUD.h"
#import <AVFoundation/AVFoundation.h>

@interface QrCodeScanningVC ()<AVCaptureMetadataOutputObjectsDelegate>

/**AV捕获会话*/
@property (strong,nonatomic) AVCaptureSession* session;
/**AV捕获Metadata输出*/
@property (strong,nonatomic) AVCaptureMetadataOutput* output;
/**AV捕获设备的输入*/
@property (strong,nonatomic) AVCaptureDeviceInput* input;
/**AV捕获视频预览层*/
@property (strong,nonatomic) AVCaptureVideoPreviewLayer*  scanViewLayer;

@property (weak,nonatomic) QrCodeLayer*  grayLineLayer;

@end

@implementation QrCodeScanningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫码取餐";
    
    //AV捕捉设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    if (!device) {
        [self.view showHUDWithText:@"无摄像设备" hideDelay:1.0];
        return;
    }
    self.input = [AVCaptureDeviceInput deviceInputWithDevice: device error: nil];
    
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate: self queue: dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset: AVCaptureSessionPresetHigh];    //高质量采集
    if ([self.session canAddInput:self.input]) {
        [self.session addInput: self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput: self.output];
    }
    [self.session startRunning];

    //注意必须在输出数据对象加入到当前会话后才能设置识别的数据格式。这里设置为扫描二维码以及条形码
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    self.scanViewLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
    self.scanViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.scanViewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.scanViewLayer];
    
    
    
    GrayBackgroundLayer *grayBgLayer = [GrayBackgroundLayer layer];
    grayBgLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:grayBgLayer];
    
    QrCodeLayer *grayLineLayer = [QrCodeLayer layer];
    CGRect bgF =self.view.bounds;
    CGFloat scanW = 200.0;
    CGFloat scanH = scanW;
    CGFloat scanX = (bgF.size.width - scanW)/2;
    CGFloat scanY = (bgF.size.height - scanH)/2;
    CGRect downF = CGRectMake(scanX, scanY, scanW, scanH);

    grayLineLayer.frame = downF;
    [self.view.layer addSublayer:grayLineLayer];
    self.grayLineLayer = grayLineLayer;

}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];

    if (!device) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.session startRunning];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [self.session stopRunning];
}
- (void)dealloc{
    [self.grayLineLayer stopDisplayAnimation];

}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{

    if (metadataObjects.count == 0) return;
    
    AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects firstObject];
    NSLog(@"stringValue-%@",metadataObject.stringValue);
    NSLog(@"corners-%@",metadataObject.corners);
    NSLog(@"NSThread-%@",[NSThread currentThread]);
    __weak __typeof(self)wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.navigationController popViewControllerAnimated:YES];
        if ([wself.delegate respondsToSelector:@selector(scanSuccess:withString:)]) {
            [wself.delegate scanSuccess:wself withString:metadataObject.stringValue];
        }
    });
    
    
    [self.session stopRunning];
}
@end
