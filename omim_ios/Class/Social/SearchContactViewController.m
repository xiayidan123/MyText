//
//  SearchContactViewController.m
//  omim
//
//  Created by Harry on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "SearchContactViewController.h"
#import "Constants.h"
#import "PublicFunctions.h"
#import <QuartzCore/QuartzCore.h>

#import "SearchCell.h"

#import "WTHeader.h"

#import "GroupContactViewController.h"
#import "OfficialAccountViewController.h"
#import "NonUserContactViewController.h"
#import "ContactInfoViewController.h"
#import "UserResultCell.h"

#import "BizSearchBar.h"
#import "MessageVerificationViewController.h"
@interface SearchContactViewController ()
{
    BOOL isGroupMode;
    UILabel* leftLabel;
    UILabel* rightLabel;
    BOOL hasToShowResultView;
    NSString* oldSearchKey;
    int addFriendRule;
}
@property (nonatomic, retain) UserGroup* selectedGroup;

@property (nonatomic, retain) UIButton* btn_searchUser;
@property (nonatomic, retain) UIButton* btn_searchGroup;
@property (nonatomic, retain) UIButton* btn_search;

@property (nonatomic, retain) UIButton* btn_hide;

@property (nonatomic, retain) UIView* uv_container;

@property (nonatomic, retain) UIView* resutltview;

@property (nonatomic, retain) NSMutableArray* arr_results;
@property (nonatomic, retain) NSMutableArray *userResults;

@end


@implementation SearchContactViewController

@synthesize idSearchView = _idSearchView;
@synthesize backButton;
@synthesize searchBar = _searchBar;
@synthesize tableView = _tableView;
@synthesize buddyid ;
@synthesize searchOfficialAccountMode;

#pragma mark - button action
-(void)becomeUserMode:(id)sender
{
    _searchBar.text = oldSearchKey;
    [oldSearchKey release];
    
    if (hasToShowResultView) {
        self.resutltview.hidden = NO;
        _userTableView.hidden = NO;
    }
    self.tableView.hidden = YES;
    self.resutltview.hidden = YES;
    self.btn_searchUser.enabled = NO;
    self.btn_searchGroup.enabled = YES;
    
    isGroupMode = NO;
    
    [self.btn_searchUser setBackgroundImage:[UIImage imageNamed:@"tab_button_left_a.png"] forState:UIControlStateNormal];
    [self.btn_searchGroup setBackgroundImage:[UIImage imageNamed:@"tab_button_right.png"] forState:UIControlStateNormal];
    _searchBar.placeholder = NSLocalizedString(@"Enter account ID to search",nil);
    
    leftLabel.textColor = [UIColor whiteColor];
    rightLabel.textColor = [UIColor whiteColor];
}

-(void)becomeGroupMode:(id)sender
{
    oldSearchKey = _searchBar.text;
    [oldSearchKey retain];
    _searchBar.text = @"";
    
    if (self.resutltview.hidden == NO) {
        hasToShowResultView = YES;
    }
    self.tableView.hidden = NO;
    self.resutltview.hidden = YES;
    _userTableView.hidden = YES;
    
    self.btn_searchUser.enabled = YES;
    self.btn_searchGroup.enabled = NO;
    
    isGroupMode = YES;
    
    [self.btn_searchUser setBackgroundImage:[UIImage imageNamed:@"tab_button_left.png"] forState:UIControlStateNormal];
    [self.btn_searchGroup setBackgroundImage:[UIImage imageNamed:@"tab_button_right_a.png"] forState:UIControlStateNormal];
    
    _searchBar.placeholder = NSLocalizedString(@"Please enter group ID or name",nil);
    rightLabel.textColor = [UIColor whiteColor];
    leftLabel.textColor = [UIColor whiteColor];
}

