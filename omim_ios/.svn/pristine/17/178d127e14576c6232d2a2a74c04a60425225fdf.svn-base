//
//  GroupPickerViewController.m
//  omim
//
//  Created by elvis on 2013/05/11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "GroupPickerViewController.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "WTHeader.h"
#import "ContactPreviewCell.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "MessagesVC.h"

@interface GroupPickerViewController ()

@property (nonatomic,retain) NSArray* arr_groups;

@end

@implementation GroupPickerViewController


#pragma mark -
#pragma mark - navigation config
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configNav
{
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = NSLocalizedString(@"select a group or chatroom",nil);
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
    
    self.arr_groups = [Database getAllGroupChatRooms];
    self.tb_groups.backgroundColor = [UIColor colorWithHexString:SETTING_BACKGROUND_COLOR];
    self.tb_groups.backgroundView = nil;
    [self.tb_groups setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tb_groups setFrame:CGRectMake(0, 0, self.tb_groups.frame.size.width, [UISize screenHeight] - 20 - 44)];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseTableCell"];
    
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactPreviewCell" owner:self options:nil] lastObject];
    }
    
    GroupChatRoom* room = [self.arr_groups objectAtIndex:indexPath.row];
    if (room.isTemporaryGroup) {
        cell.temproom = room;
        [cell loadViewForTempGroup];
    }
    
    else{
        UserGroup* group = [Database getFixedGroupByID:room.groupID];
        cell.group = group;
        [cell loadViewForGroup];
    }
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupChatRoom* room = [self.arr_groups objectAtIndex:indexPath.row];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    if (room.isTemporaryGroup) {
        room.memberList = [Database fetchAllBuddysInGroupChatRoom:room.groupID];
    }
    
    else{
        room.memberList = [Database getAllMembersInFixedGroup:room.groupID];
    }
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC createGroupChatRoom:room.memberList withGroupID:room.groupID];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];
//    [[AppDelegate sharedAppDelegate].tabbarVC selectTabAtIndex:TAB_MESSAGE];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arr_groups count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CONTACT_CELL_HEIGHT;
    
}



@end
