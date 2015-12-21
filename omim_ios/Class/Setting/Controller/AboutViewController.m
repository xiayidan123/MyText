//
//  AboutViewController.m
//  omim
//
//  Created by coca on 2013/02/21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "AboutViewController.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "Colors.h"
#import "WTHeader.h"




@interface AboutViewController ()

@property (nonatomic,retain) IBOutlet UIImageView* imageView_icon;


@property (retain, nonatomic) IBOutlet NSLayoutConstraint *icon_width;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *icon_height;

@property (nonatomic,retain) IBOutlet UIButton* support_btn;
@property (nonatomic,retain) IBOutlet UILabel* lbl_name;
@property (nonatomic,retain) IBOutlet UILabel* lbl_version;
@property (nonatomic,retain) IBOutlet UILabel* lbl_company;
@property (retain, nonatomic) IBOutlet UIImageView *iv_background;

@end

@implementation AboutViewController

- (void)dealloc {
    [_imageView_icon release];
    [_support_btn release];
    [_lbl_name release];
    [_lbl_version release];
    [_lbl_company release];
    [_iv_background release];
    [_icon_width release];
    [_icon_height release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"About",nil);
    
    
    
    self.lbl_version.text = [NSString stringWithFormat:@"Ver %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]];

    NSString* strcompany = @"©2014-2015 Onemeter Inc.";
	self.lbl_company.text = [NSString stringWithFormat:@"%@",strcompany];
    
    [self.support_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.support_btn setTitle:@"" forState:UIControlStateNormal];
    [self.support_btn addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.support_btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    UIImage *icon_image = [UIImage imageNamed:@"defoult_logo.png"];
    self.icon_height.constant = icon_image.size.height;
    self.icon_width.constant = icon_image.size.width;
    self.imageView_icon.image = icon_image;
}

-(void)sendMail
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support@onemeter.co"]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}





@end
