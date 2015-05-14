//
//  ViewController.m
//  XTYQRCode
//
//  Created by lakala on 15/5/14.
//  Copyright (c) 2015年 lakala. All rights reserved.
//

#import "ViewController.h"
#import "XTYScanView.h"
#import <AVFoundation/AVFoundation.h>
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *AVSession;
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, strong) XTYScanView *xtyScranView;
@end

@implementation ViewController
//进入后台暂停活动
-(void)didBecomeBackGround
{
    [_session stopRunning];
}
//进入前台后继续扫描
-(void)willEnterForeground
{
    [_session startRunning];
}
-(void)build
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeBackGround)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    _xtyScranView = [[XTYScanView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _xtyScranView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_xtyScranView];
    [self setupCamera];
}
/**
 *  初始化二维码扫描摄像头
 */
- (void)setupCamera
    {
        // Device
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // Input
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        // Output
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // Session
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input])
        {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output])
        {
            [_session addOutput:self.output];
        }
        
        // 条码类型 AVMetadataObjectTypeQRCode
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        
        // Preview
        
        _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        _preview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        //    _preview.frame =CGRectMake(28,110,SCANVIEWWIDTH,SCANVIEWHEIGHT);
        [self.view.layer insertSublayer:_preview atIndex:0];
        
        
        // Start
        [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        if ([metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            stringValue = metadataObject.stringValue;
            NSLog(@"%@",stringValue);
        }
    }
    
    [_session stopRunning];
    [_xtyScranView stopTimer];
    
    //     }];
}
#pragma mark lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self build];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
