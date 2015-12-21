//
//  SystemMessageViewController.m
//  omim
//
//  Created by elvis on 2013/05/23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "WTHeader.h"
#import "Constants.h"
#import "PublicFunctions.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "TabBarViewController.h"

@interface SystemMessageViewController ()

@property (nonatomic,retain) NSCalendar *gregorian;
@property (nonatomic,retain) NSDate* today;
@property (nonatomic,retain) NSDate* sevenDaysAgo;

@property (nonatomic,retain) NSMutableArray* arr_msg;

@end

@implementation SystemMessageViewController

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

    self.gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *todayComponents = [self getDateComponentsFromDate:[NSDate date]];
	[todayComponents setHour:0];
	[todayComponents setMinute:0];
	[todayComponents setSecond:0];
	self.today = [self.gregorian dateFromComponents:todayComponents];
    
    NSDateComponents *minusComponents = [[[NSDateComponents alloc] init] autorelease];
	[minusComponents setDay:-7 ];
	self.sevenDaysAgo = [self.gregorian dateByAddingComponents:minusComponents toDate:self.today options:0];
    
    [self.tb_content setBackgroundView:nil];
    [self.tb_content setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tb_content setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    
    [self fetchSystemMessages];
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tb_content setFrame:CGRectMake(0, 0, self.tb_content.frame.size.width, [UISize screenHeight] - 20 - 44)];
    }

}

-(void)fetchSystemMessages
{

    NSMutableArray* array = [Database fetchChatMessagesWithUser:@"10000"];
    NSSortDescriptor* sorter = [[[NSSortDescriptor alloc] initWithKey:@"primaryKey" ascending:FALSE] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sorter];
    self.arr_msg =  [NSMutableArray arrayWithArray:[array sortedArrayUsingDescriptors:sortDescriptors]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fProcessNewIncomeMsg:(ChatMessage*)msg
{
    [Database setChatMessageReaded:msg];
    
    [self fetchSystemMessages];
    
    [self.tb_content reloadData];
    [self.tb_content scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewRowAnimationTop animated:TRUE];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    NSArray* unreadMsgList = [Database fetchUnreadChatMessagesWithUser:@"10000"];
    
    NSInteger unReadMsgCount = [unreadMsgList count];
    
    if (unReadMsgCount>0)
    {
        
        [AppDelegate sharedAppDelegate].unread_message_count -= unReadMsgCount;
        if([AppDelegate sharedAppDelegate].unread_message_count <0)
        {
            [AppDelegate sharedAppDelegate].unread_message_count = 0;
        }
        
        int badgeValue = [AppDelegate sharedAppDelegate].unread_message_count;
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:badgeValue forKey:UNREAD_MESSAGE_NUMBER];
        [defaults synchronize];
        
        [[[AppDelegate sharedAppDelegate] tabbarVC] refreshCustomBarUnreadNum];
        
        [Database setChatMessageAllReaded:@"10000"];
        
    }
}



- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configNav
{
    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = NSLocalizedString(@"System messages",nil);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;

    UIBarButtonItem *barButtonRight = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:@"nav_delete.png"] selector:@selector(deleteAllSystemMsg:)];
       [self.navigationItem addRightBarButtonItem:barButtonRight];
    [barButtonRight release];
    
}


-(void)deleteAllSystemMsg:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Are you sure to delete all system messages", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil)  otherButtonTitles:NSLocalizedString(@"OK", nil) , nil];
    [alert show];
    [alert release];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        
        [Database deleteChatMessageWithUser:@"10000"];
        self.arr_msg  = [Database fetchChatMessagesWithUser:@"10000"];
        [self.tb_content reloadData];
        
    }
}


- (NSDateComponents *)getDateComponentsFromDate:(NSDate *)date {
	return [self.gregorian components:(NSHourCalendarUnit |
                                       NSMinuteCalendarUnit |
                                       NSSecondCalendarUnit |
                                       NSDayCalendarUnit |
                                       NSWeekdayCalendarUnit |
                                       NSMonthCalendarUnit |
                                       NSYearCalendarUnit) fromDate:date];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"systemcell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* avatar = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 50, 50)];
        [avatar setImage:[UIImage imageNamed:@"chat_notification_icon.png"]];
        avatar.layer.masksToBounds = YES;
        avatar.layer.cornerRadius = 5.0f;
        [cell.contentView addSubview:avatar];
        [avatar release];
        
        UILabel* time = [[UILabel alloc] initWithFrame:CGRectMake(280, 20, 63, 15)];
        time.tag = 1;
        time.font = [UIFont systemFontOfSize:13];
        time.textColor= [Colors latestChatTimeColor];
        time.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:time];
        
        [time release];
        
        UILabel* content = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 215, 48)];
        content.numberOfLines = 0;
        content.backgroundColor = [UIColor clearColor];
        content.font = [UIFont systemFontOfSize:15];
        content.tag = 2;
        content.textColor = [Colors latestMessageColor];
        content.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:content];
        [content release];
        
        UIImageView* divider = [[UIImageView alloc] initWithFrame:CGRectMake(0, 57, 320, 2)];
        [divider setImage:[UIImage imageNamed:@"table_divider_white.png"]];
        [cell.contentView addSubview:divider];
        [divider release];
        
	}
    
    UILabel* time = (UILabel*)[cell.contentView viewWithTag:1];
    UILabel* content = (UILabel*)[cell.contentView viewWithTag:2];
    
    
    ChatMessage* msg = [self.arr_msg objectAtIndex:indexPath.row];
    content.text = msg.messageContent;

    
   
    
    ////////////////////////////////
	NSDate* sentDate= [Database chatMessage_UTCStringToDate:msg.sentDate];
	
	NSDateComponents* components = [self getDateComponentsFromDate:sentDate];
    
	//if the sentDate is not earlier then today
	if ([sentDate compare:self.today] != NSOrderedAscending ) {
		time.text = [NSString stringWithFormat: @"%02ld:%02ld", (long)[components hour],(long)[components minute]];
	}
	else {
		if ([sentDate compare:self.sevenDaysAgo] != NSOrderedAscending) {
			NSString* strWeekday = [NSString stringWithFormat:@"Weekday%ld",(long)[components weekday]];
			time.text = NSLocalizedString(strWeekday,nil);
		}
		else {
			time.text = [NSString stringWithFormat: @"%ld/%ld/%ld", (long)[components year],(long)[components month],(long)[components day]];
            
		}
        
	}
     
     return cell;
  //  return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arr_msg count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
