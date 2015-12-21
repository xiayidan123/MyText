//
//  ApplyViewController.m
//  omim
//
//  Created by coca on 2013/05/01.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ApplyViewController.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "WTHeader.h"
#import "ContactInfoViewController.h"
#import "RequestListViewController.h"

@interface ApplyViewController ()

@end

@implementation ApplyViewController{
    BOOL _popFast;
}


#pragma mark -
#pragma mark - table view delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }

   
    
    cell.textLabel.text = NSLocalizedString(@"Additional information", nil);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text =@"";
    int width = [UILabel labelWidth: NSLocalizedString(@"Additional information", nil) FontType:14 withInMaxWidth:300];
    
    int height = (10 + [UILabel labelHeight:self.helloword FontType:16 withInMaxWidth:270-width]) > 44? (10 + [UILabel labelHeight:self.helloword FontType:16 withInMaxWidth:270-width]) :44;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(width + 20,0, 270-width, height)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = self.helloword;
    label.numberOfLines = 0;
    
    [cell.contentView addSubview:label];
    [label release];
    
    [cell.contentView setFrame:CGRectMake(0, 0, 320, height )];
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int width = [UILabel labelWidth: NSLocalizedString(@"Additional information", nil) FontType:14 withInMaxWidth:300];
    
    int height = (10 + [UILabel labelHeight:self.helloword FontType:16 withInMaxWidth:270-width]) > 44? (10 + [UILabel labelHeight:self.helloword FontType:16 withInMaxWidth:270-width]) :44 ;
    
    return  height;
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)] autorelease];
    Buddy* buddy = [Database buddyWithUserID:self.buddyid];
    if (self.isGroupInvitation) {
        
        NSData* data =  [AvatarHelper getThumbnailForGroup:self.groupid];
        if (data) {
            imageView.image = [UIImage imageWithData:data];
        }
        else
            imageView.image = [UIImage imageNamed:DEFAULT_GROUP_AVATAR];
        
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5.0f;
        
        UILabel *nameLabel = [[[UILabel alloc] init] autorelease];
        nameLabel.frame = CGRectMake(60, 10, 240, 30);
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont fontWithName:TABLE_HEADER_LABEL_FONT_NAME size:TABLE_HEADER_LABEL_FONT_SIZE];
        nameLabel.text = self.name;
        
        [view addSubview:imageView];
        [view addSubview:nameLabel];
    }
    
    else if(self.isApplyForAddFriend || self.isApplyForGroup){
        NSData* data =  [AvatarHelper getThumbnailForUser:self.buddyid];
        if (data) {
            imageView.image =  [UIImage imageWithData:data];
        }
        else{
            imageView.image = [UIImage imageNamed:DEFAULT_AVATAR];
        }
        
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5.0f;
        
        UILabel *nameLabel = [[[UILabel alloc] init] autorelease];
        nameLabel.frame = CGRectMake(60, 10, 240, 30);
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont fontWithName:TABLE_HEADER_LABEL_FONT_NAME size:TABLE_HEADER_LABEL_FONT_SIZE];
        nameLabel.text = self.name;
        
        UILabel *IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 240, 30)];
        IDLabel.backgroundColor = [UIColor clearColor];
        IDLabel.textColor = [UIColor blackColor];
        IDLabel.font = [UIFont fontWithName:TABLE_HEADER_LABEL_FONT_NAME size:TABLE_HEADER_LABEL_FONT_SIZE];
        IDLabel.text = [NSString stringWithFormat:@"帐号:%@",buddy.wowtalkID];
        
        
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:imageView.frame];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(viewTheDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:IDLabel];
        [view addSubview:imageView];
        [view addSubview:nameLabel];
        [view addSubview:btn];
        
    }
    
    return [view autorelease];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 140;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
    
    UIButton* btn_confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_confirm setFrame:CGRectMake(10, 20, 300, 50)];
    [btn_confirm setBackgroundImage:[PublicFunctions strecthableImage:LARGE_BLUE_BUTTON] forState:UIControlStateNormal];
    [btn_confirm addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn_refuse =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn_refuse setFrame:CGRectMake(10, 85, 300, 50)];
    [btn_refuse setBackgroundImage:[PublicFunctions strecthableImage:LARGE_BLUE_BUTTON] forState:UIControlStateNormal];
    [btn_refuse addTarget:self action:@selector(refuse:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn_confirm];
    [view addSubview:btn_refuse];
    
    
    UILabel *acceptLabel = [[UILabel alloc] initWithFrame:btn_confirm.frame];
    acceptLabel.adjustsFontSizeToFitWidth = NO;
    acceptLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    acceptLabel.backgroundColor = [UIColor clearColor];
    acceptLabel.textColor = [UIColor whiteColor];
    acceptLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE_15];
    acceptLabel.textAlignment = NSTextAlignmentCenter;
    acceptLabel.text = NSLocalizedString(@"Accecpt", nil);
    acceptLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
    acceptLabel.shadowOffset = CGSizeMake(0, 1);

    
    UILabel *refuseLabel = [[UILabel alloc] initWithFrame:btn_refuse.frame];
    refuseLabel.adjustsFontSizeToFitWidth = NO;
    refuseLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    refuseLabel.backgroundColor = [UIColor clearColor];
    refuseLabel.textColor = [UIColor whiteColor];
    refuseLabel.font =  [UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE_15];
    refuseLabel.textAlignment = NSTextAlignmentCenter;
    refuseLabel.text = NSLocalizedString(@"Reject",nil);
    
    refuseLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
    refuseLabel.shadowOffset = CGSizeMake(0, 1);
    [view addSubview:acceptLabel];
    [view addSubview:refuseLabel];
    
    [acceptLabel release];
    [refuseLabel release];
    
    return [view autorelease];
}

