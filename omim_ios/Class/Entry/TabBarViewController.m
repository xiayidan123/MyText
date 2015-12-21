//
//  TabBarViewController.m
//  omim
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "TabBarViewController.h"
#import "Constants.h"

#import "WTHeader.h"

#import "AppDelegate.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

//-----------------------------------------------------------------------
// CustomTabBar
//-----------------------------------------------------------------------

@implementation CustomTabBar

@synthesize controller;
@synthesize unread_bg,unread_count_label, unread_review_bg,unread_review_count_label;
@synthesize unreadSettingBg;
@synthesize unreadSettingLabel;
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_bg.png"]];
        self.backgroundColor = [UIColor whiteColor];
        
       // UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
         UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,1)] autorelease];
        [imageView setImage:[UIImage imageNamed:@"divider_320"]];
        //[imageView setImage:[UIImage imageNamed:@"tabbar_bg.png"]];
        [self addSubview:imageView];
        [self sendSubviewToBack:imageView];
        
        btnMessage = [[UIButton alloc] initWithFrame:CGRectMake(TAB_MESSAGE_OFFSET, 0, TAB_IMAGE_WIDTH, TAB_IMAGE_HEIGHT)];
        [btnMessage setImage:[UIImage imageNamed:@"tabbar_messages"] forState:UIControlStateNormal];
        [self addSubview:btnMessage];
        [btnMessage release];
        [btnMessage addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        
        lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(TAB_MESSAGE_OFFSET, TAB_LABEL_Y_OFFSET, TAB_IMAGE_WIDTH, TAB_TEXT_FONT_SIZE)];
        lblMessage.font = [UIFont systemFontOfSize:TAB_TEXT_FONT_SIZE];
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblMessage];
        [lblMessage release];
        
        self.unread_bg = [[[UIImageView alloc] initWithFrame:CGRectMake(TAB_MESSAGE_OFFSET+TAB_IMAGE_WIDTH-20, 3, 20, 18)] autorelease];
        [self.unread_bg setImage:[UIImage imageNamed:UNREAD_COUNT_BG]];
        [self addSubview:self.unread_bg];
        self.unread_count_label = [[[UILabel alloc] initWithFrame:CGRectMake( self.unread_bg.frame.origin.x, self.unread_bg.frame.origin.y, self.unread_bg.frame.size.width, self.unread_bg.frame.size.height)] autorelease];
        self.unread_count_label.backgroundColor = [UIColor clearColor];
        self.unread_count_label.textAlignment = NSTextAlignmentCenter;
        self.unread_count_label.adjustsFontSizeToFitWidth = TRUE;
        self.unread_count_label.textColor = [UIColor whiteColor];
        [self addSubview:self.unread_count_label];
        if ([AppDelegate sharedAppDelegate].unread_message_count != 0) {
            self.unread_count_label.hidden = FALSE;
            self.unread_bg.hidden = FALSE;
            self.unread_count_label.text = [NSString stringWithFormat:@"%d", [AppDelegate sharedAppDelegate].unread_message_count];
            self.unread_count_label.textColor = [UIColor whiteColor];
        }
        else{
            self.unread_count_label.hidden = TRUE;
            self.unread_bg.hidden = true;
        }
        
        
        
        btnContact = [[UIButton alloc] initWithFrame:CGRectMake(TAB_CONTACTS_OFFSET, 0, TAB_IMAGE_WIDTH, TAB_IMAGE_HEIGHT)];
        [btnContact setImage:[UIImage imageNamed:@"tabbar_contacts.png"] forState:UIControlStateNormal];
        [self addSubview:btnContact];
        [btnContact release];
        [btnContact addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        
        lblContact = [[UILabel alloc] initWithFrame:CGRectMake(TAB_CONTACTS_OFFSET, TAB_LABEL_Y_OFFSET, TAB_IMAGE_WIDTH, TAB_TEXT_FONT_SIZE)];
        lblContact.font = [UIFont systemFontOfSize:TAB_TEXT_FONT_SIZE];
        lblContact.backgroundColor = [UIColor clearColor];
        lblContact.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblContact];
        [lblContact release];
        
        
        self.unread_request_bg = [[[UIImageView alloc] initWithFrame:CGRectMake(TAB_CONTACTS_OFFSET+TAB_IMAGE_WIDTH-20, 3, 20, 18)] autorelease];
        [self.unread_request_bg setImage:[UIImage imageNamed:UNREAD_COUNT_BG]];
        [self addSubview:self.unread_request_bg];
        
        self.unread_request_count_label = [[[UILabel alloc] initWithFrame:CGRectMake(self.unread_request_bg.frame.origin.x, self.unread_request_bg.frame.origin.y, self.unread_request_bg.frame.size.width, self.unread_request_bg.frame.size.height)] autorelease];
        self.unread_request_count_label.backgroundColor = [UIColor clearColor];
        self.unread_request_count_label.textAlignment = NSTextAlignmentCenter;
        self.unread_request_count_label.adjustsFontSizeToFitWidth = TRUE;
        self.unread_request_count_label.textColor = [UIColor whiteColor];
        [self addSubview:self.unread_request_count_label];
        
        if ( [[NSUserDefaults standardUserDefaults] integerForKey:NEW_REQUEST_NUM]> 0) {
            self.unread_request_count_label.hidden = FALSE;
            self.unread_request_bg.hidden = FALSE;
            self.unread_request_count_label.text = [NSString stringWithFormat:@"%ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:NEW_REQUEST_NUM]];
            self.unread_request_count_label.textColor = [UIColor whiteColor];
        }
        else{
            self.unread_request_count_label.hidden = TRUE;
            self.unread_request_bg.hidden = true;
        }
        
        
        btnHome = [[UIButton alloc] initWithFrame:CGRectMake(TAB_HOME_OFFSET, 0, TAB_IMAGE_WIDTH, 49)];
        [btnHome setImage:[UIImage imageNamed:@"tabbar_home_green"] forState:UIControlStateNormal];
        [btnHome addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnHome];
        [btnHome release];
        
     
        
        
        btnTimeline = [[UIButton alloc] initWithFrame:CGRectMake(TAB_SOCIAL_OFFSET, 0, TAB_IMAGE_WIDTH, TAB_IMAGE_HEIGHT)];
        [btnTimeline setImage:[UIImage imageNamed:@"tabbar_share.png"] forState:UIControlStateNormal];
        [self addSubview:btnTimeline];
        [btnTimeline release];
        [btnTimeline addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        
        lblTimeline = [[UILabel alloc] initWithFrame:CGRectMake(TAB_SOCIAL_OFFSET - 3, TAB_LABEL_Y_OFFSET, TAB_IMAGE_WIDTH + 6, TAB_TEXT_FONT_SIZE)];
        lblTimeline.font = [UIFont systemFontOfSize:TAB_TEXT_FONT_SIZE];
        lblTimeline.backgroundColor = [UIColor clearColor];
        lblTimeline.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblTimeline];
        [lblTimeline release];
        
        self.unread_moment_notice = [[[UIImageView alloc] initWithFrame:CGRectMake(TAB_SOCIAL_OFFSET+TAB_IMAGE_WIDTH-20, 6, 10, 10)] autorelease];
        [self.unread_moment_notice setImage:[UIImage imageNamed:@"indicator.png"]];
        self.unread_moment_notice.hidden = YES;
        [self addSubview:self.unread_moment_notice];
        
        self.unread_review_bg = [[[UIImageView alloc] initWithFrame:CGRectMake(200, 6, 20, 18)] autorelease];
        [self.unread_review_bg setImage:[UIImage imageNamed:UNREAD_COUNT_BG]] ;
        self.unread_review_bg.hidden = true;
        [self addSubview:self.unread_review_bg];
        
        self.unread_review_count_label = [[[UILabel alloc] initWithFrame:CGRectMake( self.unread_review_bg.frame.origin.x, self.unread_review_bg.frame.origin.y, self.unread_review_bg.frame.size.width, self.unread_review_bg.frame.size.height)] autorelease];
        self.unread_review_count_label.backgroundColor = [UIColor clearColor];
        self.unread_review_count_label.textAlignment = NSTextAlignmentCenter;
        self.unread_review_count_label.adjustsFontSizeToFitWidth = TRUE;
        self.unread_review_count_label.textColor = [UIColor whiteColor];
        self.unread_review_count_label.hidden = TRUE;

        [self addSubview:self.unread_review_count_label];
        if ([[Database getUnreadReviews] count] > 0) {
            self.unread_review_count_label.hidden = FALSE;
            self.unread_review_bg.hidden = FALSE;
            self.unread_review_count_label.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[Database getUnreadReviews] count]];
            self.unread_review_count_label.textColor = [UIColor whiteColor];
        } else {
            self.unread_review_count_label.hidden = TRUE;
            self.unread_review_bg.hidden = true;
        }
        
        btnSetting = [[UIButton alloc] initWithFrame:CGRectMake(TAB_SETTING_OFFSET, 0, TAB_IMAGE_WIDTH, TAB_IMAGE_HEIGHT)];
        [btnSetting setImage:[UIImage imageNamed:@"tabbar_more.png"] forState:UIControlStateNormal];
        [self addSubview:btnSetting];
        [btnSetting addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [btnSetting release];
        
        lblSetting = [[UILabel alloc] initWithFrame:CGRectMake(TAB_SETTING_OFFSET, TAB_LABEL_Y_OFFSET, TAB_IMAGE_WIDTH, TAB_TEXT_FONT_SIZE)];
        lblSetting.font = [UIFont systemFontOfSize:TAB_TEXT_FONT_SIZE];
        lblSetting.backgroundColor = [UIColor clearColor];
        lblSetting.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblSetting];
        [lblSetting release];
        
        
        self.unreadSettingBg = [[[UIImageView alloc] initWithFrame:CGRectMake(286.0f, 8.0f, 8.0f, 8.0f)] autorelease];
        unreadSettingBg.image = [UIImage imageNamed:UNREAD_COUNT_BG];
        unreadSettingBg.layer.masksToBounds = YES;
        unreadSettingBg.layer.cornerRadius = 4.0f;
        [self addSubview:unreadSettingBg];
        self.unreadSettingLabel = [[[UILabel alloc] initWithFrame:unreadSettingBg.frame] autorelease];
        unreadSettingLabel.backgroundColor = [UIColor clearColor];
        unreadSettingLabel.textAlignment = NSTextAlignmentCenter;
        unreadSettingLabel.adjustsFontSizeToFitWidth = YES;
        unreadSettingLabel.textColor = [UIColor whiteColor];
        [self addSubview:unreadSettingLabel];
        BOOL newVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:@"new_version"] boolValue];
        if (!newVersion) {
            unreadSettingBg.hidden = YES;
            unreadSettingLabel.hidden = YES;
        } else {
            unreadSettingBg.hidden = NO;
            unreadSettingLabel.hidden = NO;
        }

        
        
        
        
        
        
        
        
        lblMessage.text = NSLocalizedString(@"messages", nil);
        lblContact.text = NSLocalizedString(@"contacts", nil);
        lblTimeline.text = NSLocalizedString(@"Moments", nil);
        lblSetting.text = NSLocalizedString(@"settings", nil);
        
        UIColor *normalColor = [UIColor lightGrayColor];
        lblMessage.textColor = normalColor;
        lblContact.textColor = normalColor;
        lblTimeline.textColor = normalColor;
        lblSetting.textColor = normalColor;
        
        btnMessage.tag = TAB_MESSAGE;
        btnContact.tag = TAB_CONTACT;
        btnTimeline.tag = TAB_TIMELINE;
        btnHome.tag = TAB_HOME;
        btnSetting.tag = TAB_SETTING;
    }
    
    return self;
}


