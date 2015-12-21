//
//  ContactInfoViewController.m
//  omim
//
//  Created by Harry on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "ContactInfoViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"
#import "PublicFunctions.h"
#import "WTHeader.h"
#import "Constants.h"
#import "TabBarViewController.h"
#import "MessagesVC.h"
#import "OMBuddySpaceViewController.h"
#import "WowTalkVoipIF.h"
#import "GalleryViewController.h"
#import "OMMessageVC.h"

@interface ContactInfoViewController ()
{
    BOOL isIOS7ApplyInfoDialogShown;
    UIView *IOS7ApplyAlertView;
    CGRect IOS7ApplyAlertViewFrameOriginal;
}
@property (nonatomic, assign) BOOL chooseToCall;
@property (nonatomic, retain) UILabel *lbl_addFriend;
@property (nonatomic, retain) UIButton *btn_action; // view moments
@property (nonatomic, retain) UIAlertView *inputAliasAlert;
@property (nonatomic, retain) UIAlertView *deleteFriendAlert;
@property (nonatomic, retain) UILabel *aliasLabel;
@property (nonatomic, copy) NSString *inputedAlias;

@end

@implementation ContactInfoViewController

@synthesize chooseToCall = _chooseToCall;
@synthesize lbl_addFriend = _lbl_addFriend;
@synthesize tableView = _tableView;
@synthesize buddy = _buddy;
@synthesize btn_makecall = _btn_makecall;
@synthesize contact_type = _contact_type;
@synthesize imageview = _imageview;