-(void)search:(id)sender
{
    self.btn_hide.hidden = YES;
    
    if (_searchBar.text == nil ||  [_searchBar.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Search key can't be empty", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (isGroupMode) {
        [WowTalkWebServerIF getGroupByKey:_searchBar.text withCallback:@selector(getGroupSearchResult:) withObserver:self];
        [_searchBar resignFirstResponder];
        
    }
    else {
        NSMutableArray *types = [[NSMutableArray alloc] init];
        if (self.searchOfficialAccountMode) {
            [types addObject:@"0"];
        } else {
            [types addObject:@"1"];
            [types addObject:@"2"];
        }
        [WowTalkWebServerIF fuzzySearchUserByKey:_searchBar.text withType:types withDelegate:self withCallBack:@selector(getUserSearchResult:) withObserver:self];
        [_searchBar resignFirstResponder];
    }
    
    [_searchBar resignFirstResponder];
}

-(void)resignTheSearchbar:(id)sender
{
    [_searchBar resignFirstResponder];
    [self.btn_hide setHidden:YES];
}

#pragma mark - navigation bar.
-(void)configNav
{
    UIBarButtonItem *backBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:backBarButton];
    [backBarButton release];

    
    if (self.searchOfficialAccountMode) {
        UILabel* label = [[[UILabel alloc] init] autorelease];
        label.text =  NSLocalizedString(@"Search offical accounts",nil);
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        self.navigationItem.titleView = label;
        
    }
    else{
        
        
        CGFloat user_label_width = [UILabel labelWidth:NSLocalizedString(@"Search friends", nil) FontType:12 withInMaxWidth:160];
        
        CGFloat group_label_width = [UILabel labelWidth:NSLocalizedString(@"Search groups", nil) FontType:12 withInMaxWidth:160];
        
        CGFloat button_width = group_label_width>user_label_width? group_label_width+20:user_label_width+20;
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(160-button_width, 0, 2*button_width, 32)];
        
        
        self.btn_searchUser = [[[UIButton alloc]  initWithFrame:CGRectMake(0, 0, button_width, view.frame.size.height)] autorelease];
        [self.btn_searchUser setBackgroundImage:[UIImage imageNamed:@"tab_button_left_a.png"] forState:UIControlStateNormal];
        [self.btn_searchUser addTarget:self action:@selector(becomeUserMode:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_searchUser.enabled = NO;
        
        [view addSubview:self.btn_searchUser];
        
        self.btn_searchGroup = [[[UIButton alloc]  initWithFrame:CGRectMake( view.frame.size.width/2, 0, button_width, view.frame.size.height)] autorelease];
        [self.btn_searchGroup setBackgroundImage:[UIImage imageNamed:@"tab_button_right.png"] forState:UIControlStateNormal];
        [self.btn_searchGroup addTarget:self action:@selector(becomeGroupMode:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_searchGroup.enabled = YES;
        
        [view addSubview:self.btn_searchGroup];
        
        leftLabel = [[UILabel alloc] initWithFrame:self.btn_searchUser.frame];
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.text = NSLocalizedString(@"Search friends", nil);
        leftLabel.textColor = [UIColor whiteColor];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.font = [UIFont boldSystemFontOfSize:12.0];
        
        [view addSubview:leftLabel];
        [leftLabel release];
        
        rightLabel = [[UILabel alloc] initWithFrame:self.btn_searchGroup.frame];
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.text = NSLocalizedString(@"Search groups", nil);
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.font = [UIFont boldSystemFontOfSize:12.0];
        
        [view addSubview:rightLabel];
        [rightLabel release];
        
        [self.navigationItem setTitleView:view];
        [view release];
    }
    
    
}

#pragma mark -
#pragma mark View Handle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setFrame:CGRectMake(0, 0, [UISize screenWidth], [UISize screenHeightNotIncludingStatusBarAndNavBar])];
    [self.view setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    
    
    [self configNav];
    
    self.uv_container = [[[UIView alloc] initWithFrame:self.view.frame] autorelease];
    [self.uv_container setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.uv_container];
    
    [self initSearchBarView];
    
    [self initSearchUserTableView];
    [self initSearchGroupTableView];
    
    [self initResultView];
    
    
    self.btn_hide = [[[UIButton alloc] init] autorelease];
    
    [self.btn_hide setFrame:CGRectMake(0, _searchBar.frame.size.height + _searchBar.frame.origin.y, 320, self.uv_container.frame.size.height - _searchBar.frame.size.height)];
    [self.btn_hide setBackgroundColor:[UIColor clearColor]];
    
    [self.btn_hide addTarget:self action:@selector(resignTheSearchbar:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btn_hide setHidden:YES];
    
    [self.uv_container addSubview:self.btn_hide];
    
    self.resutltview.hidden = YES;
    self.tableView.hidden = YES;
    
    self.arr_results = [[[NSMutableArray alloc] init] autorelease];
    

    [self.view setAutoresizesSubviews:NO];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    
}

-(void)initSearchBarView
{
    int searchButtonWidth=60;
    self.btn_search=[[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-searchButtonWidth, 0, searchButtonWidth, 45)];
    [self.btn_search setTitle:NSLocalizedString(@"Search",nil) forState:UIControlStateNormal];
    [self.btn_search setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn_search setTitleColor:[UIColor colorWithRed:72.0/255 green:177.0/255 blue:180.0/255 alpha:1.0] forState:UIControlStateHighlighted];
    self.btn_search.titleLabel.font = [UIFont systemFontOfSize:15];
//    [self.btn_search setBackgroundImage:[UIImage imageNamed:LARGE_BLUE_BUTTON] forState:UIControlStateNormal];
    self.btn_search.backgroundColor=[Colors wowtalkbiz_searchbar_bg];
    [self.btn_search addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [self.uv_container addSubview:self.btn_search];
    
    _searchBar = [[BizSearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width-searchButtonWidth , 45)];
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.keyboardType = UIKeyboardTypeNamePhonePad;
    _searchBar.backgroundColor=[UIColor clearColor];
    
    if(self.searchOfficialAccountMode){
        _searchBar.placeholder = NSLocalizedString(@"Enter official account ID to search",nil);
    }
    else{
        _searchBar.placeholder = NSLocalizedString(@"Enter account ID to search",nil);
    }
    
    [self.uv_container addSubview:_searchBar];
    [_searchBar release];
    
}

-(void)initResultView
{
    self.resutltview = [[[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, self.uv_container.frame.size.height - 45)] autorelease];
    
    self.resutltview.backgroundColor = [UIColor clearColor];
    
    imageViewFrame = [[UIImageView alloc]initWithFrame:CGRectMake(108, 100, 104, 104)];
    imageViewFrame.image = [UIImage imageNamed:@"avatar_mask_90.png"];
    imageViewPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(115, 107, 90, 90)];
    imageViewPhoto.image = [UIImage imageNamed:DEFAULT_AVATAR];
    
    
    UIButton* btn = [[UIButton alloc] initWithFrame:imageViewFrame.frame];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(viewBuddy) forControlEvents:UIControlEventTouchUpInside];
    
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 210, 320, 20)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"";
    
    addButton = [[UIButton alloc] initWithFrame:CGRectMake(103, 250, 114, 37)];
    [addButton setImage:[UIImage imageNamed:LARGE_BLUE_BUTTON] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:LARGE_BLUE_BUTTON] forState:UIControlStateHighlighted];
    
    [addButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    addLabel = [[UILabel alloc]initWithFrame: CGRectMake(0, 0, 114, 37)];
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.backgroundColor = [UIColor clearColor];
    addLabel.text = NSLocalizedString(@"Add",nil);
    addLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
    addLabel.shadowOffset = CGSizeMake(0, 1);
    
    [self.resutltview addSubview:imageViewFrame];
    [self.resutltview addSubview:imageViewPhoto];
    [self.resutltview addSubview:nameLabel];
    [self.resutltview addSubview:addButton];
    [addButton addSubview:addLabel];
    
    [self.resutltview addSubview:btn];
    
    [self.uv_container addSubview:self.resutltview];
    
    
    [btn release];
    [imageViewFrame release];
    [imageViewPhoto release];
    [nameLabel release];
    [addLabel release];
    [addButton release];
    
}


-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initSearchGroupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, self.uv_container.frame.size.height - 45) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    [self.uv_container  addSubview:_tableView];
    
    [_tableView release];
}

