//
//  NonUserContactViewController.m
//  omim
//
//  Created by coca on 2013/04/21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "NonUserContactViewController.h"
#import "WTHeader.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "AddressBookManager.h"
#import "TabBarViewController.h"
#import "MessagesVC.h"
#import "AppDelegate.h"

@interface NonUserContactViewController ()
@property (nonatomic,retain) UIImageView* imageview;
@property (nonatomic,retain) UIButton* btn_chat;
@property (nonatomic,retain) NSArray* numbers;
@property (nonatomic,retain) NSArray* emails;

@end

@implementation NonUserContactViewController

@synthesize tb_person = _tb_person;
@synthesize person = _person;
@synthesize imageview = _imageview;
@synthesize btn_chat = _btn_invite;
@synthesize numbers = _numbers;
@synthesize emails = _emails;

#define TAG_SWITCHER    1
#define TAG_LABEL   2


-(void)dealloc{
    [_tb_person release],_tb_person.dataSource = nil,_tb_person.delegate = nil,_tb_person = nil;
    [super dealloc];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IntroCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"IntroCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel* deslabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 220, 24)];
            deslabel.tag = TAG_LABEL;
            deslabel.font = [UIFont systemFontOfSize:FONT_SIZE_17];
            deslabel.numberOfLines = 0;
            deslabel.textColor = [UIColor blackColor];
            deslabel.textAlignment = NSTextAlignmentLeft;
            deslabel.adjustsFontSizeToFitWidth = NO;
            deslabel.lineBreakMode = NO;
            deslabel.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:deslabel];
            [deslabel release];
        }
        cell.detailTextLabel.text = @"";
       
    
        cell.textLabel.text = NSLocalizedString(@"Mobile", nil);
        
        UILabel* label = (UILabel*)[cell.contentView viewWithTag:TAG_LABEL];
        
        label.text = self.buddy.phoneNumber;
        
        return cell;
    }
    else{
          
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SettingCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = NSLocalizedString(@"This user haven't activated. You can send free messsages to him. He will receive your messages in the form of normal SMS. You can call him for free once he activates our service", nil);
        cell.textLabel.numberOfLines = 0;
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_REMARK_FONT_COLOR];
        
        [cell.contentView setFrame:CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, cell.contentView.frame.size.width, [UILabel labelHeight:cell.textLabel.text FontType:17.0 withInMaxWidth:280])];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView* headerview = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 118)] autorelease];
        
        UIImageView* bg = [[UIImageView alloc] initWithFrame:headerview.frame];
        [bg setImage:[UIImage imageNamed:@"contact_info_bg.png"]];
        [headerview addSubview:bg];
        [bg release];
        
        self.imageview = [[[UIImageView alloc]initWithFrame:
                           CGRectMake(PERSON_INFO_X_14, PERSON_INFO_Y_14, PERSON_INFO_MSG_BUTTON_WIDTH, PERSON_INFO_MSG_BUTTON_HEIGHT)] autorelease];
        
        self.imageview.image = [UIImage imageNamed:DEFAULT_AVATAR_OFFLINE_IMAGE_90];
     
    
        [headerview addSubview:self.imageview];
        
        UILabel *nameLabel= [[UILabel alloc] initWithFrame:CGRectMake(PERSON_INFO_X_118, PERSON_INFO_Y_10,PERSON_INFO_WIDTH_160, PERSON_INFO_HEIGHT_20)];
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor colorWithHexString:PERSON_INFO_REMARK_FONT_COLOR];
        nameLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_17];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.shadowColor = [UIColor blackColor];
        nameLabel.shadowOffset = CGSizeMake(1, 1);

        nameLabel.text = self.person.compositeName;
        [headerview addSubview:nameLabel];
        [nameLabel release];
        
        NSString* str = NSLocalizedString(@"Free chat", nil);
        int width = [UILabel labelWidth:str FontType:16 withInMaxWidth:200];
        width = width>80? width:80;
        
        self.btn_chat = [[[UIButton alloc] initWithFrame:CGRectMake(118, 74, width, 37)] autorelease];
        [self.btn_chat setBackgroundImage:[PublicFunctions strecthableImage:MEDIUM_BLUE_BUTTON] forState:UIControlStateNormal];
        [self.btn_chat addTarget:self action:@selector(startChat) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *inviteLabel = [[[UILabel alloc] initWithFrame:self.btn_chat.frame] autorelease];
        inviteLabel.adjustsFontSizeToFitWidth = NO;
        inviteLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        inviteLabel.backgroundColor = [UIColor clearColor];
        inviteLabel.textColor = [UIColor whiteColor];
        inviteLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
        inviteLabel.textAlignment = NSTextAlignmentCenter;
        inviteLabel.text = str;
        inviteLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        inviteLabel.shadowOffset = CGSizeMake(0, 1);
        
        
        
        UILabel *desclabel = [[[UILabel alloc] initWithFrame:CGRectMake(118, 30, 190, 37)] autorelease];
        desclabel.lineBreakMode = NSLineBreakByTruncatingTail;
        desclabel.backgroundColor = [UIColor clearColor];
        desclabel.textColor = [UIColor whiteColor];
        desclabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE_15];
        desclabel.textAlignment = NSTextAlignmentLeft ;
        desclabel.text = NSLocalizedString(@"This user have not activated WowTalk completely", nil);
        desclabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        desclabel.shadowOffset = CGSizeMake(0, 1);
        desclabel.numberOfLines = 0;
        

        [headerview addSubview:self.btn_chat];

        [headerview addSubview:inviteLabel];
        [headerview addSubview:desclabel];

        
        UIImageView* iv_avatarframe = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 104, 104)];
        [iv_avatarframe setImage:[UIImage imageNamed:@"avatar_mask_90.png"]];
        [headerview addSubview:iv_avatarframe];
        [iv_avatarframe release];
        
        UIImageView* iv_divide = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
        [iv_divide setImage:[UIImage imageNamed:@"table_divider_black.png"]];
        [headerview addSubview:iv_divide];
        [iv_divide release];
        
        return headerview;
        
    }
    else return nil;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 129;
    }
    else
        return 10;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    return [UILabel labelHeight: NSLocalizedString(@"This user haven't activated. You can send free messsages to him. He will receive your messages in the form of normal SMS. You can call him for free once he activates our service", nil) FontType:17.0 withInMaxWidth:280];
}