@synthesize inputAliasAlert = _inputAliasAlert;
@synthesize aliasLabel = _aliasLabel;
@synthesize inputedAlias = _inputedAlias;
@synthesize deleteFriendAlert = _deleteFriendAlert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ContactInfoViewController" bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)getBuddyThumbnail:(NSNotification *)notification
{
    NSData *data = [AvatarHelper getThumbnailForUser:_buddy.userID];
    if (data) {
        self.imageview.image = [UIImage imageWithData:data];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc
{
    [_tableView release],_tableView.delegate = nil,_tableView.dataSource = nil,_tableView = nil;
    [_buddy release],_buddy = nil;
    [_imageview release],_imageview = nil;
    [_lbl_addFriend release],_lbl_addFriend = nil;
    [_btn_action release],_btn_action = nil;
    [_btn_message release],_btn_message = nil;
    [_btn_makecall release],_btn_makecall = nil;
    [_inputAliasAlert release],_inputAliasAlert = nil;
    [_inputedAlias release],_inputedAlias = nil;
    [_aliasLabel release],_aliasLabel = nil;
    
    [_headImageView release],_headImageView = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    self.tableView = nil;
    self.imageview = nil;
    self.buddy = nil;
    self.btn_makecall = nil;
    self.btn_message = nil;
    self.btn_action = nil;
    self.lbl_addFriend = nil;
    [self setInputedAlias:nil];
    [self setAliasLabel:nil];
}

//TODO: have to check here. view large photo
- (void)viewAvatar
{
    // if it has no avatar, return.
    if ([NSString isEmptyString:self.buddy.pathOfThumbNail]) {
        return;
    }
    GalleryViewController *galleryViewController = [[GalleryViewController alloc] init];
    galleryViewController.isViewBuddyAvatar = YES;
    galleryViewController.buddy = self.buddy;
    [self.navigationController pushViewController:galleryViewController animated:YES];
    [galleryViewController release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNav];
    
    UIView *topview = [[[UIView alloc] initWithFrame:CGRectMake(0, -480, 320, 480)] autorelease];
    topview.backgroundColor = [Colors blackColorUnderTable];
    [self.view addSubview:topview];
    
    
    
    
    _imageview = [[UIImageView alloc]initWithFrame:
                  CGRectMake(PERSON_INFO_X_14, PERSON_INFO_Y_14, PERSON_INFO_MSG_BUTTON_WIDTH, PERSON_INFO_MSG_BUTTON_HEIGHT)];
    _imageview.layer.masksToBounds = YES;
    _imageview.layer.cornerRadius = 45.0f;
    [self.view addSubview:_imageview];
    
    
    _headImageView = [[OMHeadImgeView alloc]initWithFrame:
                  CGRectMake(PERSON_INFO_X_14, PERSON_INFO_Y_14, PERSON_INFO_MSG_BUTTON_WIDTH, PERSON_INFO_MSG_BUTTON_HEIGHT)];
    _headImageView.buddy = _buddy;
    [self.view addSubview:_headImageView];

    UIButton* button = [[UIButton alloc] initWithFrame:_imageview.frame];
    [button addTarget:self action:@selector(viewAvatar) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:button];
    [button release];
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
    }
    isIOS7ApplyInfoDialogShown=false;
    
    switch (self.contact_type) {
        case CONTACT_FRIEND:
        {
            NSData *data = [AvatarHelper getThumbnailForUser:_buddy.userID];
            if (data)
                self.headImageView.headImage = [UIImage imageWithData:data];
            else
            {
                self.headImageView.headImage = [UIImage imageNamed:DEFAULT_AVATAR];
            }
            
            if (_buddy.needToDownloadThumbnail) {
                [WowTalkWebServerIF getThumbnailForUserID:_buddy.userID withCallback:@selector(getBuddyThumbnail:) withObserver:self];
            }
            
            
            UILabel *nameLabel= [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118, PERSON_INFO_Y_10,PERSON_INFO_WIDTH_160, PERSON_INFO_HEIGHT_20)];
            nameLabel.adjustsFontSizeToFitWidth = YES;
            nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_17];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.shadowColor = [UIColor blackColor];
            nameLabel.shadowOffset = CGSizeMake(1, 1);
            nameLabel.text = _buddy.nickName;
            nameLabel.tag = 10002;
            
            
            CGFloat idOffsetY;
            if (![NSString isEmptyString:_buddy.alias]) {
                idOffsetY = 55.0f;
                NSString *aliasText = NSLocalizedString(@"Alias :", nil);
                CGSize aliasLabelSize = [aliasText sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE_12]
                                              constrainedToSize:CGSizeMake(320, 1000)
                                                  lineBreakMode:NSLineBreakByWordWrapping];
                UILabel *aliasLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118, 35, aliasLabelSize.width, PERSON_INFO_HEIGHT_15)];
                aliasLabel.adjustsFontSizeToFitWidth = NO;
                aliasLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                aliasLabel.backgroundColor = [UIColor clearColor];
                aliasLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_REMARK_FONT_COLOR];
                aliasLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_12];
                aliasLabel.textAlignment = NSTextAlignmentLeft;
                aliasLabel.text = aliasText;
                aliasLabel.shadowColor = [UIColor blackColor];
                aliasLabel.shadowOffset = CGSizeMake(1, 1);
                
                CGRect aliasValueFrame = CGRectMake(aliasLabel.frame.origin.x + aliasLabel.frame.size.width + 6, 35, PERSON_INFO_WIDTH_120, PERSON_INFO_HEIGHT_15);
                UILabel *aliasValueLabel = [[UILabel alloc] initWithFrame:aliasValueFrame];
                aliasValueLabel.adjustsFontSizeToFitWidth = NO;
                aliasValueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                aliasValueLabel.backgroundColor = [UIColor clearColor];
                aliasValueLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_REMARK_FONT_COLOR];
                aliasValueLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_12];
                aliasValueLabel.textAlignment = NSTextAlignmentLeft;
                aliasValueLabel.text = _buddy.alias;
                aliasValueLabel.shadowColor = [UIColor blackColor];
                aliasValueLabel.shadowOffset = CGSizeMake(1, 1);
                self.aliasLabel = aliasValueLabel;
                
                [self.view addSubview:aliasLabel];
                [self.view addSubview:aliasValueLabel];
                [aliasLabel release];
                [aliasValueLabel release];
            } else {
                idOffsetY = 40.0f;
            }
            
            
            NSString *idText = NSLocalizedString(@"WowTalk ID", nil);
            CGSize idLabelSize = [idText sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE_12] constrainedToSize:CGSizeMake(320, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118, idOffsetY, idLabelSize.width, PERSON_INFO_HEIGHT_15)];
            idLabel.adjustsFontSizeToFitWidth = NO;
            idLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            idLabel.backgroundColor = [UIColor clearColor];
            idLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_REMARK_FONT_COLOR];
            idLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_12];
            idLabel.textAlignment = NSTextAlignmentLeft;
            idLabel.text = NSLocalizedString(@"WowTalk ID",nil);
            idLabel.shadowColor = [UIColor blackColor];
            idLabel.shadowOffset = CGSizeMake(1.0, 1.0);
            
            CGRect idValueFrame = CGRectMake(idLabel.frame.origin.x + idLabel.frame.size.width + 6, idOffsetY, PERSON_INFO_WIDTH_120, PERSON_INFO_HEIGHT_15);
            UILabel *idValueLabel = [[UILabel alloc] initWithFrame:idValueFrame];
            idValueLabel.adjustsFontSizeToFitWidth = NO;
            idValueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            idValueLabel.backgroundColor = [UIColor clearColor];
            idValueLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_REMARK_FONT_COLOR];
            idValueLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_12];
            idValueLabel.textAlignment = NSTextAlignmentLeft;
            idValueLabel.text = [Database getWowtalkidForUser:_buddy.userID];//buddy.nickName;
            idValueLabel.shadowColor = [UIColor blackColor];
            idValueLabel.shadowOffset = CGSizeMake(1.0, 1.0);
 
            
            [self.view addSubview:nameLabel];
            [self.view addSubview:idLabel];
            [self.view addSubview:idValueLabel];
            [nameLabel release];
            [idLabel release];
            [idValueLabel release];
            
            
            [self.btn_message setFrame:CGRectMake(118.0f, 74.0f, 60.0f, 36.0f)];
            [self.btn_message setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];
            [self.btn_message setImage:[UIImage imageNamed:@"profile_btn_message.png"] forState:UIControlStateNormal];
            [self.btn_message setImage:[UIImage imageNamed:@"profile_btn_message_p.png"] forState:UIControlStateHighlighted];

            
            [self.btn_makecall setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];
            [self.btn_makecall setFrame:CGRectMake(183.0f, 74.0f, 60.0f, 36.0f)];
            [self.btn_makecall setImage:[UIImage imageNamed:@"profile_btn_call.png"] forState:UIControlStateNormal];
            [self.btn_makecall setImage:[UIImage imageNamed:@"profile_btn_call_p.png"] forState:UIControlStateHighlighted];
            [self.btn_makecall addTarget:self action:@selector(makeCall:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *videoButton = [[[UIButton alloc] initWithFrame:CGRectMake(248.0f, 74.0f, 60.0f, 36.0f)] autorelease];
            [videoButton setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];
            [videoButton setImage:[UIImage imageNamed:@"profile_btn_video.png"] forState:UIControlStateNormal];
            [videoButton setImage:[UIImage imageNamed:@"profile_btn_video_p.png"] forState:UIControlStateHighlighted];
            [videoButton addTarget:self action:@selector(makeVideoCall:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:videoButton];
            
        }
            break;
            
        case CONTACT_GROUP:
        {
            [self.btn_makecall setHidden:YES];
            
            NSData *data = [AvatarHelper getThumbnailForUser:self.buddy.userID];
            if (data)
                self.headImageView.headImage = [UIImage imageWithData:data];
            else
            {
                self.headImageView.headImage = [UIImage imageNamed:DEFAULT_AVATAR];
            }
            
            if (_buddy.needToDownloadThumbnail)
            {
                [WowTalkWebServerIF getThumbnailForUserID:_buddy.userID withCallback:@selector(getBuddyThumbnail:) withObserver:self];
                
            }
            
            UILabel *nameLabel= [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118, PERSON_INFO_Y_10,PERSON_INFO_WIDTH_160, PERSON_INFO_HEIGHT_20)];
            nameLabel.adjustsFontSizeToFitWidth = YES;
            nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_17];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.shadowColor = [UIColor blackColor];
            nameLabel.shadowOffset = CGSizeMake(1, 1);
            nameLabel.text = _buddy.nickName;
            
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118,PERSON_INFO_Y_74,PERSON_INFO_WIDTH_90,PERSON_INFO_HEIGHT_37)];
            messageLabel.adjustsFontSizeToFitWidth = NO;
            messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            messageLabel.backgroundColor = [UIColor clearColor];
            messageLabel.textColor = [UIColor whiteColor];
            messageLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE_15];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.text = NSLocalizedString( @"Chat", nil);
            messageLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            messageLabel.shadowOffset = CGSizeMake(0, 1);
            
            NSString *idText = NSLocalizedString(@"Group ID:", nil);
            CGSize idLabelSize = [idText sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118, 40, idLabelSize.width, PERSON_INFO_HEIGHT_15)];
            idLabel.adjustsFontSizeToFitWidth = NO;
            idLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            idLabel.backgroundColor = [UIColor clearColor];
            idLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_REMARK_FONT_COLOR];
            idLabel.font = [UIFont boldSystemFontOfSize:15];
            idLabel.textAlignment = NSTextAlignmentLeft;
            idLabel.text = idText;
            idLabel.shadowColor = [UIColor blackColor];
            idLabel.shadowOffset = CGSizeMake(1, 1);
            
            UILabel *idValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(idLabel.frame.origin.x + idLabel.frame.size.width + 6, 40, PERSON_INFO_WIDTH_120, PERSON_INFO_HEIGHT_15)];
            idValueLabel.adjustsFontSizeToFitWidth = NO;
            idValueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            idValueLabel.backgroundColor = [UIColor clearColor];
            idValueLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_REMARK_FONT_COLOR];
            idValueLabel.font = [UIFont boldSystemFontOfSize:15];
            idValueLabel.textAlignment = NSTextAlignmentLeft;
            idValueLabel.text = [Database getWowtalkidForUser:_buddy.userID];//buddy.nickName;
            idValueLabel.shadowColor = [UIColor blackColor];
            idValueLabel.shadowOffset = CGSizeMake(1, 1);
            
            [self.view addSubview:messageLabel];
            [self.view addSubview:idLabel];
            [self.view addSubview:idValueLabel];
            [self.view addSubview:nameLabel];
            
            [nameLabel release];
            [idValueLabel release];
            [messageLabel release];
            [idLabel release];
            
            [self.btn_message setFrame:CGRectMake(118, 74, 90, 37)];
            [self.btn_message setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];
            [self.btn_message setImage:[UIImage imageNamed:@"profile_btn_message_p.png"] forState:UIControlStateNormal];
            [self.btn_message setImage:[UIImage imageNamed:@"profile_btn_message.png"] forState:UIControlStateHighlighted];


        }
            break;
        case CONTACT_STRANGER:
        {
            [self.btn_makecall setHidden:YES];
            
            NSData *data = [AvatarHelper getThumbnailForUser:self.buddy.userID];
            if (data)
                self.headImageView.headImage = [UIImage imageWithData:data];
            else
            {
                self.headImageView.headImage = [UIImage imageNamed:DEFAULT_AVATAR];
            }
            
            if (_buddy.needToDownloadThumbnail)
            {
                [WowTalkWebServerIF getThumbnailForUserID:_buddy.userID withCallback:@selector(getBuddyThumbnail:) withObserver:self];
            }
            
            UILabel *nameLabel= [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118, PERSON_INFO_Y_10,PERSON_INFO_WIDTH_160, PERSON_INFO_HEIGHT_20)];
            nameLabel.adjustsFontSizeToFitWidth = YES;
            nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_17];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.shadowColor = [UIColor blackColor];
            nameLabel.shadowOffset = CGSizeMake(1, 1);
            nameLabel.text = _buddy.nickName;
            
            self.lbl_addFriend = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118,PERSON_INFO_Y_74,PERSON_INFO_WIDTH_90,PERSON_INFO_HEIGHT_37)];
            _lbl_addFriend.adjustsFontSizeToFitWidth = NO;
            _lbl_addFriend.lineBreakMode = NSLineBreakByTruncatingTail;
            _lbl_addFriend.backgroundColor = [UIColor clearColor];
            _lbl_addFriend.textColor = [UIColor whiteColor];
            _lbl_addFriend.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE_15];
            _lbl_addFriend.textAlignment = NSTextAlignmentCenter;
            _lbl_addFriend.text = NSLocalizedString(@"Add friend",nil);
            _lbl_addFriend.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            _lbl_addFriend.shadowOffset = CGSizeMake(0, 1);
            
            [_lbl_addFriend setFrame:CGRectMake(_lbl_addFriend.frame.origin.x,
                                               _lbl_addFriend.frame.origin.y,
                                               [UILabel labelWidth:_lbl_addFriend.text FontType:15 withInMaxWidth:200]>90? [UILabel labelWidth:_lbl_addFriend.text FontType:15 withInMaxWidth:200]+ 20: 90,
                                               _lbl_addFriend.frame.size.height)];
            [self.btn_message setFrame:_lbl_addFriend.frame];
            
            [self.btn_message setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];

            
            NSString *labelText = NSLocalizedString(@"WowTalk ID", nil);
            CGSize idLabelSize = [labelText sizeWithFont:[UIFont boldSystemFontOfSize:15.0]
                                                                    constrainedToSize:CGSizeMake(320, 100)];
            UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118, 40, idLabelSize.width, PERSON_INFO_HEIGHT_15)];
            idLabel.adjustsFontSizeToFitWidth = NO;
            idLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            idLabel.backgroundColor = [UIColor clearColor];
            idLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_REMARK_FONT_COLOR];
            idLabel.font = [UIFont boldSystemFontOfSize:12];
            idLabel.textAlignment = NSTextAlignmentLeft;
            idLabel.text = labelText;
            idLabel.shadowColor = [UIColor blackColor];
            idLabel.shadowOffset = CGSizeMake(1, 1);
            
            UILabel *idValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118 + idLabelSize.width + 5, 40, PERSON_INFO_WIDTH_120, PERSON_INFO_HEIGHT_15)];
            idValueLabel.adjustsFontSizeToFitWidth = NO;
            idValueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            idValueLabel.backgroundColor = [UIColor clearColor];
            idValueLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_REMARK_FONT_COLOR];
            idValueLabel.font = [UIFont boldSystemFontOfSize:12];
            idValueLabel.textAlignment = NSTextAlignmentLeft;
