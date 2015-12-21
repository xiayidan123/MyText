

#import "QRDetectionViewController.h"
#import "Decoder.h"
#import "NSString+HTML.h"
#import "ResultParser.h"
#import "ParsedResult.h"
#import "ResultAction.h"
#import "TwoDDecoderResult.h"
#import "DeviceHelper.h"
#import "UISize.h"
#import "JSONKit.h"
#import "Constants.h"
#import "PublicFunctions.h"
#import "WowTalkWebServerIF.h"
#import "WTError.h"
#import "Database.h"
#import "QRShowViewController.h"
#import "QRScanResultViewController.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "MBProgressHUD.h"

#import <AVFoundation/AVFoundation.h>

#define CAMERA_SCALAR 1.12412 // scalar = (480 / (2048 / 480))
#define FIRST_TAKE_DELAY 1.0
#define ONE_D_BAND_HEIGHT 10.0

#define SHUTTER_TOP_HEIGHT                  274
#define SHUTTER_BOTTOM_HEIGHT               250
#define SHUTTER_TOP_HEIGHT_IPHONE5          318
#define SHUTTER_BOTTOM_HEIGHT__IPHONE5      294
#define SHUTTER_OVERLAP_HEIGHT              44

@interface QRDetectionViewController ()
{
    BOOL firstLoad;
    BOOL scanViewAnimating;
    BOOL _isScaning;
    BOOL _hasResult;
}

@property BOOL showCancel;
@property BOOL showLicense;
@property BOOL oneDMode;
@property BOOL isStatusBarHidden;

@property (retain, nonatomic) NSString *userId;

