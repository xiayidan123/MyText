//
//  SearchOfficialAccountViewController.m
//  dev01
//
//  Created by elvis on 2013/07/02.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "SearchOfficialAccountViewController.h"
#import "PublicFunctions.h"
#import "Constants.h"

#import "WTHeader.h"
#import "BizSearchBar.h"

#import "SearchCell.h"
#import "OfficialCell.h"
#import "OfficialAccountViewController.h"
#import <MapKit/MapKit.h>

#define PRIORITY_DISTANCE       @"distance"
#define PRIORITY_RECOMMENDED    @"recommended"
#define PRIORITY_LATEST         @"latest"

@interface SearchOfficialAccountViewController ()

@property (nonatomic, retain) NSMutableArray* arr_results;
@property (nonatomic, retain) UIButton* hideButton;
@property (nonatomic, retain) UIButton* btn_search;
@property (nonatomic, retain) UserGroup* selectedGroup;

@property (nonatomic, retain) UISearchBar* searchbar;

@property (nonatomic, retain) UIView* resutltview;
@property (nonatomic, copy) NSString *priority;
@property (nonatomic, retain) CLLocation *location;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *netIndicator;

@end

@implementation SearchOfficialAccountViewController

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
    [self customSearchBar];
    
    self.arr_results = [[[NSMutableArray alloc] init] autorelease];
    
    // add the button to hide the keyboard.
    self.hideButton = [[[UIButton alloc] init] autorelease];
    [self.hideButton setFrame:CGRectMake(0, self.searchbar.frame.size.height + self.searchbar.frame.origin.y, 320, self.view.frame.size.height - self.searchbar.frame.size.height)];
    [self.hideButton setBackgroundColor:[UIColor clearColor]];
    [self.hideButton addTarget:self action:@selector(resignTheSearchbar:) forControlEvents:UIControlEventTouchUpInside];
    [self.hideButton setHidden:YES];
    
    [self.view addSubview:self.hideButton];
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    self.priority = PRIORITY_RECOMMENDED;
    _indicatorLabel.hidden = NO;
    [_indicatorLabel setText:NSLocalizedString(@"Follow Public Account to get more information about their service", nil)];
    _tb_search.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tb_search.frame = CGRectMake(0, 45.0, 320.0, [UISize screenHeightNotIncludingStatusBarAndNavBar] - 45.0);
    [self.tb_search reloadData];
    [self getLocation];
    self.indicatorLabel.hidden = YES;
    self.netIndicator.hidden = NO;
    [self.netIndicator startAnimating];
    [WowTalkWebServerIF searchOfficialByKey:nil
                               withPriority:self.priority
                                   withInfo:nil
                               withDelegate:self
                               withCallBack:@selector(searchFinished:)
                               withObserver:self];
}