//            idValueLabel.text = [Database getWowtalkidForUser:_buddy.userID];//buddy.nickName;
            idValueLabel.text = _buddy.wowtalkID;
            idValueLabel.shadowColor = [UIColor blackColor];
            idValueLabel.shadowOffset = CGSizeMake(1, 1);
            
            [self.view addSubview:_lbl_addFriend];
            [self.view addSubview:idLabel];
            [self.view addSubview:idValueLabel];
            [self.view addSubview:nameLabel];
            
            [nameLabel release];
            [idValueLabel release];
            [idLabel release];
        }
            break;
        default:
            break;
    }
}

#pragma mark - NavigationBar
- (void)configNav
{
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text =  NSLocalizedString(@"Details",nil);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:barButton];
    [barButton release];
    
    if (self.contact_type == CONTACT_FRIEND) {
        UIBarButtonItem *rightbarButton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_MORE_IMAGE] selector:@selector(moreOperation)];
        [self.navigationItem addRightBarButtonItem:rightbarButton];
        [rightbarButton release];
    }
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreOperation
{
    self.chooseToCall = NO;
    UIActionSheet *avatarSheet=[[UIActionSheet alloc]initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"Cancel" , nil)
                                            destructiveButtonTitle:NSLocalizedString(@"Remove friend", nil)
                                                 otherButtonTitles:NSLocalizedString(@"Set Remark", nil), nil];
    [avatarSheet showInView:self.view];
    [avatarSheet release];
}