@property (retain, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (retain, nonatomic) MBProgressHUD * hud;

@property (copy, nonatomic) NSString *infoString;

- (void)initCapture;
- (void)stopCapture;

@end

@implementation QRDetectionViewController

@synthesize userId = _userId;
@synthesize previewLayer = _previewLayer;

@synthesize operationView = _operationView;
@synthesize layerView = _layerView;
@synthesize bgView = _bgView;
@synthesize lightTop = _lightTop;
@synthesize lightBottom = _lightBottom;
@synthesize lightWhole = _lightWhole;

@synthesize photoLabel = _photoLabel;
@synthesize flashLabel = _flashLabel;
@synthesize qrcodeLabel = _qrcodeLabel;

@synthesize scanImageView = _scanImageView;

@synthesize captureSession;
@synthesize result, delegate, soundToPlay;
@synthesize overlayView;
@synthesize oneDMode, showCancel, showLicense, isStatusBarHidden;
@synthesize readers;


- (id)initWithDelegate:(id<ZXingDelegate>)scanDelegate showCancel:(BOOL)shouldShowCancel OneDMode:(BOOL)shouldUseoOneDMode {
    
    return [self initWithDelegate:scanDelegate showCancel:shouldShowCancel OneDMode:shouldUseoOneDMode showLicense:YES];
}

- (id)initWithDelegate:(id<ZXingDelegate>)scanDelegate showCancel:(BOOL)shouldShowCancel OneDMode:(BOOL)shouldUseoOneDMode showLicense:(BOOL)shouldShowLicense {
    self = [super init];
    if (self) {
        [self setDelegate:scanDelegate];
        self.oneDMode = shouldUseoOneDMode;
        self.showCancel = shouldShowCancel;
        self.showLicense = shouldShowLicense;
        //修改前代码开始
//        self.wantsFullScreenLayout = YES;//view在显示后会自动调整为去掉导航栏的高度
        //修改前代码结束
        //说明：wantsFullScreenLayout 方法已被禁用，下面两个方法是替换的方法
        //修改后开始
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft |UIRectEdgeRight;
        //修改后结束
        beepSound = -1;
        decoding = NO;
        OverlayView *theOverLayView = [[OverlayView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                           cancelEnabled:showCancel
                                                                oneDMode:oneDMode
                                                             showLicense:shouldShowLicense];
        [theOverLayView setDelegate:self];
        self.overlayView = theOverLayView;
        [theOverLayView release];
    }
    return self;
}

- (void)dealloc {
    if (beepSound != (SystemSoundID)-1) {
        AudioServicesDisposeSystemSoundID(beepSound);
    }
    
    [self stopCapture];
    
    [result release];
    [soundToPlay release];
    [overlayView release],overlayView = nil;
    [readers release];
    [_layerView release];
    [_lightTop release];
    [_lightBottom release];
    [_lightWhole release];
    [_photoButton release];
    [_flashButton release];
    [_qrcodeButton release];
    [_operationView release];
    [_photoLabel release];
    [_flashLabel release];
    [_qrcodeLabel release];
    [_scanImageView release];
    [_bgView release];
    [_scanmaskView release];
    [_scanBar release];
    
    [super dealloc];
}

- (void)cancelled {
    [self stopCapture];
    if (!self.isStatusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    
    wasCancelled = YES;
    if (delegate != nil) {
        [delegate zxingControllerDidCancel:self];
    }
}

- (NSString *)getPlatform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

- (BOOL)fixedFocus {
    NSString *platform = [self getPlatform];
    if ([platform isEqualToString:@"iPhone1,1"] ||
        [platform isEqualToString:@"iPhone1,2"]) return YES;
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    firstLoad = YES;
    _hasResult = NO;
    _photoLabel.text = NSLocalizedString(@"QRCode Photo", nil);
    _flashLabel.text = NSLocalizedString(@"QRCode Flash", nil);
    _qrcodeLabel.text = NSLocalizedString(@"QRCode My QRCode", nil);
    
    
    UIBarButtonItem *backBarItem = [PublicFunctions getCustomNavButtonOnLeftSide:YES
                                                                          target:self
                                                                           image:[UIImage imageNamed:@"icon_back_white"]
                                                                        selector:@selector(shouldPullBack)];
    [self.navigationItem addLeftBarButtonItem:backBarItem];
    [backBarItem release];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"Scan QRCode", nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
    if ([self torchAvailable]) {
        _flashButton.enabled = YES;
    } else {
        _flashButton.enabled = NO;
    }
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (firstLoad){
        CGFloat screenWidth = [UISize screenWidth];
        CGFloat screenHeight = [UISize screenHeight];
        _lightWhole.frame = CGRectMake(0, -[UISize heightOfStatusBarAndNavBar], screenWidth, screenHeight);
        _operationView.frame = CGRectMake(0, screenHeight - [UISize heightOfStatusBarAndNavBar] - 96, 320, 96);
        if ([DeviceHelper isIphone5]) {
            [_bgView setImage:[UIImage imageNamed:QR_SCAN_BG_IPHONE5]];
            [_lightWhole setImage:[UIImage imageNamed:QR_SHUTTER_LIGHT_IPHONE5]];
            
            [_lightTop setImage:[UIImage imageNamed:QR_SHUTTER_TOP_IPHONE5]];
            [_lightBottom setImage:[UIImage imageNamed:QR_SHUTTER_BOTTOM_IPHONE5]];
            _lightTop.frame = CGRectMake(0, -[UISize heightOfStatusBarAndNavBar], screenWidth, SHUTTER_TOP_HEIGHT_IPHONE5);
            _lightBottom.frame = CGRectMake(0, SHUTTER_TOP_HEIGHT_IPHONE5 - SHUTTER_OVERLAP_HEIGHT - [UISize heightOfStatusBarAndNavBar], screenWidth, SHUTTER_BOTTOM_HEIGHT__IPHONE5);
        } else {
            [_bgView setImage:[UIImage imageNamed:QR_SCAN_BG]];
            [_lightWhole setImage:[UIImage imageNamed:QR_SHUTTER_LIGHT]];
            
            [_lightTop setImage:[UIImage imageNamed:QR_SHUTTER_TOP]];
            [_lightBottom setImage:[UIImage imageNamed:QR_SHUTTER_BOTTOM]];
            _lightTop.frame = CGRectMake(0, -[UISize heightOfStatusBarAndNavBar], screenWidth, SHUTTER_TOP_HEIGHT);
            _lightBottom.frame = CGRectMake(0, SHUTTER_TOP_HEIGHT - SHUTTER_OVERLAP_HEIGHT - [UISize heightOfStatusBarAndNavBar], screenWidth, SHUTTER_BOTTOM_HEIGHT);
        }
        _bgView.frame = CGRectMake(0.0, -[UISize heightOfStatusBarAndNavBar], [UISize screenWidth], [UISize screenHeight]);
        //修改前代码开始
//        self.wantsFullScreenLayout = YES;
        //修改前代码结束
        
        //修改后代码开始
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeRight | UIRectEdgeLeft | UIRectEdgeBottom;
        //修改后代码结束
        if ([self soundToPlay] != nil) {
            OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)[self soundToPlay], &beepSound);
            if (error != kAudioServicesNoError) {
                NSLog(@"Problem loading nearSound.caf");
            }
        }
    }
    [self initCapture];
    
    self.scanImageView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    decoding = YES;
    self.scanImageView.hidden = NO;
    
    [overlayView setPoints:nil];
    wasCancelled = NO;
    if (firstLoad) {
        [self startAlphaAnimation];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [self stopCapture];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    firstLoad = NO;
    if (!isStatusBarHidden)
        [[UIApplication sharedApplication] setStatusBarHidden:NO];

}

- (BOOL)torchAvailable
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        return device.hasTorch;
    }
    return NO;
}