- (void)selectTabAtIndex:(int)newSelectedTabIndex
{
    if (newSelectedTabIndex == selectedTab)
        return;
    
    UIColor *normalColor = [UIColor lightGrayColor];
    switch (selectedTab)
    {
        case TAB_MESSAGE:
            [btnMessage setImage:[UIImage imageNamed:@"tabbar_messages.png"] forState:UIControlStateNormal];
            lblMessage.textColor = normalColor;
            break;
            
        case TAB_CONTACT:
            [btnContact setImage:[UIImage imageNamed:@"tabbar_contacts.png"] forState:UIControlStateNormal];
            lblContact.textColor = normalColor;
            break;
            
        case TAB_TIMELINE:
            [btnTimeline setImage:[UIImage imageNamed:@"tabbar_share.png"] forState:UIControlStateNormal];
            lblTimeline.textColor = normalColor;
            break;
            
            
        case TAB_SETTING:
            [btnSetting setImage:[UIImage imageNamed:@"tabbar_more.png"] forState:UIControlStateNormal];
            lblSetting.textColor = normalColor;
            break;
            
        default:
            break;
    }
    
    selectedTab = newSelectedTabIndex;
    switch (selectedTab)
    {
        case TAB_MESSAGE:
            [btnMessage setImage:[UIImage imageNamed:@"tabbar_messages_pre.png"] forState:UIControlStateNormal];
            lblMessage.textColor = [UIColor colorWithHexString:@"#E71326"];
            [btnHome setImage:[UIImage imageNamed:@"tabbar_home_red.png"] forState:UIControlStateNormal];
            self.seleted_color =[UIColor colorWithHexString:@"#E71326"];
            [[AppDelegate sharedAppDelegate] setStatusColor:[UIColor colorWithHexString:@"#E71326"]];

            break;
            
        case TAB_CONTACT:
            [btnContact setImage:[UIImage imageNamed:@"tabbar_contacts_pre.png"] forState:UIControlStateNormal];
            lblContact.textColor = [UIColor colorWithHexString:@"#1BADFA"];
            [btnHome setImage:[UIImage imageNamed:@"tabbar_home_blue.png"] forState:UIControlStateNormal];
            self.seleted_color = [UIColor colorWithHexString:@"#1BADFA"];
            [[AppDelegate sharedAppDelegate] setStatusColor:[UIColor colorWithHexString:@"#1BADFA"]];

            break;
            
        case TAB_HOME:
            [btnHome setImage:[UIImage imageNamed:@"tabbar_home_green.png"] forState:UIControlStateNormal];
            self.seleted_color = [UIColor colorWithHexString:@"#00C630"];
            [[AppDelegate sharedAppDelegate] setStatusColor:[UIColor colorWithHexString:@"#00C630"]];

            break;
            
        case TAB_TIMELINE:
            [btnTimeline setImage:[UIImage imageNamed:@"tabbar_share_pre.png"] forState:UIControlStateNormal];
            lblTimeline.textColor = [UIColor colorWithHexString:@"#1BADFA"];
            [btnHome setImage:[UIImage imageNamed:@"tabbar_home_blue.png"] forState:UIControlStateNormal];
           /* self.seleted_color = [UIColor colorWithRed:251.0/255 green:250.0/255 blue:251.0/255 alpha:1];
            [[AppDelegate sharedAppDelegate] setStatusColor:[UIColor colorWithRed:251.0/255 green:250.0/255 blue:251.0/255 alpha:1]];*/
            self.seleted_color = [UIColor colorWithHexString:@"#1BADFA"];
            [[AppDelegate sharedAppDelegate] setStatusColor:[UIColor colorWithHexString:@"#1BADFA"]];

            
            break;
            
        case TAB_SETTING:
            [btnSetting setImage:[UIImage imageNamed:@"tabbar_more_pre.png"] forState:UIControlStateNormal];
            lblSetting.textColor = [UIColor colorWithHexString:@"#00C630"];
            [btnHome setImage:[UIImage imageNamed:@"tabbar_home_green.png"] forState:UIControlStateNormal];
            self.seleted_color = [UIColor colorWithHexString:@"#00C630"];
            [[AppDelegate sharedAppDelegate] setStatusColor:[UIColor colorWithHexString:@"#00C630"]];

            
            break;
            
        default:
            break;
    }
}