#pragma mark -- action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_chooseToCall) {
        // make call
        if (buttonIndex == 0 ) {
            // make a normal call
            [self makeCall:nil];
        }
        else if(buttonIndex == 1){
            // make a video call
            [WowTalkVoipIF fNewOutgoingCall:self.buddy.userID withDisplayName:self.buddy.nickName withVideo:TRUE];
        }
    } else {
        if (buttonIndex == 0) {
            // remove friend//
            
            _deleteFriendAlert = [[UIAlertView alloc] initWithTitle:nil message:@"删除好友" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [_deleteFriendAlert show];

        }
        else if (buttonIndex == 1) {
            // set remark name
            UIAlertView *alertView = [[UIAlertView alloc] init];
            alertView.title = NSLocalizedString(@"Set Remark", nil);
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView addButtonWithTitle:NSLocalizedString(@"OK", nil)];
            [alertView addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
            [alertView setDelegate:self];
            self.inputAliasAlert = alertView;
            [alertView show];
            [alertView release];
        }
    }
}





#pragma mark -- callback function
- (void)didRemoveFriend:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        if (self.navigationController.viewControllers.count >= 2 && [(self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2]) isKindOfClass:[MsgComposerVC class]]){
           MsgComposerVC *msgComposerVC = (MsgComposerVC *)(self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2]);
            msgComposerVC.isRemoveBuddyPop = YES;
            [self.navigationController popViewControllerAnimated:NO];
            return;
        }
        [self goBack];
    }
    
}