- (void)startAlphaAnimation {
    [UIView animateWithDuration:0.5f
                     animations:^{
                         _lightWhole.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2f
                                          animations:^{
                                              _lightWhole.alpha = 0.0f;
                                          }
                                          completion:^(BOOL finished){
                                              [self startTranslateAnimation];
                                          }];
                     }];
}

- (void)startTranslateAnimation {
    CGFloat topY;
    CGFloat topHeight;
    CGFloat bottomHeight;
    if ([DeviceHelper isIphone5]) {
        topY = - SHUTTER_TOP_HEIGHT_IPHONE5;
        topHeight = SHUTTER_TOP_HEIGHT_IPHONE5;
        bottomHeight = SHUTTER_BOTTOM_HEIGHT__IPHONE5;
    } else {
        topY = - SHUTTER_TOP_HEIGHT;
        topHeight = SHUTTER_TOP_HEIGHT;
        bottomHeight = SHUTTER_BOTTOM_HEIGHT;
    }
    [UIView animateWithDuration:0.3f
                     animations:^{
                         _lightTop.frame = CGRectMake(0, topY, [UISize screenWidth], topHeight);
                         _lightBottom.frame = CGRectMake(0, [UISize screenHeight], [UISize screenHeight], bottomHeight);
                     }
                     completion:^(BOOL finished){
                         _lightTop.alpha = 0.0f;
                         _lightTop.hidden = YES;
                         _lightBottom.hidden = YES;
                     }];
}

- (void)startScanAnimation
{
    if (!scanViewAnimating) {
        return;
    }
    if ([DeviceHelper isIphone5]) {
        self.scanImageView.frame = CGRectMake(58.0, 115.0 - [UISize heightOfStatusBarAndNavBar], 205.0, 2.0);
    } else {
        self.scanImageView.frame = CGRectMake(58.0, 97.0 - [UISize heightOfStatusBarAndNavBar], 205.0, 2.0);
    }
    [UIView animateWithDuration:2.5
                     animations:^{
                         if ([DeviceHelper isIphone5]) {
                             self.scanImageView.frame = CGRectMake(58.0, 325.0 - [UISize heightOfStatusBarAndNavBar], 205.0, 2.0);
                         } else {
                             self.scanImageView.frame = CGRectMake(58.0, 280.0 - [UISize heightOfStatusBarAndNavBar], 205.0, 2.0);
                         }
                     }
                     completion:^(BOOL finished){
                         [self startScanAnimation];
                     }];
}

- (void)scanBaraAnimate{
    if (_isScaning){
        //        CGPoint scanBarcenter = CGPointMake(_scanBar.center.x, ((_scanBar.center.y == 1) ? 219.0 : 1.0));
        _scanBar.center = CGPointMake(_scanBar.center.x, -2);
        [UIView animateWithDuration:2.5 animations:^{
            _scanBar.center = CGPointMake(_scanBar.center.x, 221);
        } completion:^(BOOL finished) {
            [self scanBaraAnimate];
        }];
    }
}

- (void)shouldPullBack {
    [self.navigationController popViewControllerAnimated:YES];
}

// DecoderDelegate methods

- (void)decoder:(Decoder *)decoder willDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset{
    NSLog(@"DecoderViewController MessageWhileDecodingWithDimensions: Decoding image (%.0fx%.0f) ...", image.size.width, image.size.height);
}

- (void)decoder:(Decoder *)decoder
  decodingImage:(UIImage *)image
    usingSubset:(UIImage *)subset {
}

- (void)presentResultForString:(NSString *)resultString {
    self.result = [ResultParser parsedResultForString:resultString];
    if (beepSound != (SystemSoundID)-1) {
        AudioServicesPlaySystemSound(beepSound);
    }
    NSLog(@"result string = %@", resultString);
}