- (void)selectTab:(UIButton *)newSelectedTab
{
    controller.selectedIndex = newSelectedTab.tag;
    [self selectTabAtIndex:newSelectedTab.tag];
}

@end

//-----------------------------------------------------------------------
// ViewController
//-----------------------------------------------------------------------

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tabBar.hidden = YES;
    
    customTabBar = [[CustomTabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - TAB_BAR_HEIGHT, self.view.frame.size.width, TAB_BAR_HEIGHT)];
    
    customTabBar.controller = self;
    [self.view addSubview:customTabBar];
    [customTabBar release];
    
    
    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
    callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            customTabBar.center = CGPointMake(customTabBar.center.x, customTabBar.center.y + 20);
        }
        else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            customTabBar.center = CGPointMake(customTabBar.center.x, self.view.bounds.size.height - customTabBar.bounds.size.height/2);
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
            customTabBar.center = CGPointMake(customTabBar.center.x, customTabBar.center.y - 20);
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {

        }
        else
        {
            
        }
    };
}


-(void)selectTabAtIndex:(int)index
{
     self.selectedIndex = index;
     [customTabBar selectTabAtIndex:index];
}


-(void)refreshCustomBarUnreadNum
{
    int num = [AppDelegate sharedAppDelegate].unread_message_count;
    if (num != 0) {
        customTabBar.unread_bg.hidden = FALSE;
        customTabBar.unread_count_label.hidden = FALSE;
        customTabBar.unread_count_label.text = [NSString stringWithFormat:@"%d",num];
    }else{
        customTabBar.unread_bg.hidden = YES;
        customTabBar.unread_count_label.hidden = YES;
    }
    
    if ([[Database getUnreadReviews] count] > 0) {
        customTabBar.unread_review_count_label.hidden = FALSE;
        customTabBar.unread_review_bg.hidden = FALSE;
        customTabBar.unread_review_count_label.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[Database getUnreadReviews] count]];
        customTabBar.unread_review_count_label.textColor = [UIColor whiteColor];
    }
    else{
        customTabBar.unread_review_count_label.hidden = TRUE;
        customTabBar.unread_review_bg.hidden = true;
    }
    if ( [[NSUserDefaults standardUserDefaults] integerForKey:NEW_REQUEST_NUM] > 0) {
        customTabBar.unread_request_count_label.hidden = FALSE;
        customTabBar.unread_request_bg.hidden = FALSE;
        customTabBar.unread_request_count_label.text = [NSString stringWithFormat:@"%ld",  (long)[[NSUserDefaults standardUserDefaults] integerForKey:NEW_REQUEST_NUM]];
        customTabBar.unread_request_count_label.textColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"new_request" object:nil];
    }
    else{
        customTabBar.unread_request_count_label.hidden = YES;
        customTabBar.unread_request_bg.hidden = YES;
    }
    
    if ([AppDelegate sharedAppDelegate].unread_moment_notice_count > 0) {
        customTabBar.unread_moment_notice.hidden = FALSE;
    } else {
        customTabBar.unread_moment_notice.hidden = YES;
    }
    
    
    BOOL newVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:@"new_version"] boolValue];
    customTabBar.unreadSettingBg.hidden = (!newVersion);
    customTabBar.unreadSettingLabel.hidden = (!newVersion);
}

- (void)hideTabbar
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    
    CGRect frame = customTabBar.frame;
    frame.origin.y = 700;
    customTabBar.frame = frame;
    
    [UIView commitAnimations];
}

- (void)showTabbar
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    
    CGRect frame = customTabBar.frame;
    frame.origin.y = self.view.frame.size.height - TAB_BAR_HEIGHT;
    customTabBar.frame = frame;
    
    [UIView commitAnimations];
}

-(UIColor*)getSelectedTabColor{
    if (customTabBar.seleted_color) {
        return customTabBar.seleted_color;
    }
    
    return [UIColor whiteColor];
}

@end