- (IBAction)makeCall:(id)sender
{
    BOOL callsuccess =  [WowTalkVoipIF fNewOutgoingCall:_buddy.userID withDisplayName:_buddy.nickName withVideo:NO];
    if (!callsuccess) {
        NSLog(@"call failed");
    }
}

- (void)makeVideoCall:(id)sender
{
    [WowTalkVoipIF fNewOutgoingCall:_buddy.userID withDisplayName:_buddy.nickName withVideo:YES];
}
- (IBAction)startChat:(id)sender
{
    switch (self.contact_type) {
        case CONTACT_FRIEND:
        {
            [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC fComposeWowTalkMsgToUser:_buddy withFirstChat:NO];
            [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];
            if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[OMMessageVC class]]){
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
        }
            break;
        case CONTACT_GROUP:
        {
            
        }
            break;
        case CONTACT_STRANGER:
        {
            // add friend;
           
            if (self.buddy.addFriendRule == 2) {
                [WowTalkWebServerIF addBuddy:self.buddy.userID withMsg:nil withCallback:@selector(didAddFriend:) withObserver:self]; // TODO: change here.
            }
            else if(self.buddy.addFriendRule == 1){
                // ios 7 forbids the subview of a alertview . we have to create a customized view for this job.
                    
                    if (IS_IOS7) {
                        // Here we need to pass a full frame
                        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initWithParentView:self.view];
                        
                        // Add some custom content to the alert view
                        [alertView setContainerView:[self createDemoView]];
                        
                        // Modify the parameters
                        [alertView setButtonTitles:[NSMutableArray arrayWithObjects: NSLocalizedString(@"Cancel", Nil), NSLocalizedString(@"Send", nil), nil]];
                        
                        // Use a block instead of a delegate. very tricky way to do.
                        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
                            NSLog(@"Block: Button at position %d is clicked on alertView %zi.", buttonIndex, [alertView tag]);
                            if (buttonIndex == 1) {
                                  [WowTalkWebServerIF addBuddy:self.buddy.userID withMsg:[(TextFieldAlertView*)alertView enteredText] withCallback:@selector(didAddFriend:) withObserver:self]; // TODO: change here.
                            }
                            isIOS7ApplyInfoDialogShown=false;
                            [alertView close];
                        }];
                        
                        [alertView setUseMotionEffects:true];
                        
                        // And launch the dialog
                        [alertView show];
                        
                        IOS7ApplyAlertView=alertView;
                        IOS7ApplyAlertViewFrameOriginal=IOS7ApplyAlertView.frame;
                        isIOS7ApplyInfoDialogShown=true;
                } else {
                
                TextFieldAlertView* alertview = [[TextFieldAlertView alloc] initWithTitle:nil placeholder:NSLocalizedString(@"self introduction", nil) message:NSLocalizedString(@"Add this user as a friend", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) okButtonTitle:NSLocalizedString(@"Send", nil)];
                
                [alertview show];
                [alertview release];
                }
            }
            else{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"You can't add this user as as friend due to his privacy setting", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            
        }
            break;
        default:
            break;
    }
}

