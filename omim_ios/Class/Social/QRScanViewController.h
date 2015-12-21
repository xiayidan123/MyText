//
//  QRScanViewController.h
//  wowcity
//
//  Created by jianxd on 14-11-14.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#include <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "Decoder.h"
#import "parsedResults/ParsedResult.h"

@interface QRScanViewController : UIViewController<DecoderDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (retain, nonatomic) NSMutableSet *readers;
@property (retain, nonatomic) IBOutlet UIImageView *indicatorImage;


@property (retain, nonatomic) IBOutlet UIView *previewView;
@property (retain, nonatomic) IBOutlet UIImageView *shutterBg;

@property (retain, nonatomic) IBOutlet UIImageView *shutterTop;
@property (retain, nonatomic) IBOutlet UIImageView *shutterBottom;
@property (retain, nonatomic) IBOutlet UIImageView *shutterLight;

@property (retain, nonatomic) IBOutlet UIButton *buttonPhoto;
@property (retain, nonatomic) IBOutlet UIButton *buttonTorch;
@property (retain, nonatomic) IBOutlet UIButton *buttonQR;


- (IBAction)shouldChoosePhoto:(UIButton *)sender;
- (IBAction)shouldGotoMyQRCode:(UIButton *)sender;
- (IBAction)shouldChangeTorch:(UIButton *)sender;

@end