#pragma mark -
#pragma mark -- button function

-(void)startChat
{
    self.buddy.nickName = self.buddy.phoneNumber;

    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC fComposeWowTalkMsgToUser:self.buddy withFirstChat:NO];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];
}

-(void)toggleSwitch
{
    BOOL isShown = FALSE;
    NSArray* numbers = [AddressBookManager phoneNumbersOfPerson:self.person WithLabel:NO];
    
    if ([PublicFunctions hasAnyBuddyAssociateWithNumbers:numbers]) {
        isShown = TRUE;
        
    }
    if (isShown) {
        [WTHelper WTLog:@"try to switch off"];  // TODO: we have to delete this buddy from the local.
    }
    else{
         [WTHelper WTLog:@"try to switch on"];
    }
    
}

-(void)moreOperation
{
    UIActionSheet *avatarSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel" , nil) destructiveButtonTitle:NSLocalizedString(@"Remove friend", nil) otherButtonTitles: nil];
    [avatarSheet showInView:self.view];
    [avatarSheet release];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex != actionSheet.cancelButtonIndex) {
            [WowTalkWebServerIF removeBuddy:self.buddy.userID withCallback:@selector(didRemoveFriend:) withObserver:self];
        }

}

#pragma mark -- callback function

-(void)didRemoveFriend:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self goBack];
    }
    
}



#pragma mark -- navigation bar
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)configNav
{
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = NSLocalizedString(@"Details",nil);
    label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(goBack)];
        [self.navigationItem addLeftBarButtonItem:barButton];
    [barButton release];

    UIBarButtonItem *rightbarButton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_MORE_IMAGE] selector:@selector(moreOperation)];
        [self.navigationItem addRightBarButtonItem:rightbarButton];
    [rightbarButton release];
    
}

#pragma mark -- View Lifecycle
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
    self.view.backgroundColor = [UIColor colorWithHexString:SETTING_BACKGROUND_COLOR];
    [self configNav];
    
    self.person = [AddressBookManager personWithNumber:self.buddy.phoneNumber];
    
    self.tb_person.scrollEnabled = FALSE;
    [self.tb_person setBackgroundView:nil];
    self.tb_person.backgroundColor = [UIColor colorWithHexString:SETTING_BACKGROUND_COLOR];
    [self.tb_person setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:false];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setAutomaticallyAdjustsScrollViewInsets:false];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