- (void)initSearchUserTableView
{
    self.userTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, self.uv_container.frame.size.height - 45) style:UITableViewStylePlain] autorelease];
    [_userTableView setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    [_userTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_userTableView setDelegate:self];
    [_userTableView setDataSource:self];
    [_userTableView setHidden:YES];
    [self.uv_container addSubview:_userTableView];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return [self.arr_results count];
    } else {
        return [self.userResults count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        static NSString *CellId = @"SearchCell";
        SearchCell *searchObjectCell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
        
        if (!searchObjectCell) {
            searchObjectCell = [[[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId] autorelease];
        }
        
        UserGroup* group = [self.arr_results objectAtIndex:indexPath.row];
        searchObjectCell.groupName.text = group.groupNameOriginal;
        searchObjectCell.groupNumber.text  = group.shortid;
        NSData* data = [AvatarHelper getThumbnailForGroup:group.groupID];
        
        if (data) {
            searchObjectCell.groupImageview.image =  [UIImage imageWithData:data];
        }
        else
        {
            searchObjectCell.groupImageview.image = [UIImage imageNamed:DEFAULT_GROUP_AVATAR];
            [WowTalkWebServerIF getGroupAvatarThumbnail:group.groupID withCallback:@selector(didGetGroupThumbnail:) withObserver:self];
        }
        return searchObjectCell;
    } else {
        static NSString *CellIdentifier = @"UserSearchCell";
        UserResultCell *cell = (UserResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (UserResultCell *)[[[NSBundle mainBundle] loadNibNamed:@"UserResultCell" owner:self options:nil] objectAtIndex:0];
        }
        
        Buddy *buddy = [self.userResults objectAtIndex:indexPath.row];
        cell.headImageView.buddy = buddy;
        
        NSData *data = [AvatarHelper getThumbnailForUser:buddy.userID];
        if (data) {
            cell.headImageView.headImage = [UIImage imageWithData:data];
        } else if(buddy.needToDownloadThumbnail) {
            cell.headImageView.headImage = [UIImage imageNamed:@"avatar_84.png"];
            [WowTalkWebServerIF getThumbnailForUserID:buddy.userID withCallback:@selector(getBuddyThumbnail:) withObserver:self];
        }
        cell.idLabel.text = buddy.wowtalkID;
        cell.nameLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Nickname", nil), buddy.nickName];
        cell.addButton.tag = indexPath.row;
        
        if (buddy.isFriend) {
            [cell.addButton setEnabled:NO];
            
        }
        else{
            
           if ([buddy.userID isEqualToString:[WTUserDefaults getUid]]){
                cell.addButton.hidden = YES;
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"不能添加自己" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [av show];
                [av release];

            }
            else
                cell.addButton.hidden = NO;
            
            [cell.addButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
            [cell.addButton setEnabled:YES];

        }
        
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        return 61;
    } else {
        return 61;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([tableView isEqual:self.tableView]) {
        self.selectedGroup = [self.arr_results objectAtIndex:indexPath.row];
        GroupContactViewController* gcvc = [[GroupContactViewController alloc] init];
        gcvc.group = self.selectedGroup;
        
        UserGroup* group =  [Database getFixedGroupByID:self.selectedGroup.groupID];
        
        if (group!=nil) {
            gcvc.groupid = self.selectedGroup.groupID;
            gcvc.isStanger = NO;
        }
        else{
            gcvc.isStanger = YES;
            gcvc.group.memberList = nil;
            gcvc.NoNeedToInitGroup = YES;
        }
        [self.navigationController pushViewController:gcvc animated:YES];
        [gcvc release];
    } else {
        [self viewBuddyWithInfo:[self.userResults objectAtIndex:indexPath.row]];
    }
    
    
}


-(void)viewBuddy
{
    Buddy* buddy = [Database buddyWithUserID:self.buddyid];
    // if it is me, don't jump to the detail page
    
    [self viewBuddyWithInfo:buddy];
    
}

-(void)viewBuddyWithInfo:(Buddy *)buddy
{
    if ([self.buddyid isEqualToString:[WTUserDefaults getUid]]) {
        return;
    }
    
    if (buddy.userType  == 0) {
        OfficialAccountViewController* oavc = [[OfficialAccountViewController alloc] init];
        oavc.account = buddy;
        [self.navigationController pushViewController:oavc animated:YES];
        [oavc release];
    }
    
    else{
        if ([buddy.buddy_flag isEqualToString:@"1"]) {
            ContactInfoViewController *contactInfoViewController = [[ContactInfoViewController alloc] initWithNibName:@"ContactInfoViewController" bundle:nil];
            contactInfoViewController.buddy = buddy;
            contactInfoViewController.contact_type = CONTACT_FRIEND;
            [self.navigationController pushViewController:contactInfoViewController animated:YES];
            [contactInfoViewController release];
        }
        /*else if ([buddy.buddy_flag isEqualToString:@"2"]){
            NonUserContactViewController* nucvc = [[NonUserContactViewController alloc] init];
            nucvc.buddy = buddy;
            [self.navigationController pushViewController:nucvc animated:YES];
            [nucvc release];
            
        }*/
        else{
            ContactInfoViewController *contactInfoViewController = [[ContactInfoViewController alloc] initWithNibName:@"ContactInfoViewController" bundle:nil];
            contactInfoViewController.buddy = buddy;
            contactInfoViewController.contact_type = CONTACT_STRANGER;
            [self.navigationController pushViewController:contactInfoViewController animated:YES];
            [contactInfoViewController release];
        }
        
    }
}

#pragma mark -
#pragma mark UISearchBarDelegate

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    self.btn_hide.hidden = YES;
    
    if (searchBar.text == nil ||  [searchBar.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Search key can't be empty", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (isGroupMode) {
        [WowTalkWebServerIF getGroupByKey:searchBar.text withCallback:@selector(getGroupSearchResult:) withObserver:self];
        [_searchBar resignFirstResponder];
        
    }
    else{
        NSMutableArray *types = [[NSMutableArray alloc] init];
        if (self.searchOfficialAccountMode) {
            [types addObject:@"0"];
        } else {
            [types addObject:@"1"];
            [types addObject:@"2"];
        }
        [WowTalkWebServerIF fuzzySearchUserByKey:_searchBar.text withType:types withDelegate:self withCallBack:@selector(getUserSearchResult:) withObserver:self];
        [_searchBar resignFirstResponder];
    }
}


-(void)getUserSearchResult:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
        self.resutltview.hidden = YES;
        Buddy *buddy = [[notif userInfo]  objectForKey:WT_BUDDY];
        
        if ([buddy.buddy_flag isEqualToString:@"1"] || [buddy.userID isEqualToString:[WTUserDefaults getUid]]) {
            addButton.hidden = YES;
            
        }
        else
            addButton.hidden = NO;
        
        if (buddy)
        {
            addFriendRule = buddy.addFriendRule;
            
            self.buddyid = buddy.userID;
            nameLabel.text = buddy.nickName;
            
            NSData *data = [AvatarHelper getThumbnailForUser:buddy.userID];
            if (data)
                imageViewPhoto.image = [UIImage imageWithData:data];
            else{
                if (buddy.userType == 0) {
                    imageViewPhoto.image = [UIImage imageNamed:DEFAULT_OFFICIAL_AVARAR];
                    addLabel.text = NSLocalizedString(@"Follow", nil);
                } else {
                    if ([buddy.buddy_flag isEqualToString:@"2"]) {
                        imageViewPhoto.image = [UIImage imageNamed:DEFAULT_AVATAR_OFFLINE_IMAGE_90];
                    }
                    else {
                        imageViewPhoto.image = [UIImage imageNamed:DEFAULT_AVATAR];
                    }
                }
                
                
            }
            if (buddy.needToDownloadThumbnail && ![buddyid isEqualToString:[WTUserDefaults getUid]]){
                [WowTalkWebServerIF getThumbnailForUserID:self.buddyid withCallback:@selector(getBuddyThumbnail:) withObserver:self];
            }
        }
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to find the user", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}


-(void)getGroupSearchResult:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.btn_hide.hidden = YES;
        
        self.arr_results = [[notif userInfo] valueForKey:WT_SEARCH_RESULT];
        [self.tableView reloadData];
        
    }
}


- (void)getBuddyThumbnail:(NSNotification *)notification
{
    NSError* error = [[notification userInfo]valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSData *data = [AvatarHelper getThumbnailForUser:self.buddyid];
        if (data) {
            [self.userTableView reloadData];
        }
//            imageViewPhoto.image = [UIImage imageWithData:data];
        
    }
    
}

-(void)didGetGroupThumbnail:(NSNotification*)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [self.tableView reloadData];
    }
    
}