#pragma mark - button action

-(void)viewTheDetail:(id)sender
{
    Buddy* buddy = [Database buddyWithUserID:self.buddyid];
    
    ContactInfoViewController *contactInfoViewController = [[ContactInfoViewController alloc] initWithNibName:@"ContactInfoViewController" bundle:nil];
    contactInfoViewController.buddy = buddy;
    if (buddy.isFriend) {
        contactInfoViewController.contact_type = CONTACT_FRIEND;
    }
    else
        contactInfoViewController.contact_type = CONTACT_STRANGER;
    
    [self.navigationController pushViewController:contactInfoViewController animated:YES];
    [contactInfoViewController release];
    
}

-(void)refuse:(id)sender
{
    if (self.isApplyForAddFriend) {
        [WowTalkWebServerIF rejectFriendRequest:self.buddyid withCallback:@selector(finishAction:) withObserver:self];
    }
    else if (self.isApplyForGroup){
        [WowTalkWebServerIF rejectCandidate:self.buddyid toJoinGroup:self.groupid withCallback:@selector(finishAction:) withObserver:self];
    }
    else if (self.isGroupInvitation){
        [WTHelper WTLog:@"not implemeted"];
    }
    
}

-(void)accept:(id)sender
{
    if (self.isApplyForAddFriend) {
        [WowTalkWebServerIF addBuddy:self.buddyid withMsg:nil withCallback:@selector(finishAction:) withObserver:self];
#warning by yangbin temporary
        ((RequestListViewController *) _delegate).isAccecpt = YES;
        ((RequestListViewController *) _delegate).buddy_id = self.buddyid;
        _popFast = YES;
    }
    else if (self.isApplyForGroup){
        [WowTalkWebServerIF acceptJoinApplicationFor:self.groupid FromUser:self.buddyid  withCallback:@selector(finishAction:) withObserver:self];
    }
    else if (self.isGroupInvitation){
        [WTHelper WTLog:@"not implemeted"];
    }
}

#pragma mark -- call back

-(void)finishAction:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
           [self goBack];
    }
}

#pragma mark -- navigation bar
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:_popFast ? NO : YES];
}

-(void)configNav
{
    NSString* title = nil;
    if (self.isApplyForAddFriend) {
        title = NSLocalizedString(@"Friend request", nil) ;
    }
    
    if (self.isApplyForGroup) {
        title= NSLocalizedString(@"Join Application", nil) ;
    }
    if (self.isGroupInvitation) {
        title = NSLocalizedString(@"Invitation", nil);
    }
    
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text =  title ;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    
    UIBarButtonItem *barButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
        [self.navigationItem addLeftBarButtonItem:barButton];
    [barButton release];
    
}


#pragma mark view
-(void)generateDummyData
{
    
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
    // Do any additional setup after loading the view from its nib.
    [self configNav];
    
    [self.tb_apply setScrollEnabled:false];
    [self.tb_apply setBackgroundView:nil];
    self.tb_apply.backgroundColor = [UIColor colorWithHexString:SETTING_BACKGROUND_COLOR];
    [self.tb_apply setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tb_apply reloadData];
    
    if (self.isApplyForGroup || self.isApplyForAddFriend) {
        [WowTalkWebServerIF getBuddyWithUID:self.buddyid withCallback:nil withObserver:nil];
    }
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    //TODO: if it is invitation , then we have to get a group info here.
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
