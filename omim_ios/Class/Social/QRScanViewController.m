//
//  QRScanViewController.m
//  wowcity
//
//  Created by jianxd on 14-11-14.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//


#import "QRScanViewController.h"
#import "Decoder.h"
#import "NSString+HTML.h"
#import "ResultParser.h"
#import "ParsedResult.h"
#import "ResultAction.h"
#import "TwoDDecoderResult.h"
#import "UISize.h"
#import "DeviceHelper.h"
#import "Constants.h"
#import "PublicFunctions.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#import <AVFoundation/AVFoundation.h>


#define SHUTTER_TOP_HEIGHT                  274
#define SHUTTER_BOTTOM_HEIGHT               250
#define SHUTTER_TOP_HEIGHT_IPHONE5          318
#define SHUTTER_BOTTOM_HEIGHT__IPHONE5      294
#define SHUTTER_OVERLAP_HEIGHT              44

@interface QRScanViewController ()

@property BOOL decoding;

@property (retain, nonatomic) AVCaptureSession *session;
@property (retain, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

- (void)initCapture;
- (void)stopCapture;

@end

@implementation QRScanViewController
@synthesize indicatorImage = _indicatorImage;
@synthesize previewView = _previewView;
@synthesize shutterBg = _shutterBg;
@synthesize shutterLight = _shutterLight;
@synthesize shutterTop = _shutterTop;
@synthesize shutterBottom = _shutterBottom;
@synthesize buttonPhoto = _buttonPhoto;
@synthesize buttonQR = _buttonQR;
@synthesize buttonTorch = _buttonTorch;

@synthesize decoding = _decoding;
@synthesize readers = _readers;
@synthesize session = _session;
@synthesize previewLayer = _previewLayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UISize screenHeight];
    CGFloat screenWidth = [UISize screenWidth];
    _shutterBg.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    _shutterLight.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    _shutterLight.alpha = 0.0f;
    if ([DeviceHelper isIphone5]) {
        [_shutterLight setImage:[UIImage imageNamed:QR_SHUTTER_LIGHT_IPHONE5]];
        
        [_shutterTop setImage:[UIImage imageNamed:QR_SHUTTER_TOP_IPHONE5]];
        [_shutterBottom setImage:[UIImage imageNamed:QR_SHUTTER_BOTTOM_IPHONE5]];
        _shutterTop.frame = CGRectMake(0, 0, screenWidth, SHUTTER_TOP_HEIGHT_IPHONE5);
        _shutterBottom.frame = CGRectMake(0, SHUTTER_TOP_HEIGHT_IPHONE5 - SHUTTER_OVERLAP_HEIGHT, screenWidth, SHUTTER_BOTTOM_HEIGHT__IPHONE5);
    } else {
        [_shutterLight setImage:[UIImage imageNamed:QR_SHUTTER_LIGHT]];
        
        [_shutterTop setImage:[UIImage imageNamed:QR_SHUTTER_TOP]];
        [_shutterBottom setImage:[UIImage imageNamed:QR_SHUTTER_BOTTOM]];
        _shutterTop.frame = CGRectMake(0, 0, screenWidth, SHUTTER_TOP_HEIGHT);
        _shutterBottom.frame = CGRectMake(0, SHUTTER_TOP_HEIGHT - SHUTTER_OVERLAP_HEIGHT, screenWidth, SHUTTER_BOTTOM_HEIGHT);
    }
    UIBarButtonItem *backBarItem = [PublicFunctions getCustomNavButtonOnLeftSide:YES
                                                                          target:self
                                                                           image:[UIImage imageNamed:@"nav_back.png"]
                                                                        selector:@selector(shouldPullBack)];
    [self.navigationItem addLeftBarButtonItem:backBarItem];
    [backBarItem release];
    _decoding = NO;
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    _decoding = YES;
    //[self.view addSubview:_overlayView];
    //[_overlayView setPoints:nil];
    [self startAlphaAnimation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[_overlayView removeFromSuperview];
    [self stopCapture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shouldPullBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startAlphaAnimation
{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         _shutterLight.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2f
                                          animations:^{
                                              _shutterLight.alpha = 0.0f;
                                          }
                                          completion:^(BOOL finished){
                                              [self startTranslateAnimation];
                                          }];
                     }];
}

