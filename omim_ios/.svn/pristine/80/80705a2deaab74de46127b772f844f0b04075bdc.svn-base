//
//  ParentChatRoomVC.m
//  dev01
//
//  Created by Huan on 15/3/19.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ParentChatRoomVC.h"
#import "leftBarBtn.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "AddCourseController.h"
#import "Database.h"
#import "ContactInfoViewController.h"
#import "WTUserDefaults.h"
#import "AddBuddyFromSchoolVC.h"
@interface ParentChatRoomVC ()<SchoolViewControllerDelegate,AddCourseControllerDelegate,ParentChatViewControllerDelegate>

@end

@implementation ParentChatRoomVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    self.schoolVC = [[[ParentChatViewController alloc] init] autorelease];
    self.schoolVC.sub_delegate = self;
    self.schoolVC.delegate = self;
    [self.view addSubview:self.schoolVC.view];
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)configNav
{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"家长聊天室", nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    leftBarBtn *leftBarBtn = [[[NSBundle mainBundle] loadNibNamed:@"leftBarBtn" owner:nil options:nil] firstObject];
    [leftBarBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    [leftBarBtn release];
    
    UIBarButtonItem* barButton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_ADD_IMAGE] selector:@selector(addContact)];
    [self.navigationItem addRightBarButtonItem:barButton];
}
- (void)addContact
{
    AddCourseController *addcourse = [[AddCourseController alloc]init];
    addcourse.isInvitationCodeInHomeVC = NO;
    addcourse.delegate = self;
    [self.navigationController pushViewController:addcourse animated:YES];
    [addcourse release];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - SchoolViewControllerDelegate
- (void)addBuddyFromSchoolWithPersonModel:(PersonModel *)person{
    
    if ([Database schoolMemberAlreadyAddBuddy:person.uid] || ([[WTUserDefaults getUid] isEqualToString:person.uid]) ){
        ContactInfoViewController *infoViewController = [[ContactInfoViewController alloc] initWithNibName:@"ContactInfoViewController" bundle:nil];
        Buddy *buddy = [Database buddyWithUserID:person.uid];
        infoViewController.buddy = buddy;
        infoViewController.contact_type = CONTACT_FRIEND;
        [self.navigationController pushViewController:infoViewController animated:YES];
        [infoViewController release];
    }else{
        AddBuddyFromSchoolVC *addBuddyFromSchool = [[AddBuddyFromSchoolVC alloc]init];
        addBuddyFromSchool.color = BLUE_COLOR_IN_ADDBUDDYFROMSCHOOLVC;
        addBuddyFromSchool.person = person;
        [self.navigationController pushViewController:addBuddyFromSchool animated:YES];
        [addBuddyFromSchool release];
    }
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark - AddCourseControllerDelegate
- (void)refreshSchoolTree{
    [self.schoolVC loadData];
}


#pragma mark - ParentChatViewControllerDelegate
- (void)didBeginChat:(ParentChatViewController *)parentChatViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
