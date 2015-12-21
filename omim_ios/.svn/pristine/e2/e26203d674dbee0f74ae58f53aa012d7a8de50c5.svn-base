//
//  SearchGroupViewController.m
//  dev01
//
//  Created by elvis on 2013/07/01.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "SearchGroupViewController.h"
#import "PublicFunctions.h"
#import "Constants.h"

#import "WTHeader.h"

#import "SearchCell.h"
#import "GroupContactViewController.h"


@interface SearchGroupViewController ()

@property (nonatomic,retain) NSMutableArray* arr_results;
@property (nonatomic,retain) UIButton* btn_hide;
@property (nonatomic,retain) UIButton* btn_search;
@property (nonatomic,retain) UserGroup* selectedGroup;

@property (nonatomic,retain) UISearchBar* searchbar;

@end

@implementation SearchGroupViewController

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
    /*
     self.searchDisplayController.searchResultsDelegate = self;
     self.searchDisplayController.searchResultsDataSource = self;
     self.searchDisplayController.delegate = self;
     
     [self.searchDisplayController.searchResultsTableView setBackgroundColor:[Colors grayColor]];
     [self.searchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
     */
    [self customSearchBar];
    
    [self.tb_search setFrame:CGRectMake(0, self.searchbar.frame.size.height, 320, self.view.frame.size.height - 45)];
    [self.tb_search setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    [self.tb_search setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    self.arr_results = [[[NSMutableArray alloc] init] autorelease];
    
    // add the button to hide the keyboard.
    self.btn_hide = [[[UIButton alloc] init] autorelease];
    [self.btn_hide setFrame:CGRectMake(0, self.searchbar.frame.size.height + self.searchbar.frame.origin.y, 320, self.view.frame.size.height - self.searchbar.frame.size.height)];
    [self.btn_hide setBackgroundColor:[UIColor clearColor]];
    [self.btn_hide addTarget:self action:@selector(resignTheSearchbar:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_hide setHidden:TRUE];
    
    [self.view addSubview:self.btn_hide];
    
    
    
    
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
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = NSLocalizedString(@"Search groups",nil);
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

#pragma mark - search bar.
-(void)customSearchBar
{
    self.searchbar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width - 60, 45)] autorelease];
    self.searchbar.delegate = self;
    self.searchbar.barStyle = UIBarStyleDefault;
    self.searchbar.backgroundColor = [UIColor clearColor];
    
    self.searchbar.placeholder = NSLocalizedString(@"Please enter group ID or name",nil);
    
    
    UIView *searchBarBackGroundImage = [self.searchbar.subviews objectAtIndex:0];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_contact_bar.png"]];
    [searchBarBackGroundImage addSubview:bgImage];
    [bgImage release];
    
    
    UITextField *searchField = nil;
    NSUInteger numViews = [self.searchbar.subviews count];
    for(int i = 0; i < numViews; i++) {
        if([[self.searchbar.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
            searchField = [self.searchbar.subviews objectAtIndex:i];
        }
    }
    if(!(searchField == nil)) {
        searchField.textColor = [UIColor blackColor];
        [searchField setBackground: [UIImage imageNamed:@"search_field.png"] ];
        [searchField setBorderStyle:UITextBorderStyleNone];
    }
    
    
    self.btn_search = [[[UIButton alloc] initWithFrame:CGRectMake(260, 5, 55, 35)] autorelease];
    [self.btn_search setBackgroundImage:[PublicFunctions strecthableImage:@"search_btn.png"] forState:UIControlStateNormal];
    [self.btn_search addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel* label = [[UILabel alloc] initWithFrame:self.btn_search.frame];
    label.backgroundColor = [UIColor clearColor];
    label.text = NSLocalizedString(@"Search", nil);
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:12.0];
    
    [self.view addSubview:self.searchbar];
    [self.view addSubview:self.btn_search];
    [self.view addSubview:label];
    
    [label release];
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
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //GroupContactViewController* gcvc = [[GroupContactViewController alloc] init];
    self.selectedGroup = [self.arr_results objectAtIndex:indexPath.row];
    GroupContactViewController* gcvc = [[GroupContactViewController alloc] init];
    gcvc.group = self.selectedGroup;
    
    UserGroup* group =  [Database getFixedGroupByID:self.selectedGroup.groupID];
    
    if (group!=nil) {
        gcvc.groupid = self.selectedGroup.groupID;
        gcvc.isStanger = FALSE;
    }
    else{
        gcvc.isStanger = TRUE;
        gcvc.group.memberList = nil;
        gcvc.NoNeedToInitGroup = TRUE;
    }
    
    [self.navigationController pushViewController:gcvc animated:YES];
    [gcvc release];
    
}



-(void)search:(id)sender
{
    self.btn_hide.hidden = TRUE;
    
    if (self.searchbar.text == nil ||  [self.searchbar.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Search key can't be empty", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    [WowTalkWebServerIF getGroupByKey:self.searchbar.text withCallback:@selector(getGroupSearchResult:) withObserver:self];
    [self.searchbar resignFirstResponder];
}

-(void)resignTheSearchbar:(id)sender
{
    [self.searchbar resignFirstResponder];
    [self.btn_hide setHidden:TRUE];
}


// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    self.btn_hide.hidden = TRUE;
    
    if (searchBar.text == nil ||  [searchBar.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Search key can't be empty", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    [WowTalkWebServerIF getGroupByKey:searchBar.text withCallback:@selector(getGroupSearchResult:) withObserver:self];
    [self.searchbar resignFirstResponder];
}

-(void)getGroupSearchResult:(NSNotification*)notif
{
    self.btn_hide.hidden = TRUE;
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
    self.btn_hide.hidden = FALSE;
    return YES;
}

@end