- (void)startTranslateAnimation
{
    CGFloat topY;
    CGFloat topHeight;
    CGFloat bottomHeight;
    if ([DeviceHelper isIphone5]) {
        topY = - SHUTTER_TOP_HEIGHT_IPHONE5 + NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT;
        topHeight = SHUTTER_TOP_HEIGHT_IPHONE5;
        bottomHeight = SHUTTER_BOTTOM_HEIGHT__IPHONE5;
    } else {
        topY = - SHUTTER_TOP_HEIGHT + NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT;
        topHeight = SHUTTER_TOP_HEIGHT;
        bottomHeight = SHUTTER_BOTTOM_HEIGHT;
    }
    [UIView animateWithDuration:0.3f
                     animations:^{
                         _shutterTop.transform = CGAffineTransformIdentity;
                         _shutterTop.frame = CGRectMake(0, topY, [UISize screenWidth], topHeight);
                         _shutterBottom.transform = CGAffineTransformIdentity;
                         _shutterBottom.frame = CGRectMake(0, [UISize screenHeight], [UISize screenHeight], bottomHeight);
                     }
                     completion:^(BOOL finished){
                         _shutterTop.alpha = 0.0f;
                         [self initCapture];

                     }];
}

- (void)initCapture
{
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    if (!captureInput) {
        return;
    }
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString *key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber *value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    _session = [[AVCaptureSession alloc] init];
    
    NSString *preset = 0;
    if (!preset) {
        preset = AVCaptureSessionPresetMedium;
    }
    _session.sessionPreset = preset;
    
    [_session addInput:captureInput];
    [_session addOutput:captureOutput];
    [captureOutput release];
    
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    }
    _previewLayer.frame = self.view.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewView.layer addSublayer:_previewLayer];
    NSLog(@"view.layer sublayer count : %zi", self.view.layer.sublayers.count);
    [_session startRunning];
}

- (void)stopCapture
{
    _decoding = NO;
    [_session stopRunning];
    AVCaptureInput *input = [_session.inputs objectAtIndex:0];
    [_session removeInput:input];
    AVCaptureVideoDataOutput *output = [_session.outputs objectAtIndex:0];
    [_session removeOutput:output];
    [_previewLayer removeFromSuperlayer];
    
    _previewLayer = nil;
    _session = nil;
}

- (void) toggleTorch:(BOOL) on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        [device lockForConfiguration:nil];
        if ([device hasTorch]) {
            if (on) {
                // Turn on the torch
                [device setTorchMode:AVCaptureTorchModeOn];
                [_buttonTorch setImage:[UIImage imageNamed:@"qr_scan_flash_on.png"] forState:UIControlStateNormal];
            } else {
                // Turn off the torch
                [device setTorchMode:AVCaptureTorchModeOff];
                [_buttonTorch setImage:[UIImage imageNamed:@"qr_scan_flash.png"] forState:UIControlStateNormal];
                [_buttonTorch setImage:[UIImage imageNamed:@"qr_scan_flash_p.png"] forState:UIControlStateSelected];
            }
        }
        [device unlockForConfiguration];
    }
}

- (BOOL)torchIsOn
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch]) {
            return [device torchMode] == AVCaptureTorchModeOn;
        }
    }
    return NO;
}

# pragma mark DecoderDelegate
- (void)decoder:(Decoder *)decoder willDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset
{
    NSLog(@"decoding image (%.0fx%.0f)...", image.size.width, image.size.height);
}

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)result
{
    NSString *resultString = [result text];
    NSLog(@"result string is : %@", resultString);
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    [_indicatorImage setImage:subset];
    NSLog(@"failed to decode ressult : %@", reason);
}

- (void)decoder:(Decoder *)decoder foundPossibleResultPoint:(CGPoint)point
{
    NSLog(@"found possible result point");
    //[_overlayView setPoint:point];
}

- (void)cancelled
{
    
}