- (UIView *)createDemoView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 100)];
    
    UILabel* label_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 290, 20)];
    label_title.text = NSLocalizedString(@"Add this user as a friend", nil);
    label_title.textColor = [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f];
    label_title.font = [UIFont systemFontOfSize:18];
    label_title.backgroundColor = [UIColor clearColor];
    label_title.textAlignment = NSTextAlignmentCenter;
    
    [titleView addSubview:label_title];
    [label_title release];
    
    UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 50.f, 280.0f, 40.0)];
    [theTextField setBackgroundColor:[UIColor clearColor]];
    theTextField.borderStyle = UITextBorderStyleRoundedRect;
    theTextField.textColor = [UIColor blackColor];
    theTextField.font = [UIFont systemFontOfSize:16.0];
    theTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    theTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    theTextField.returnKeyType = UIReturnKeyDone;
    theTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    theTextField.placeholder = NSLocalizedString(@"self introduction", nil);
    theTextField.delegate = self;
//    [theTextField release];
    
    theTextField.tag = 100;
    
    [titleView addSubview:theTextField];
    [theTextField release];
    
    return titleView;
}



- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super viewWillDisappear:animated];
}

#pragma mark keyboard notification
// this is called when the mode is changed to keyboard mode or the inputbox is clicked
-(void) keyboardWillShow:(NSNotification *)note{
    if (isIOS7ApplyInfoDialogShown) {
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[[[note userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
        [UIView setAnimationDuration:[[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        
        IOS7ApplyAlertView.frame=CGRectMake(IOS7ApplyAlertViewFrameOriginal.origin.x, IOS7ApplyAlertViewFrameOriginal.origin.y - 50,
                                            IOS7ApplyAlertViewFrameOriginal.size.width, IOS7ApplyAlertViewFrameOriginal.size.height);
        
        
        // commit animations
        [UIView commitAnimations];
    }
}

// we hide it when the textfield lost focus. Text_Mode and special mode is different.
-(void) keyboardWillHide:(NSNotification *)note{
    if (isIOS7ApplyInfoDialogShown) {
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[[[note userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
        [UIView setAnimationDuration:[[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        
        IOS7ApplyAlertView.frame=IOS7ApplyAlertViewFrameOriginal;
        
        // commit animations
        [UIView commitAnimations];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _inputAliasAlert) {
        NSString *alias = [alertView textFieldAtIndex:0].text;
        if (buttonIndex == 0) {
            if (alias == nil || [alias isEqualToString:@""]) {
                NSMutableDictionary *dic = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:alias, @"alias", nil] autorelease];
                [WowTalkWebServerIF optBuddy:self.buddy.userID withInfo:dic withCallback:@selector(didnoAlias:) withObserver:self];
                return;
            }
            self.inputedAlias = alias;
            NSMutableDictionary *dic = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:alias, @"alias", nil] autorelease];
            [WowTalkWebServerIF optBuddy:self.buddy.userID withInfo:dic withCallback:@selector(didOptBuddy:) withObserver:self];
        }
    } else if (alertView == _deleteFriendAlert) {
        if (buttonIndex == 1) {
            [WowTalkWebServerIF removeBuddy:self.buddy.userID withCallback:@selector(didRemoveFriend:) withObserver:self];
        }
    } else {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [WowTalkWebServerIF addBuddy:self.buddy.userID withMsg:[(TextFieldAlertView*)alertView enteredText] withCallback:@selector(didAddFriend:) withObserver:self]; // TODO: change here.
        }
    }
}

- (void)didnoAlias:(NSNotification *)notification
{
//    
    NSError *error = [[notification userInfo] objectForKey:@"error"];
    if (error.code == NO_ERROR) {
//        self.aliasLabel.text = _inputedAlias;
        UILabel *nameLable = (UILabel *)[self.view viewWithTag:10002];
        nameLable.text = _buddy.showName;
        self.aliasLabel.text = _buddy.showName;
        self.buddy.nickName = _buddy.showName;
        self.buddy.alias = _buddy.showName;
        [Database storeBuddys:[NSArray arrayWithObject:self.buddy]];
    }
}
- (void)didOptBuddy:(NSNotification *)notification
{
    NSError *error = [[notification userInfo] objectForKey:@"error"];
    if (error.code == NO_ERROR) {
        self.aliasLabel.text = _inputedAlias;
        UILabel *nameLable = (UILabel *)[self.view viewWithTag:10002];
        nameLable.text = _inputedAlias;
        self.buddy.alias = _inputedAlias;
        [Database storeBuddys:[NSArray arrayWithObject:self.buddy]];
    }
}

- (void)didAddFriend:(NSNotification *)notification
{
    NSDictionary *infodict = [notification userInfo];
    NSError *err = [infodict objectForKey:@"error"];
    if (err && err.code != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to send request",nil)
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        if (self.buddy.addFriendRule == 2) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Friend has been added",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
            // TODO: we have to reload this page since he becomes a buddy
            
        }
        else if(self.buddy.addFriendRule == 1){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Request is sent",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            [_lbl_addFriend setText:NSLocalizedString(@"Request is sent", nil)];
            [_lbl_addFriend setFrame:CGRectMake(_lbl_addFriend.frame.origin.x, _lbl_addFriend.frame.origin.y, [UILabel labelWidth:_lbl_addFriend.text FontType:15 withInMaxWidth:200]>90?[UILabel labelWidth:_lbl_addFriend.text FontType:15 withInMaxWidth:200]+20:90 , _lbl_addFriend.frame.size.height)];
            [self.btn_message setFrame:_lbl_addFriend.frame];
            [self.btn_message setEnabled:FALSE];
        }
    }
}


- (void)chooseCallOption:(id)sender
{
    self.chooseToCall = YES;
    UIActionSheet* action = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:NSLocalizedString(@"Free call", nil) ,NSLocalizedString(@"Free videochat", nil) , nil];
    [action showInView:self.view];
    [action release];
}


- (void)viewBuddySpace
{
    OMBuddySpaceViewController * bsvc = [[OMBuddySpaceViewController alloc] init];
    bsvc.buddyid = self.buddy.userID;
    [self.navigationController pushViewController:bsvc animated:TRUE];
    [bsvc release];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.contact_type) {
        case CONTACT_FRIEND:
        {
            switch (section) {
                case 0:
                    return 1;
                    break;
                case 1:
                    return 0;
                    break;
                case 2:
                    return 0;
                    break;
                default:
                    break;
            }
        }
            break;
            
        case CONTACT_GROUP:
        {
            switch (section) {
                case 0:
                    return 1;
                    break;
                case 1:
                    return 0;
                    break;
                case 2:
                    return 0;
                    break;
                default:
                    break;
            }
        }
            break;
            
        case CONTACT_STRANGER:
        {
            switch (section) {
                case 0:
                    return 1;
                    break;
                case 1:
                    return 0;
                    break;
                case 2:
                    return 0;
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = nil;
    
    UILabel *detailLabel = nil;

    int height = 0;
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil] autorelease];

                    
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    
                    cell.textLabel.text = NSLocalizedString(@"Status", nil);
                    cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE_17];
                    cell.textLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_TABLE_FONT_COLOR];
                    cell.textLabel.numberOfLines = 0;
                    cell.textLabel.backgroundColor = [UIColor clearColor];
                  
                    
                    height = [UILabel labelHeight:_buddy.status FontType:18 withInMaxWidth:160] + 10 > 44?[UILabel labelHeight:_buddy.status FontType:18 withInMaxWidth:160] + 10 : 44 ;
                    
                    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, PERSON_INFO_Y_0, 180, height)];
                    
                    detailLabel.numberOfLines = 0;
                    detailLabel.backgroundColor = [UIColor clearColor];
                    detailLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_TABLE_FONT_COLOR];
                    detailLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:FONT_SIZE_17];

                    detailLabel.textAlignment = NSTextAlignmentLeft;
                    detailLabel.text =_buddy.status;                  
                    [cell.contentView addSubview:detailLabel];
                    [detailLabel release];
                    break;
                    
                case 1:
                    cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                                   reuseIdentifier:nil] autorelease];
                    cell.textLabel.text = NSLocalizedString(@"Area", nil);
                    cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE_17];
                    cell.textLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_TABLE_FONT_COLOR];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_100,PERSON_INFO_Y_0, PERSON_INFO_WIDTH_160, 44)];
                    detailLabel.adjustsFontSizeToFitWidth = YES;
                    detailLabel.lineBreakMode = YES;
                    detailLabel.backgroundColor = [UIColor clearColor];
                    //TODO: we have to add the location info.
                    detailLabel.text = @"";//@"苏州 ";
                    // detailLabel.textColor = [UIColor colorWithHexString:SETTING_ORANGE_TEXT_COLOR];
                    detailLabel.font = [UIFont systemFontOfSize:FONT_SIZE_17];
                    detailLabel.textAlignment = NSTextAlignmentLeft;
                    
                    
                    [cell addSubview:detailLabel];
                    [detailLabel release];
                    
                    
                    break;
                default:
                    break;
            }
        }  break;
        case 1:
        {
            
            switch (indexPath.row) {
                case 0:
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil] autorelease];
                    cell.textLabel.text = NSLocalizedString(@"携帯", nil);
                    cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE_17];
                    cell.textLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_TABLE_FONT_COLOR];
                    cell.textLabel.numberOfLines = 0;
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_100,PERSON_INFO_Y_0, PERSON_INFO_WIDTH_160, 44)];
                    detailLabel.adjustsFontSizeToFitWidth = YES;
                    detailLabel.lineBreakMode = YES;
                    detailLabel.backgroundColor = [UIColor clearColor];
                    detailLabel.text = _buddy.phoneNumber;
