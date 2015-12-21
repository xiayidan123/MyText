//
//  QRShowViewController.m
//  wowcity
//
//  Created by jianxd on 14-11-20.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "QRShowViewController.h"
#import "AvatarHelper.h"
#import "Buddy.h"
#import "WTUserDefaults.h"
#import "WowTalkWebServerIF.h"
#import "WTUserDefaults.h"
#import "WTError.h"
#import "Constants.h"
#import "ImageNameConstant.h"
#import "JSONKit.h"
#import "PublicFunctions.h"
#import "CustomActionSheet.h"
#import <QREncoder.h>
#import "UISize.h"
#import "DeviceHelper.h"
#import "WTHeader.h"
#import "OMHeadImgeView.h"
#import "WowTalkWebServerIF.h"
#import "OMSaveImageRemindView.h"
#define MARGIN_VERTICAL             30
#define MARGIN_VERTICAL_IPHONE5     40
#define IMAGE_SIZE                  200
#define IMAGE_SIZE_IPHONE5          240

@interface QRShowViewController ()<OMSaveImageRemindViewDelegate,UIActionSheetDelegate>

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *introductionLabel;

@property (retain, nonatomic) IBOutlet UIImageView *qrCodeImage;
@property (retain, nonatomic) IBOutlet UIView *bg_view;
@property (retain, nonatomic) IBOutlet OMHeadImgeView *headImage_view;

@property (retain, nonatomic) UIBarButtonItem *saveButton;

@end

@implementation QRShowViewController

- (void)dealloc {
    [_nameLabel release];
    [_introductionLabel release];
    [_qrCodeImage release];
    [_bg_view release];
    [_headImage_view release];
    [_saveButton release];
    
    [super dealloc];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self uiConfig];
}

- (void)uiConfig{
    [self initNavigationBar];
    
    self.bg_view.layer.masksToBounds = YES;
    self.bg_view.layer.cornerRadius = 5;
    
    self.nameLabel.text = [WTUserDefaults getNickname];
    
    [self loadHeadImageWithNetWork:YES];
    
    self.headImage_view.headImageCornerRadius = 5;
    
    [self.introductionLabel setText:NSLocalizedString(@"Scan QRCode to add", nil)];
    
    [self shouldEncodeInfoToQRImage];
}

- (void)initNavigationBar
{
    self.title = NSLocalizedString(@"QRCode My QRCode", nil);
    
    self.saveButton = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:NAV_DOWNLOAD_IMAGE] style:UIBarButtonItemStylePlain target:self action:@selector(saveQRImage)] autorelease];
    self.navigationItem.rightBarButtonItem = self.saveButton;
}


- (void)shouldEncodeInfoToQRImage
{
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    NSDate *dateNow = [NSDate date];
    long timestamp = [dateNow timeIntervalSince1970];
    NSString *uid = [WTUserDefaults getUid];
    [contentDic setObject:uid forKey:@"uid"];
    [contentDic setObject:[NSString stringWithFormat:@"%ld", timestamp] forKey:@"timestamp"];
    [jsonDic setObject:@"WTH_QR_CODE_CHECK" forKey:@"label"];
    [jsonDic setObject:@"0" forKey:@"type"];
    [jsonDic setObject:contentDic forKey:@"content"];
    NSString *strJson = [jsonDic JSONString];
    DataMatrix *qrMatrix = [QREncoder encodeWithECLevel:QR_LEVEL_H version:QR_VERSION_AUTO string:strJson];
    UIImage *codeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:250];
    self.qrCodeImage.image = codeImage;
}


- (void)loadHeadImageWithNetWork:(BOOL)needNetWorking{
    Buddy *user = [Database buddyWithUserID:[WTUserDefaults getUid]];
    self.headImage_view.buddy = user;
}

- (void)saveQRImage{
    
    UIImage *image = [self snapshot:self.bg_view];
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
    
    OMSaveImageRemindView *saveImageRemindView = [OMSaveImageRemindView OMSaveImageRemindView];
    saveImageRemindView.title = @"已保存到手机相册";
    saveImageRemindView.delegate = self;
    [saveImageRemindView showInSuperView:self.view];
    self.saveButton.enabled = NO;
}


- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - OMSaveImageRemindViewDelegate

-(void)hiddenOMSaveImageRemindView:(OMSaveImageRemindView *)saveImageRemindView{
    self.saveButton.enabled = YES;
}


@end