- (void)presentResultPoints:(NSArray *)resultPoints
                   forImage:(UIImage *)image
                usingSubset:(UIImage *)subset {
    // simply add the points to the image view
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:resultPoints];
    [overlayView setPoints:mutableArray];
    [mutableArray release];
}

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)twoDResult {
    [self stopCapture];
    if (_hasResult)return;
    _hasResult = YES;
    
    NSString *info = [twoDResult text];
    self.infoString = info;
    NSLog(@"decode result : %@", info);
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *jsonDic = [data objectFromJSONData];
//    NSString *label = [jsonDic objectForKey:@"label"];
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
        //[WowTalkWebServerIF searchUserByKey:uid withType:type withCallback:@selector(didSearchUser:) withObserver:self];
        self.userId = uid;
        [WowTalkWebServerIF getBuddyWithUID:uid withCallback:@selector(didSearchUser:) withObserver:self];
        decoding = NO;
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.alpha = 0.85;
        _hud.color = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.85];
        _hud.mode = MBProgressHUDModeIndeterminate;
        }
    else{
        decoding = NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"not onemeter user qrcode", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:NSLocalizedString(@"是否使用浏览器打开二维码网址", nil), nil];
        alertView.tag = 3000;
        [alertView show];
        [alertView release];
    }
    
    [self presentResultForString:[twoDResult text]];
    [self presentResultPoints:[twoDResult points] forImage:image usingSubset:subset];
    // now, in a selector, call the delegate to give this overlay time to show the points
    [self performSelector:@selector(notifyDelegate:) withObject:[[twoDResult text] copy] afterDelay:0.0];
    decoder.delegate = nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3000){
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.infoString]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didSearchUser:(NSNotification *)noti {
    NSError *error = [[noti userInfo] objectForKey:WT_ERROR];
    NSLog(@"error code : %zi", error.code);
    if (error.code == NO_ERROR) {
        [_hud removeFromSuperview];
        [overlayView.points removeAllObjects];
        QRScanResultViewController *resultViewController = [[QRScanResultViewController alloc] init];
        resultViewController.buddy = [Database buddyWithUserID:self.userId];
        [self.navigationController pushViewController:resultViewController animated:YES];
        [resultViewController release];
    }else{
        decoding = YES;
        [_hud removeFromSuperview];
    }
}


- (void)notifyDelegate:(id)text {
    if (!isStatusBarHidden) [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [delegate zxingController:self didScanResult:text];
    [text release];
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason {
    decoder.delegate = nil;
    [overlayView setPoints:nil];
}

- (void)decoder:(Decoder *)decoder foundPossibleResultPoint:(CGPoint)point {
    [overlayView setPoint:point];
}

#pragma mark -
#pragma mark AVFoundation

#include <sys/types.h>
#include <sys/sysctl.h>

- (void)initCapture {
    AVCaptureDevice* inputDevice =
    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureInput =
    [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    
    if (!captureInput) {
        return;
    }
    
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    self.captureSession = [[[AVCaptureSession alloc] init] autorelease];
    
    NSString* preset = 0;
    
    if (!preset) {
        preset = AVCaptureSessionPresetMedium;
    }
    self.captureSession.sessionPreset = preset;
    
    [self.captureSession addInput:captureInput];
    [self.captureSession addOutput:captureOutput];
    
    [captureOutput release];
    
    if (!self.previewLayer) {
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    }
    self.previewLayer.frame = self.layerView.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layerView.layer addSublayer:self.previewLayer];
    
    [self.layerView bringSubviewToFront:self.bgView];
    
    [self.layerView bringSubviewToFront:self.scanmaskView];
    [self.captureSession startRunning];
    scanViewAnimating = YES;
    
     dispatch_async(dispatch_get_main_queue(), ^{
         [self startScanAnimation];
         _isScaning = YES;
         [self scanBaraAnimate];
     });
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    if (!decoding) {
        return;
    }
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    /*Lock the image buffer*/
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    /*Get information about the image*/
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // NSLog(@"wxh: %lu x %lu", width, height);
    
    uint8_t* baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    void* free_me = 0;
    if (true) { // iOS bug?
        uint8_t* tmp = baseAddress;
        NSInteger bytes = bytesPerRow*height;
        free_me = baseAddress = (uint8_t*)malloc(bytes);
        baseAddress[0] = 0xdb;
        memcpy(baseAddress,tmp,bytes);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext =
    CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace,
                          kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);
    
    CGImageRef capture = CGBitmapContextCreateImage(newContext);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    free(free_me);
    
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);

    UIImage* scrn = [[[UIImage alloc] initWithCGImage:capture] autorelease];
    
    CGImageRelease(capture);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Decoder* d = [[Decoder alloc] init];
        d.readers = readers;
        d.delegate = self;
        
        decoding = [d decodeImage:scrn] == YES ? NO : YES;
        
        [d release];
    });
    
    
    