//                    detailLabel.textColor = [UIColor colorWithHexString:SETTING_ORANGE_TEXT_COLOR];
                    detailLabel.font = [UIFont systemFontOfSize:FONT_SIZE_17];
                    detailLabel.textAlignment = NSTextAlignmentLeft;
           
                    [cell addSubview:detailLabel];
                    [detailLabel release];
                    break;
                case 1:
                    cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                                   reuseIdentifier:nil] autorelease];
                    cell.textLabel.text = NSLocalizedString(@"Email", nil);
                    cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE_17];
                    cell.textLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_TABLE_FONT_COLOR];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_100, PERSON_INFO_Y_0, PERSON_INFO_WIDTH_160, 44)];
                    detailLabel.adjustsFontSizeToFitWidth = YES;
                    detailLabel.lineBreakMode = YES;
                    detailLabel.backgroundColor = [UIColor clearColor];
                    detailLabel.text = @"";
//                    detailLabel.textColor = [UIColor colorWithHexString:SETTING_ORANGE_TEXT_COLOR];
                    detailLabel.font = [UIFont systemFontOfSize:FONT_SIZE_17];
                    detailLabel.textAlignment = NSTextAlignmentLeft;
                    [cell addSubview:detailLabel];
                    [detailLabel release];
                    break;
                default:
                    break;
            }
        }
            break;

        default:
            break;
	}

	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [UILabel labelHeight:_buddy.status FontType:18 withInMaxWidth:160] + 10 > 44 ?[UILabel labelHeight:_buddy.status FontType:18 withInMaxWidth:160]+10  :44;
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.contact_type == CONTACT_FRIEND) {
        return 88;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.contact_type == CONTACT_FRIEND) {
        UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 88.0)] autorelease];
        self.btn_action = [[[UIButton alloc] initWithFrame:CGRectMake(10.0, 22.0, 300.0, 44.0)] autorelease];
        [self.btn_action setBackgroundImage:[PublicFunctions strecthableImage:LARGE_BLUE_BUTTON] forState:UIControlStateNormal];
        [self.btn_action addTarget:self action:@selector(viewBuddySpace) forControlEvents:UIControlEventTouchUpInside];
        [self.btn_action setTitle:NSLocalizedString(@"Check moments", nil) forState:UIControlStateNormal];
        [footerView addSubview:self.btn_action];
        return footerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
