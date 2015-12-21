//
//  OMQRCodeScanViewController.m
//  dev01
//
//  Created by Starmoon on 15/7/23.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMQRCodeScanViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "OMQRCodeScanView.h"

#import "JSONKit.h"
#import "WTError.h"
#import "WowTalkWebServerIF.h"
#import "Database.h"

#import "OMQRScanResultViewController.h"
#import "QRShowViewController.h"

@interface OMQRCodeScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (retain, nonatomic) AVCaptureDevice * device;
@property (retain, nonatomic) AVCaptureDeviceInput * input;
@property (retain, nonatomic) AVCaptureMetadataOutput * output;
@property (retain, nonatomic) AVCaptureSession * session;
@property (retain, nonatomic) AVCaptureVideoPreviewLayer * preview;

@property (copy, nonatomic) NSString * info_string;
@property (copy, nonatomic) NSString * buddy_id;

@property (retain, nonatomic) IBOutlet OMQRCodeScanView *scan_view;

@property (retain, nonatomic) UIActivityIndicatorView * activity_indicatorView;

@property (retain, nonatomic) UIView * bg_view;

@end

@implementation OMQRCodeScanViewController

-(void)dealloc{
    self.device = nil;
    self.input = nil;
    self.session = nil;
    self.preview = nil;
    
    self.info_string = nil;
    self.buddy_id = nil;
    
    [_scan_view release];
    [super dealloc];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.bg_view.hidden = NO;
    [self.activity_indicatorView startAnimating];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self startScan];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.session stopRunning];
    [self.scan_view stopScan];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self uiConfig];
}

- (void)uiConfig{
    
    self.title = NSLocalizedString(@"扫一扫",nil);
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"我的二维码",nil) style:UIBarButtonItemStylePlain target:self action:@selector(myQRcode)] autorelease];
    
    self.scan_view.transparentArea = CGSizeMake(220, 220);
}

- (void)myQRcode{
    QRShowViewController *myQRCodeVC = [[QRShowViewController alloc]initWithNibName:@"QRShowViewController" bundle:nil];
    [self.navigationController pushViewController:myQRCodeVC animated:YES];
    [myQRCodeVC release];
}

- (void)startScan{
    self.bg_view.hidden = YES;
    [self.activity_indicatorView stopAnimating];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
        [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
        [self.view.layer insertSublayer:self.preview atIndex:0];
        
        [self.scan_view startScan];
        [self.session startRunning];
        
        CGFloat screenHeight = self.view.frame.size.height;
        CGFloat screenWidth = self.view.frame.size.width;
        CGRect cropRect = CGRectMake((screenWidth - self.scan_view.transparentArea.width) / 2,
                                     (screenHeight - self.scan_view.transparentArea.height) / 2 - 50,
                                     self.scan_view.transparentArea.width,
                                     self.scan_view.transparentArea.height);
        
        [self.output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                              cropRect.origin.x / screenWidth,
                                              cropRect.size.height / screenHeight,
                                              cropRect.size.width / screenWidth)];
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0)
    {
        //停止扫描
        [self.session stopRunning];
        [self.scan_view stopScan];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        self.info_string = metadataObject.stringValue;
    }
    
    NSData *data = [self.info_string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *jsonDic = [data objectFromJSONData];
    
    NSString *type = [jsonDic objectForKey:@"type"];
    NSDictionary *content = [jsonDic objectForKey:@"content"];
    NSString *uid = nil;
    switch ([type intValue]) {
        case 0:
            uid = [content objectForKey:@"uid"];
            break;
        case 1:
            uid = [content objectForKey:@"uid"];
            break;
        case 2:
            uid = [content objectForKey:@"group_id"];
            break;
        case 3:
            uid = [content objectForKey:@"event_id"];
            break;
        case 4:
            uid = [content objectForKey:@"public_account_id"];
            break;
        default:
            uid = nil;
            break;
    }
    if (uid) {
        self.buddy_id = uid;
        
        self.omAlertViewForNet.title = @"正在获取用户信息...";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Loading;
        [self.omAlertViewForNet showInView:self.view];
        
        [WowTalkWebServerIF getBuddyWithUID:uid withCallback:@selector(didSearchUser:) withObserver:self];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"not onemeter user qrcode", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:NSLocalizedString(@"是否使用浏览器打开二维码网址", nil), nil];
        [alertView show];
        [alertView release];
    }
}

- (void)didSearchUser:(NSNotification *)noti {
    NSError *error = [[noti userInfo] objectForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.omAlertViewForNet.title = @"获取用户信息成功";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Done;
    }else{
        self.omAlertViewForNet.title = @"获取用户信息失败";
        self.omAlertViewForNet.type = OMAlertViewForNetStatus_Failure;
    }
}


#pragma mark - OMAlertViewForNetDelegate

- (void)hiddenOMAlertViewForNet:(OMAlertViewForNet *)alertViewForNet{
    if (alertViewForNet.type == OMAlertViewForNetStatus_Done){
        OMQRScanResultViewController *qrScanResultVC = [[OMQRScanResultViewController alloc]initWithNibName:@"OMQRScanResultViewController" bundle:nil];
        qrScanResultVC.buddy =  [Database buddyWithUserID:self.buddy_id];
        [self.navigationController pushViewController:qrScanResultVC animated:YES];
        [qrScanResultVC release];
    }else if (alertViewForNet.type == OMAlertViewForNetStatus_Failure){
        [self startScan];
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3000){
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.info_string]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - Set and Get

-(AVCaptureDevice *)device{
    if (_device == nil){
        _device = [[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] retain];
    }
    return _device;
}


-(AVCaptureDeviceInput *)input{
    if (_input == nil){
        _input = [[AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil] retain];
    }
    return _input;
}

-(AVCaptureMetadataOutput *)output{
    if (_output == nil){
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            }
    return _output;
}


-(AVCaptureSession *)session{
    if (_session == nil){
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
        
        if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            self.output.metadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
        }
    }
    return _session;
}

-(AVCaptureVideoPreviewLayer *)preview{
    if (_preview == nil){
        _preview = [[AVCaptureVideoPreviewLayer layerWithSession:self.session] retain];
        _preview.videoGravity =AVLayerVideoGravityResize;
        _preview.frame =self.view.layer.bounds;
        
    }
    return _preview;
}


-(UIView *)bg_view{
    if (_bg_view == nil){
        _bg_view = [[UIView alloc]initWithFrame:self.view.bounds];
        _bg_view.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_bg_view];
        self.activity_indicatorView = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        [_bg_view addSubview:self.activity_indicatorView];
        
        self.activity_indicatorView.center = CGPointMake(_bg_view.width /2.0f, _bg_view.height /2.0f);
    }
    return _bg_view;
}








@end