//called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.btn_hide.hidden = NO;
    return YES;
}


-(void)addFriend:(UIButton *)sender
{
    Buddy *buddy = [_userResults objectAtIndex:sender.tag];
//    [WowTalkWebServerIF addBuddy:buddy.userID withMsg:nil withCallback:@selector(didAddFriend:) withObserver:self];
    
    [WowTalkWebServerIF getThumbnailForUserID:buddy.userID withCallback:@selector(getBuddyThumbnail:) withObserver:self];
    MessageVerificationViewController *message = [[MessageVerificationViewController alloc]init];
    message.buddy = buddy;
//    message.addFriendRule = addFriendRule;
    [self.navigationController pushViewController:message animated:YES];
    return;
    if (addFriendRule == 2) {
        [WowTalkWebServerIF addBuddy:buddyid withMsg:nil withCallback:@selector(didAddFriend:) withObserver:self]; // TODO: change here.
    }
    else if(addFriendRule == 1){
        
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
                      [WowTalkWebServerIF addBuddy:buddyid withMsg:[alertView enteredText] withCallback:@selector(didAddFriend:) withObserver:self];
                }
                
                [alertView close];
            }];
            
            [alertView setUseMotionEffects:YES];
            
            // And launch the dialog
            [alertView show];
        }
        else{
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
     [theTextField release];
    
    theTextField.tag = 100;
    
    [titleView addSubview:theTextField];
    [theTextField release];
    
    return titleView;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [WowTalkWebServerIF addBuddy:buddyid withMsg:[(TextFieldAlertView*)alertView enteredText] withCallback:@selector(didAddFriend:) withObserver:self]; // TODO: change here.
    }
}

- (void)didAddFriend:(NSNotification *)notification
{
    NSDictionary *infodict = [notification userInfo];
    NSError *err = [infodict objectForKey:@"error"];
    if (err && err.code != 0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to send request", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        if (addFriendRule == 2) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Friend has been added", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else{
            return ;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Request is sent",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
//            [alert show];
//            [alert release];
        }
    }
}

- (void)didFinishFuzzySearchWithResult:(NSMutableArray *)result
{
    if (result == nil || [result count] == 0) {
        return;
    }
    _userTableView.hidden = NO;
    self.userResults = result;
    [self.userTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    _searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
}

@end