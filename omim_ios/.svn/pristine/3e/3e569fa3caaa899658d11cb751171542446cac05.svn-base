//
//  QRScanResultViewController.m
//  dev01
//
//  Created by jianxd on 14-11-26.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "QRScanResultViewController.h"
#import "PublicFunctions.h"
#import "AvatarHelper.h"
#import "Constants.h"
#import "WowTalkWebServerIF.h"
#import "UISize.h"
#import "Buddy.h"
#import "WTError.h"
#import "AddContactViewController.h"

@interface QRScanResultViewController ()<UIAlertViewDelegate>

@end

@implementation QRScanResultViewController

@synthesize resultView = _resultView;
@synthesize thumbImageView = _thumbImageView;
@synthesize nameLabel = _nameLabel;
@synthesize addButton = _addButton;
@synthesize buddy = _buddy;


- (void)dealloc {
    [_resultView release],_resultView = nil;
    [_thumbImageView release],_thumbImageView = nil;
    [_nameLabel release],_nameLabel = nil;
    [_addButton release],_addButton = nil;
    [_buddy release],_buddy = nil;
    [super dealloc];
}
- (void)viewDidUnload {
    [self setResultView:nil];
    [self setThumbImageView:nil];
    [self setNameLabel:nil];
    [self setAddButton:nil];
    [self setBuddy:nil];
    [super viewDidUnload];
}

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
    NSLog(@"view did load");
    // Do any additional setup after loading the view from its nib.
    [self configNavigationBar];
    self.nameLabel.text = _buddy.nickName;
    [self.addButton setBackgroundImage:[PublicFunctions strecthableImage:LARGE_BLUE_BUTTON]
                    forState:UIControlStateNormal];
    self.addButton.enabled = YES;
    [self.addButton setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
     [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [self.addButton.titleLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:20]];
     
    
    [self.addButton addTarget:self action:@selector(addBuddy:) forControlEvents:UIControlEventTouchUpInside];
    self.thumbImageView.frame = CGRectMake(115, 7, 90, 90);
    NSData *data = [AvatarHelper getAvatarForUser:_buddy.userID];
    [self.thumbImageView setImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    [self.view addSubview:self.addButton];
    if (data) {
        [self.thumbImageView setImage:[UIImage imageWithData:data]];
    }  else {
        if (_buddy.needToDownloadThumbnail) {
            [WowTalkWebServerIF getThumbnailForUserID:_buddy.userID withCallback:@selector(didDownloadThumb:) withObserver:self];
        }
    }
    //修改前代码开始
    //    CGSize labelSize = [self.buddy.nickName sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(320, 21)];
    //修改前代码结束
    
    //修改人：李国权 ||  修改时间：2015年12月16日  ||  说明：sizeWithFont: 根据内容改变label高度方法（已弃用），boundingRectWithSize方法替代
    
    //修改后代码开始
    CGSize size = CGSizeMake(320, 2000);
    UIFont *font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    CGSize labelSize = [self.buddy.nickName boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    //修改后代码结束
    
    CGFloat resultViewHeight = 0;
    self.nameLabel.frame = CGRectMake((320 - labelSize.width) / 2, self.nameLabel.frame.origin.y, labelSize.width, labelSize.height);
    if ([self.buddy.buddy_flag isEqualToString:@"1"]) {
        // if this is a friend or just myself, hide the add friend button.
        self.addButton.hidden = YES;
        resultViewHeight = self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height;
    } else {
        // if this is a buddy but not my friend, then show the add friend button.
        self.addButton.hidden = NO;
        self.addButton.frame = CGRectMake(100, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 10, 120, 44);
        resultViewHeight = self.addButton.frame.origin.y + self.addButton.frame.size.height;
    }
    self.resultView.frame = CGRectMake(0, (self.view.frame.size.height - [UISize heightOfStatusBarAndNavBar] - resultViewHeight) / 2, 320, resultViewHeight);
    self.addButton.frame = CGRectMake(100.0, self.resultView.frame.origin.y + self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 10.0, 120.0, 44.0);
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)configNavigationBar
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"Add contacts", nil);
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    UIBarButtonItem *backButtonItem = [PublicFunctions getCustomNavButtonOnLeftSide:YES
                                                                             target:self
                                                                              image:[UIImage imageNamed:NAV_BACK_IMAGE]
                                                                           selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:backButtonItem];
}

- (void)goBack
{
    // go back to the AddContactViewController
    for (UIViewController *viewController in [self.navigationController viewControllers]) {
        if ([viewController isKindOfClass:[AddContactViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}

- (void)didDownloadThumb:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSData *data = [AvatarHelper getThumbnailForUser:_buddy.userID];
        if (data) {
            _thumbImageView.image = [UIImage imageWithData:data];
        }
    }
}

- (void)didAddBuddy:(NSNotification *)notification
{
    NSError *error = [[notification userInfo] objectForKey:@"error"];
    if (error && error.code != 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to send request", nil)
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Request is sent", nil)
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil, nil];
        self.addButton.enabled = NO;
        [alertView show];
        [alertView release];
    }
}



- (IBAction)addBuddy:(UIButton *)sender {
    NSLog(@"add button click...");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Add this user as a friend",nil) message:NSLocalizedString(@"self introduction",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"发送",nil), nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 2011;
    [alert show];
    [alert release];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [WowTalkWebServerIF addBuddy:_buddy.userID withMsg:@"" withCallback:@selector(didAddBuddy:) withObserver:self];
//    });
}


#pragma mark -
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2011){
        switch (buttonIndex) {
            case 1:{
                if (self.buddy){
                    UITextField *tf = [alertView textFieldAtIndex:0];
                    [WowTalkWebServerIF addBuddy:_buddy.userID withMsg:tf.text withCallback:@selector(didAddBuddy:) withObserver:self];
                }
            }break;
            default:
                break;
        }
    }
}

@end
