//
//  QRScanResultViewController.h
//  dev01
//
//  Created by jianxd on 14-11-26.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "OMViewController.h"
@class Buddy;

@interface QRScanResultViewController : OMViewController

@property (retain, nonatomic) IBOutlet UIView *resultView;
@property (retain, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIButton *addButton;

@property (retain, nonatomic) Buddy *buddy;
- (IBAction)addBuddy:(UIButton *)sender;

@end
