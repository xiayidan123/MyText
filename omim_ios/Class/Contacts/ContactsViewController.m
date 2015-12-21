//
//  ContantsViewController.m
//  omim
//
//  Created by coca on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "ContactsViewController.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "AddContactViewController.h"
#import "AddCourseController.h"
#import "WowTalkWebServerIF.h"
#import "AddBuddyFromSchoolVC.h"
#import "Database.h"
#import "ContactInfoViewController.h"
#import "WTHeader.h"
#import "MBProgressHUD.h"

#import "OMNetWork_MyClass_Constant.h"

@implementation ContactsViewController
{
    CABasicAnimation *rotate;
}

@synthesize contactListVC;
@synthesize schoolVC;
@synthesize mySeg;


#pragma mark - View Life Circle

- (void)addContact
{
    if (self.mySeg.selectedSegmentIndex == 0){
        AddContactViewController *addViewController = [[AddContactViewController alloc] init];
        addViewController.enableGroupCreation = YES;
        [self.navigationController pushViewController:addViewController animated:YES];
        [addViewController release];
    }else if (self.mySeg.selectedSegmentIndex == 1){
        AddCourseController *addcourse = [[AddCourseController alloc]init];
        addcourse.isInvitationCodeInHomeVC = NO;
        addcourse.delegate = self;
        [self.navigationController pushViewController:addcourse animated:YES];
        [addcourse release];
    }
    
}

/*联系人－按钮图片以及校园里－按钮图片切换*/
-(void)swtRightButton: (NSString *) img_name
{
    UIBarButtonItem* barButton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:img_name] selector:@selector(addContact)];
    [self.navigationItem addRightBarButtonItem:barButton];
    [barButton release];
    
}

-(void)segClicked:(UISegmentedControl*)seg{
   
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSString *img_name = @"icon_topbar_add_new";
    if(seg.selectedSegmentIndex == 0){
        
        [self swtRightButton:img_name];
        [self.contactListVC viewWillAppear:YES];
        [self.schoolVC.view setHidden:YES];
        [self.contactListVC.view setHidden:NO];
    }
    else{
        img_name = @"icon_topbar_add";
        [self swtRightButton:img_name];
        [self.schoolVC viewWillAppear:YES];

        [self.schoolVC.view setHidden:NO];
        [self.contactListVC.view setHidden:YES];
    }
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)configNav{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.67 blue:0.93 alpha:1];
    
    mySeg = [[[UISegmentedControl alloc]initWithItems:@[NSLocalizedString(@"通讯录", nil),NSLocalizedString(@"校园里", nil)]] autorelease];
    mySeg.frame = CGRectMake(0, 0, 180, 30);
    mySeg.selectedSegmentIndex = 0;
    [mySeg setTintColor:[UIColor whiteColor]];
    [mySeg addTarget:self action:@selector(segClicked:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = mySeg;
    
    UIBarButtonItem* barButton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:@"icon_topbar_add_new"] selector:@selector(addContact)];
    [self.navigationItem addRightBarButtonItem:barButton];
    
    [barButton release];
    
    
    barButton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_REFRESH] selector:@selector(refreshMembers)];
    leftNavItem = barButton;
    [self.navigationItem addLeftBarButtonItem:barButton];
}

-(void)refreshMembers{
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat:360 * M_PI/180];
    rotate.duration = 1.0;
    rotate.repeatCount = 2;
    rotate.delegate=self;
    [leftNavItem.customView.layer addAnimation:rotate forKey:@"111"];
    if (mySeg.selectedSegmentIndex ==0) {
        [WowTalkWebServerIF getMatchedBuddyListWithCallback:nil withObserver:nil];
        [WowTalkWebServerIF getMyGroupsWithCallback:nil withObserver:nil];
    }
    else{
        [self.schoolVC loadData];
    }
}


- (void)stopRotate
{
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.toValue = [NSNumber numberWithFloat:360 * M_PI/180];
    rotate.duration = 1.0;
    rotate.repeatCount = 1;
    rotate.delegate=self;
    [leftNavItem.customView.layer addAnimation:rotate forKey:@"222"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configNav];
    
    self.schoolVC = [[[SchoolViewController alloc] init] autorelease];
    self.schoolVC.delegate = self;
    self.contactListVC = [[[ContactListViewController alloc] init] autorelease];
    self.contactListVC.parent = self;
    
    [self.view addSubview:self.schoolVC.view];
    [self.view addSubview:self.contactListVC.view];

    [self.schoolVC.view setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WebFailed:) name:@"WebServiceRequestFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRotate) name:@"WebServiceRequestSucceed" object:nil];
    [OMNotificationCenter addObserver:self selector:@selector(refresh) name:MY_CLASS_GETSCHOOLINFO object:nil];
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)WebFailed:(NSNotification *)not
{
    __block MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hub];
    hub.labelText = @"网络请求超时";
    hub.labelFont = [UIFont systemFontOfSize:16];
    hub.mode = MBProgressHUDModeText;
    [hub showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [hub removeFromSuperview];
        hub = nil;
    }];
    [self stopRotate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**
     *  获取请求添加好友的数量，将数量显示在新朋友cell的右边
     */
    [WowTalkWebServerIF getAllPendingRequest:nil withObserver:nil];
    
    if(mySeg.selectedSegmentIndex == 0){
        [self.contactListVC viewWillAppear:YES];
    }
    else{
        [self.schoolVC viewWillAppear:YES];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if(mySeg.selectedSegmentIndex == 0){
        [self.contactListVC viewDidAppear:YES];
    }
    else{
        [self.schoolVC viewDidAppear:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WebServiceRequestFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WebServiceRequestSucceed" object:nil];
    [OMNotificationCenter removeObserver:self name:MY_CLASS_GETSCHOOLINFO object:nil];
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

-(void)refresh{
    [WowTalkWebServerIF getMatchedBuddyListWithCallback:nil withObserver:nil];
    [WowTalkWebServerIF getMyGroupsWithCallback:nil withObserver:nil];
    [self.schoolVC loadData];
}

#pragma mark - AddCourseControllerDelegate
- (void)refreshSchoolTree{
    [self.schoolVC loadData];
}


@end