# pragma mark Capture Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
//    if (!_decoding) {
//        return;
//    }
//    
//    CVImageBufferRef imageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer);
//    // Lock the image buffer
//    CVPixelBufferLockBaseAddress(imageBufferRef, 0);
//    // Get information about the image
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBufferRef);
//    size_t width = CVPixelBufferGetWidth(imageBufferRef);
//    size_t height = CVPixelBufferGetHeight(imageBufferRef);
//    
//    uint8_t *baseAddress = CVPixelBufferGetBaseAddress(imageBufferRef);
//    void *free_me = 0;
//    if (true) {
//        uint8_t *tmp = baseAddress;
//        int bytes = bytesPerRow * height;
//        free_me = baseAddress = (uint8_t *)malloc(bytes);
//        baseAddress[0] = 0xdb;
//        memcpy(baseAddress, tmp, bytes);
//    }
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace,
//                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);
//    
//    CGImageRef capture = CGBitmapContextCreateImage(context);
//    CVPixelBufferUnlockBaseAddress(imageBufferRef, 0);
//    free(free_me);
//    
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    
//    if (false) {
//        CGRect cropRect = [_overlayView cropRect];
//        
//        {
//            float height = CGImageGetHeight(capture);
//            float width = CGImageGetWidth(capture);
//            CGRect screen = [[UIScreen mainScreen] bounds];
//            float tmp = screen.size.width;
//            screen.size.width = screen.size.height;
//            screen.size.height = tmp;
//            
//            cropRect.origin.x = (width - cropRect.size.width) / 2;
//            cropRect.origin.y = (height - cropRect.size.height)/ 2;
//        }
//        
//        CGImageRef newImage = CGImageCreateWithImageInRect(capture, cropRect);
//        CGImageRelease(capture);
//        capture = newImage;
//    }
//    
//    UIImage *resultImage = [[[UIImage alloc] initWithCGImage:capture] autorelease];
//    CGImageRelease(capture);
//    
//    NSLog(@"did output simple buffer image size (%.0fx%.0f)...", resultImage.size.width, resultImage.size.height);
//    
//    //[self.view addSubview:[[UIImageView alloc] initWithImage:resultImage]];
//    Decoder *decoder = [[Decoder alloc] init];
//    decoder.readers = _readers;
//    decoder.delegate = self;
//    
//    _decoding = [decoder decodeImage:resultImage] == YES ? NO : YES;
//    
//    [decoder release];
//    
//    if (_decoding) {
//        decoder = [[Decoder alloc] init];
//        decoder.readers = _readers;
//        decoder.delegate = self;
//        resultImage = [[[UIImage alloc] initWithCGImage:resultImage.CGImage
//                                                  scale:1.0f
//                                            orientation:UIImageOrientationLeft] autorelease];
//        _decoding = [decoder decodeImage:resultImage] == YES ? NO : YES;
//        [decoder release];
//    }
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    [self decodeImage:image];
}

- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace) {
        return nil;
    }
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little, provider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return [image autorelease];
}

- (void)decodeImage:(UIImage *)image
{
    Decoder *decoder = [[Decoder alloc] init];
    decoder.delegate = self;
    decoder.readers  = _readers;
    [decoder decodeImage:image];
}

- (IBAction)shouldChoosePhoto:(UIButton *)sender {
}

- (IBAction)shouldGotoMyQRCode:(UIButton *)sender {
}

- (IBAction)shouldChangeTorch:(UIButton *)sender {
    BOOL torch = [self torchIsOn];
    [self toggleTorch:!torch];
}

- (void)dealloc {
    [_shutterTop release];
    [_shutterBottom release];
    [_shutterLight release];
    [_buttonPhoto release];
    [_buttonTorch release];
    [_buttonQR release];
    [_shutterBg release];
    [_previewView release];
    [_indicatorImage release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setShutterTop:nil];
    [self setShutterBottom:nil];
    [self setShutterLight:nil];
    [self setButtonPhoto:nil];
    [self setButtonTorch:nil];
    [self setButtonQR:nil];
    [self setShutterBg:nil];
    [self setPreviewView:nil];
    [self setIndicatorImage:nil];
    [super viewDidUnload];
}

@end
