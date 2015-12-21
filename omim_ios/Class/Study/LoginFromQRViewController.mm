//
//  LoginFromQRViewController.m
//  dev01
//
//  Created by macbook air on 14-9-28.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "LoginFromQRViewController.h"
#import <QRCodeReader.h>
#import <TwoDDecoderResult.h>
#import "AppDelegate.h"

@interface LoginFromQRViewController ()
{
    BOOL _isScaning;
    AVCaptureSession *_session;//会话：摄像头和机器之间的会话
    AVCaptureVideoPreviewLayer *_layer;
    //输出有很多种，这里用的是图片输出
    AVCaptureVideoDataOutput *_output;
    NSMutableSet *_qrReader;
}

@end

@implementation LoginFromQRViewController

- (void)dealloc {
    [_btnBack release];
    [_scanmaskView release];
    [_scanBar release];
    
    [_session release];
    [_output release];
    [_layer release];
    [_qrReader release];
    [super dealloc];
}

#pragma mark - View Handler
- (void)viewDidLoad {
    
    [super viewDidLoad];
    BOOL Custom= [UIImagePickerController
                  isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];//判断摄像头是否能用
    if (Custom) {
        [self initCapture];//启动摄像头
    }
    
    [self.view bringSubviewToFront:_scanBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [_session stopRunning];
    _isScaning = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Functions
- (void)scanBaraAnimate{
    if (_isScaning){
        _scanBar.center = CGPointMake(_scanBar.center.x, -2);
        [UIView animateWithDuration:2.5 animations:^{
            _scanBar.center = CGPointMake(_scanBar.center.x, 221);
        } completion:^(BOOL finished) {
            [self scanBaraAnimate];
        }];
    }
}



- (void)initCapture
{
    _session = [[AVCaptureSession alloc] init];
    
    //设置当前摄像头的像素值
//    _session.sessionPreset = AVCaptureSessionPreset1280x720;
    //层
    _layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    _layer.backgroundColor = [UIColor redColor].CGColor;
//    _layer.frame = CGRectMake(-80, 60, 500, 600);
    _layer.frame = self.view.bounds;
    //讲这个层放到self.view上面
    [self.view.layer insertSublayer:_layer atIndex:0];
    //硬件输入设备
    //获取一个硬件
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建一个输入，依赖上面的硬件
    AVCaptureDeviceInput *_input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
//    [device release];
    [_session addInput:_input];
    [_input release];
    
    //创建一个输出
    _output = [[AVCaptureVideoDataOutput alloc]init];
    _output.alwaysDiscardsLateVideoFrames = YES;
    
    [_output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [_output setVideoSettings:videoSettings];
    
    NSString* preset = 0;
    if (!preset) {
        preset = AVCaptureSessionPresetMedium;
    }
    _session.sessionPreset = preset;
    
    [_session addOutput:_output];
//    [_output release];
    [_session startRunning];
    
    // 开启扫描条动画
    _isScaning = YES;
    [self scanBaraAnimate];
}


- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // 第一步，将sampleBuffer转成UIImage
    UIImage *image= [self imageFromSampleBuffer:sampleBuffer];
    // 第二步，用Decoder识别图象
    [self decodeImage:image];
//    [image release];
}


- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        return nil;
    }
    
    // Get the base address of the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize,
                                                              NULL);
    // Create a bitmap image from data supplied by our data provider
    CGImageRef cgImage =
    CGImageCreate(width,
                  height,
                  8,
                  32,
                  bytesPerRow,
                  colorSpace,
                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  provider,
                  NULL,
                  true,
                  kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    // Create and return an image object representing the specified Quartz image
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return image;
}

- (void)decodeImage:(UIImage *)image
{
    NSMutableSet *qrReader = [[NSMutableSet alloc] init];
    QRCodeReader *qrcoderReader = [[QRCodeReader alloc] init];
    [qrReader addObject:qrcoderReader];
    [qrcoderReader release];
    
    Decoder *decoder = [[Decoder alloc] init];
    decoder.delegate = self;
    decoder.readers = qrReader;
    [decoder decodeImage:image];
    [qrReader release];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)result
{
    _isScaning = NO;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 300)];
    label.text = result.text;
    [self.view addSubview:label];
    [label release];
    [_session stopRunning];
    
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    if (!_isScaning) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有发现二维码" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}
+(NSString*)zhengze:(NSString*)str
{
    NSError *error;
    //http+:[^\\s]* 这是检测网址的正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s^net^com]*" options:0 error:&error];//筛选
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            //从urlString中截取数据
            NSString *result1 = [str substringWithRange:resultRange];
            return result1;
            
        }
    }
    return nil;
}
















@end
