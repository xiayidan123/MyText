//
//  LoginFromQRViewController.h
//  dev01
//
//  Created by macbook air on 14-9-28.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Decoder.h>



@interface LoginFromQRViewController : UIViewController<DecoderDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (retain, nonatomic) IBOutlet UIButton *btnBack;
@property (retain, nonatomic) IBOutlet UIView *scanmaskView;
@property (retain, nonatomic) IBOutlet UIImageView *scanBar;



- (IBAction)backClick:(id)sender;


@end