- (void)getLocation
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    [locationManager release];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.location = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigation bar.
-(void)configNav
{
    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    UIBarButtonItem *chooseButton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:@"nav_chat_info.png"] selector:@selector(showActionSheet)];
    [self.navigationItem addRightBarButtonItem:chooseButton];
    [chooseButton release];
    // TODO:naming problems here.
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = NSLocalizedString(@"Public Account Search", nil);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showActionSheet
{
    [self.searchbar resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Distance", nil), NSLocalizedString(@"Recommended", nil), NSLocalizedString(@"Latest", nil), nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

#pragma mark - search bar.
-(void)customSearchBar
{
    self.searchbar = [[[BizSearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 45)] autorelease];
    self.searchbar.delegate = self;
    self.searchbar.barStyle = UIBarStyleDefault;
    self.searchbar.backgroundColor = [UIColor clearColor];
    
    self.searchbar.placeholder = NSLocalizedString(@"Search", nil);
    
    
    [self.view addSubview:self.searchbar];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arr_results count];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"OfficialCell";
    OfficialCell *officialCell = (OfficialCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
    

    if (!officialCell) {
        officialCell = [[[OfficialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId] autorelease];
    }
    Buddy *buddy = [self.arr_results objectAtIndex:indexPath.row];
    officialCell.nameLabel.text = buddy.nickName;
    NSData *data = [AvatarHelper getThumbnailForUser:buddy.userID];
    if (data) {
        officialCell.thumbImageView.image = [UIImage imageWithData:data];
    } else {
        officialCell.thumbImageView.image = [UIImage imageNamed:DEFAULT_OFFICIAL_AVARAR];
    }
    return officialCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OfficialAccountViewController *officialViewController = [[OfficialAccountViewController alloc] init];
    officialViewController.account = [self.arr_results objectAtIndex:indexPath.row];
    officialViewController.noShowGoToMoment=true;
    [self.navigationController pushViewController:officialViewController animated:YES];
    [officialViewController release];
    
}

- (void)searchFinished:(NSNotification *)notificaiton
{
}

-(void)search:(id)sender
{
    self.hideButton.hidden = YES;
    
    if (self.searchbar.text == nil ||  [self.searchbar.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Search key can't be empty", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    [self.searchbar resignFirstResponder];
}

-(void)resignTheSearchbar:(id)sender
{
    [self.searchbar resignFirstResponder];
    [self.hideButton setHidden:YES];
}


// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    self.hideButton.hidden = YES;
    
    if (searchBar.text == nil ||  [searchBar.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"Search key can't be empty", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    NSMutableDictionary *dic = nil;
    if ([self.priority isEqualToString:PRIORITY_DISTANCE]) {
        dic = [NSMutableDictionary dictionary];
        [dic setObject:@(self.location.coordinate.latitude) forKey:@"latitude"];
        [dic setObject:@(self.location.coordinate.longitude) forKey:@"longitude"];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [WowTalkWebServerIF searchOfficialByKey:self.searchbar.text
                               withPriority:self.priority
                                   withInfo:dic
                               withDelegate:self
                               withCallBack:@selector(searchFinished:)
                               withObserver:self];
    [self.searchbar resignFirstResponder];
}

-(void)getGroupSearchResult:(NSNotification*)notif
{
    self.hideButton.hidden = YES;
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.arr_results = [[notif userInfo] valueForKey:WT_SEARCH_RESULT];
        [self.tb_search reloadData];
    }
}

-(void)didGetGroupThumbnail:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.tb_search reloadData];
    }
    
}

//called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.hideButton.hidden = NO;
    return YES;
}

#pragma mark - SearchDelegate
- (void)didFinishSearchWithResult:(NSMutableArray *)results
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.netIndicator.hidden = YES;
    [self.netIndicator stopAnimating];
    self.tb_search.hidden = NO;
    self.indicatorLabel.hidden = YES;
    if (self.arr_results == nil) {
        self.arr_results = [[[NSMutableArray alloc] init] autorelease];
    }
    [self.arr_results removeAllObjects];
    [self.arr_results addObjectsFromArray:results];
    [self.tb_search reloadData];
    if ([self.arr_results count] == 0) {
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.priority = PRIORITY_DISTANCE;
    } else if (buttonIndex == 1) {
        self.priority = PRIORITY_RECOMMENDED;
    } else if (buttonIndex == 2) {
        self.priority = PRIORITY_LATEST;
    } else {
        return;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [WowTalkWebServerIF searchOfficialByKey:nil
                               withPriority:self.priority
                                   withInfo:nil
                               withDelegate:self
                               withCallBack:@selector(searchFinished:)
                               withObserver:self];
}

- (void)dealloc {
    [_tb_search release];
    [_indicatorLabel release];
    [_hideButton release];
    [_btn_search release];
    [_searchbar release];
    [_resutltview release];
    [_netIndicator release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTb_search:nil];
    [self setIndicatorLabel:nil];
    [self setHideButton:nil];
    [self setBtn_search:nil];
    [self setSearchbar:nil];
    [self setResutltview:nil];
    [self setNetIndicator:nil];
    [super viewDidUnload];
}
@end