//    if (decoding) {
//        
//        d = [[Decoder alloc] init];
//        d.readers = readers;
//        d.delegate = self;
//        
//        scrn = [[[UIImage alloc] initWithCGImage:scrn.CGImage
//                                           scale:1.0
//                                     orientation:UIImageOrientationLeft] autorelease];
//        
//        // NSLog(@"^ %@ %f", NSStringFromCGSize([scrn size]), scrn.scale);
//        decoding = [d decodeImage:scrn] == YES ? NO : YES;
//        
//        [d release];
//    }
    
}

- (void)stopCapture {
    decoding = NO;
    [captureSession stopRunning];
    if (captureSession.inputs && [captureSession.inputs count] > 0) {
        AVCaptureInput* input = [captureSession.inputs objectAtIndex:0];
        [captureSession removeInput:input];
    }
    if (captureSession.outputs && [captureSession.outputs count] > 0) {
        AVCaptureVideoDataOutput* output = (AVCaptureVideoDataOutput*)[captureSession.outputs objectAtIndex:0];
        [captureSession removeOutput:output];
    }
    
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;
    self.captureSession = nil;
    scanViewAnimating = NO;
    _isScaning = NO;
}

# pragma mark - Torch

- (void)setTorch:(BOOL)status {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        [device lockForConfiguration:nil];
        if ( [device hasTorch] ) {
            if ( status ) {
                [device setTorchMode:AVCaptureTorchModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
            }
        }
        [device unlockForConfiguration];
        
    }
}

- (BOOL)torchIsOn {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ( [device hasTorch] ) {
            
            return [device torchMode] == AVCaptureTorchModeOn;
        }
//        [device unlockForConfiguration];
    }
    return NO;
}

- (IBAction)shouldPickPhoto:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = YES;
//    [self presentModalViewController:imagePicker animated:YES];已弃用
    [self presentViewController:imagePicker animated:YES completion:nil];
    [imagePicker release];
}

- (IBAction)shouldToggleTorch:(UIButton *)sender {
    if ([self torchIsOn]) {
        [self setTorch:NO];
        [_flashButton setImage:[UIImage imageNamed:@"qr_scan_flash.png"] forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"qr_scan_flash_p.png"] forState:UIControlStateSelected];
    } else {
        [self setTorch:YES];
        [_flashButton setImage:[UIImage imageNamed:@"qr_scan_flash_on.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)shouldShowQRCode:(UIButton *)sender {
    QRShowViewController *showViewController = [[QRShowViewController alloc] init];
    [self.navigationController pushViewController:showViewController animated:YES];
    [showViewController release];
}

#pragma mark UIImagePickController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];
    Decoder *decoder = [[Decoder alloc] init];
    decoder.readers = self.readers;
    decoder.delegate = self;
    
    decoding = [decoder decodeImage:image] == YES ? NO : YES;
    [decoder release];
    if (decoding) {
        decoder = [[Decoder alloc] init];
        decoder.readers = self.readers;
        decoder.delegate = self;
        
        UIImage *newImage = [[[UIImage alloc] initWithCGImage:image.CGImage
                                                        scale:1.0 orientation:UIImageOrientationLeft] autorelease];
        decoding = [decoder decodeImage:newImage] == YES ? NO : YES;
        [decoder release];
    }
}

- (void)viewDidUnload {
    [self setLayerView:nil];
    [self setLightTop:nil];
    [self setLightBottom:nil];
    [self setLightWhole:nil];
    [self setPhotoButton:nil];
    [self setFlashButton:nil];
    [self setQrcodeButton:nil];
    [self setOperationView:nil];
    [self setPhotoLabel:nil];
    [self setFlashLabel:nil];
    [self setQrcodeLabel:nil];
    [self setScanImageView:nil];
    [self setBgView:nil];
    [super viewDidUnload];
}
@end
