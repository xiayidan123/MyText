//
//  ContactListViewController.m
//  wowcity
//
//  Created by jianxd on 14-11-20.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "ContactListViewController.h"
#import "PublicFunctions.h"
#import "ImageNameConstant.h"
#import "Constants.h"
#import "Database.h"
#import "Buddy.h"
#import "UserGroup.h"
#import "ContactPreviewCell.h"
#import "TabBarViewController.h"
#import "RequestListViewController.h"
#import "GroupContactViewController.h"
#import "ContactInfoViewController.h"
#import "NonUserContactViewController.h"
#import "OfficialAccountViewController.h"
#import "OfficialListViewController.h"
#import "UIColor+HexColor.h"
#import "AppDelegate.h"
#import "AddContactViewController.h"
#import "UISize.h"
#import "WowTalkWebServerIF.h"
@interface ContactListViewController ()
{
    NSInteger indexOffset;
    BOOL hasPublicAccount;
    BOOL hasFamilyAccount;
    BOOL hasChatGroup;
}
@property (retain, nonatomic) NSMutableArray *indexForNotEmptySection;

@property (retain, nonatomic) NSMutableArray *familyAccounts;
@property (retain, nonatomic) NSMutableArray *chatGroups;

@property (retain, nonatomic) NSMutableArray *filteredArray;

@end

@implementation ContactListViewController

@synthesize indexForNotEmptySection = _indexForNotEmptySection;
@synthesize contactTableView = _contactTableView;
@synthesize accountSectionArray = _accountSectionArray;
@synthesize familyAccounts = _familyAccounts;
@synthesize chatGroups = _chatGroups;
@synthesize filteredArray = _filteredArray;

@synthesize parent;

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
    _contactTableView.backgroundView = nil;
    _contactTableView.backgroundColor = [UIColor clearColor];
    [self.contactTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.searchDisplayController setDelegate:self];
    self.indexForNotEmptySection = [[NSMutableArray alloc] init];
    self.accountSectionArray = [[NSMutableArray alloc] init];
    self.familyAccounts = [[NSMutableArray alloc] init];
    self.filteredArray = [[NSMutableArray alloc] init];
    [self configNavigation];

    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetNewRequest:) name:@"new_request" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewData) name:WT_GET_MATCHED_BUDDYS object:nil];

    
    [self.contactTableView setFrame:CGRectMake(0, 0, self.contactTableView.frame.size.width, [UISize screenHeight] - 20 - 44 - 49)];
    [self loadViewData];
    [AppDelegate sharedAppDelegate].contactListViewIsShown = YES;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate].tabbarVC refreshCustomBarUnreadNum];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"new_request" object:nil];
    [AppDelegate sharedAppDelegate].contactListViewIsShown = NO;
}


- (void)didGetNewRequest:(NSNotification *)notif {
    
    [self.contactTableView reloadData];
}

- (void)configNavigation
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.text = NSLocalizedString(@"contacts", nil);
    label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    UIBarButtonItem *barItem = [PublicFunctions getCustomNavButtonOnLeftSide:NO
                                                                      target:self
                                                                       image:[UIImage imageNamed:NAV_ADD_IMAGE]
                                                                    selector:@selector(addContact)];
    [self.navigationItem addRightBarButtonItem:barItem];
    [barItem release];
}

- (void)addContact
{
    AddContactViewController *addViewController = [[AddContactViewController alloc] init];
    addViewController.enableGroupCreation = YES;
    [self.parent.navigationController pushViewController:addViewController animated:YES];
    [addViewController release];
}

- (void)reloadViewData
{
    [self.contactTableView reloadData];
}

- (void)loadViewData
{
    [self loadData];
    [self reloadViewData];
}

- (void)loadData
{
    [self.accountSectionArray removeAllObjects];
    [self.indexForNotEmptySection removeAllObjects];
    [self.chatGroups removeAllObjects];
    [self.familyAccounts removeAllObjects];
    indexOffset = 0;
    NSMutableArray *friendDummyArray = [[NSMutableArray alloc] init];
    NSMutableArray *publicDummyArray = [[NSMutableArray alloc] init];
    [self.accountSectionArray addObject:friendDummyArray];
    [self.indexForNotEmptySection addObject:[NSNumber numberWithInteger:indexOffset]];
    indexOffset++;
    [self.accountSectionArray addObject:publicDummyArray];
    [self.indexForNotEmptySection addObject:[NSNumber numberWithInteger:indexOffset]];
    indexOffset++;
    [friendDummyArray release];
    [publicDummyArray release];
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *allContacts = [Database getContactListWithoutOfficialAccounts];
    self.chatGroups = [Database getAllFixedGroup];
    
    
    for (Buddy *buddy in allContacts) {
        if ([buddy.buddy_flag isEqualToString:@"2"]) {
            buddy.sectionNumber = -1;
            continue;
        }
        NSInteger sect = [collation sectionForObject:buddy collationStringSelector:@selector(nickName)];
        buddy.sectionNumber = sect;
    }
    
    if ([self.familyAccounts count] > 0) {
        hasFamilyAccount = YES;
        [self.indexForNotEmptySection addObject:[NSNumber numberWithInteger:indexOffset]];
        indexOffset++;
        [self.accountSectionArray addObject:self.familyAccounts];
    } else {
        hasFamilyAccount = NO;
    }
    if ([self.chatGroups count] > 0) {
        [self.accountSectionArray addObject:self.chatGroups];
        hasChatGroup = YES;
        [self.indexForNotEmptySection addObject:[NSNumber numberWithInteger:indexOffset]];
        indexOffset++;
    } else {
        hasChatGroup = NO;
    }
    
    
    
    NSInteger highSection = [[collation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [[[NSMutableArray alloc] init] autorelease];
        [sectionArrays addObject:sectionArray];
    }
    
    for (Buddy *buddy in allContacts) {
        if (buddy.sectionNumber >= 0) {
            [(NSMutableArray *)[sectionArrays objectAtIndex:buddy.sectionNumber] addObject:buddy];
        }
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [collation sortedArrayFromArray:sectionArray collationStringSelector:@selector(nickName)];
        [self.accountSectionArray addObject:sortedSection];
        if ([sortedSection count] != 0) {
            NSInteger section = [sectionArrays indexOfObject:sectionArray];
            [self.indexForNotEmptySection addObject:[NSNumber numberWithInteger:section + indexOffset]];
        }
    }
    
    if ([allContacts count] == 0 && [self.chatGroups count] == 0) {
        // show the label
    } else {
        // hide the label
    }
}

// the real data source in accountSectionArry for tablesection : tableSection
- (NSInteger)realSectionForTableSection:(NSInteger)tableSection
{
    return [[self.indexForNotEmptySection objectAtIndex:tableSection] integerValue];
}

- (NSUInteger)tableSectionIndexForRealSection:(NSInteger)realSection
{
    NSUInteger tableSection = 0;
    for (NSInteger i = indexOffset; i < [self.indexForNotEmptySection count]; i++) {
        NSUInteger tmpRealSection = [[self.indexForNotEmptySection objectAtIndex:i] integerValue] - indexOffset;
        if (tmpRealSection < realSection && i > tableSection) {
            tableSection = i;
            continue;
        }
        if (tmpRealSection == realSection) {
            tableSection = i;
        }
        if (tmpRealSection > realSection) {
            break;
        }
    }
    return tableSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"BaseTableCell";
    ContactPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactPreviewCell" owner:self options:nil] lastObject];
    }
    NSInteger section = indexPath.section;
    NSInteger realSection = [self realSectionForTableSection:section];
    NSInteger row = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell.nameLabel setFrame:CGRectMake(53, 3, 247, 25)];
    if (tableView == self.contactTableView) {
        UILabel *countLabel = (UILabel *)[cell.contentView viewWithTag:100];
        UIImageView *countImage = (UIImageView *)[cell.contentView viewWithTag:101];
        UIImageView *arrowImage = (UIImageView *)[cell.contentView viewWithTag:102];
        if (countLabel) {
            [countLabel removeFromSuperview];
        }
        if (countImage) {
            [countImage removeFromSuperview];
        }
        if (arrowImage) {
            [arrowImage removeFromSuperview];
        }
        
        if (section == 0 && row == 0) {
            // it's a dummy buddy, only used for show the new friend row
            cell.signatureLabel.hidden = YES;
            cell.authImageView.hidden = YES;
            cell.headImageView.buddy = nil;
            cell.headImageView.headImage = [UIImage imageNamed:FRIEND_REQUEST];
            cell.nameLabel.text = NSLocalizedString(@"New friend", nil);
            [cell.nameLabel setFrame:CGRectMake(cell.nameLabel.frame.origin.x, 14, cell.nameLabel.frame.size.width, cell.nameLabel.frame.size.height)];
            arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(286.0, 18.0, 9.0, 14.0)];
            arrowImage.tag = 102;
            arrowImage.image = [UIImage imageNamed:@"table_arrow.png"];
            [cell.contentView addSubview:arrowImage];
            [arrowImage release];
            if ( [[NSUserDefaults standardUserDefaults] integerForKey:NEW_REQUEST_NUM] > 0) {
                countImage = [[UIImageView alloc] initWithFrame:CGRectMake(260.0, 16.0, 20.0, 18.0)];
                [countImage setImage:[UIImage imageNamed:UNREAD_COUNT_BG]];
                countImage.tag = 101;
                [cell.contentView addSubview:countImage];
                [countImage release];
                countLabel = [[UILabel alloc] initWithFrame:countImage.frame];
                countLabel.backgroundColor = [UIColor clearColor];
                countLabel.textAlignment = NSTextAlignmentCenter;
                countLabel.adjustsFontSizeToFitWidth = YES;
                countLabel.textColor = [UIColor whiteColor];
                countLabel.tag = 100;
                [countLabel setText:[NSString stringWithFormat:@"%zi",  [[NSUserDefaults standardUserDefaults] integerForKey:NEW_REQUEST_NUM]]];
                [cell.contentView addSubview:countLabel];
                [countLabel release];
            }
            return cell;
        }
        
        if (section == 1 && row == 0) {
            cell.headImageView.buddy = nil;
            cell.headImageView.headImage = [UIImage imageNamed:@"contact_official.png"];
            cell.nameLabel.text = NSLocalizedString(@"Public Account", nil);
            cell.signatureLabel.hidden = YES;
            cell.authImageView.hidden = YES;
            [cell.nameLabel setFrame:CGRectMake(cell.nameLabel.frame.origin.x, 14, cell.nameLabel.frame.size.width, cell.nameLabel.frame.size.height)];
            UIImageView *arrowImage = (UIImageView *)[cell.contentView viewWithTag:102];
            if (arrowImage) {
                [arrowImage removeFromSuperview];
            }
            arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(286.0, 18.0, 9.0, 14.0)];
            arrowImage.image = [UIImage imageNamed:@"table_arrow.png"];
            arrowImage.tag = 102;
            [cell.contentView addSubview:arrowImage];
            [arrowImage release];
            return cell;
        }
        if (indexOffset == 2) {
            Buddy *buddy = [[self.accountSectionArray objectAtIndex:realSection] objectAtIndex:row];
            cell.buddy = buddy;
            [cell loadView];
        } else if (indexOffset == 3) {
            if (section == 2) {
                if (hasFamilyAccount) {
                    Buddy *buddy = [self.familyAccounts objectAtIndex:row];
                    cell.buddy = buddy;
                    [cell loadView];
                } else if (hasChatGroup) {
                    UserGroup *group = [self.chatGroups objectAtIndex:row];
                    cell.group = group;
                    [cell loadViewForGroup];
                }
            } else {
                Buddy *buddy = [[self.accountSectionArray objectAtIndex:realSection] objectAtIndex:row];
                cell.buddy = buddy;
                [cell loadView];
            }
        } else if (indexOffset == 4) {
            if (section == 2) {
                Buddy *buddy = [self.familyAccounts objectAtIndex:row];
                cell.buddy = buddy;
                [cell loadView];
            } else if (section == 3) {
                UserGroup *group = [self.chatGroups objectAtIndex:row];
                cell.group = group;
                [cell loadViewForGroup];
            } else {
                Buddy *buddy = [[self.accountSectionArray objectAtIndex:realSection] objectAtIndex:row];
                cell.buddy = buddy;
                [cell loadView];
            }
        }
        return cell;
    } else {
        id result = [self.filteredArray objectAtIndex:row];
        if ([result isKindOfClass:[Buddy class]]) {
            cell.buddy = (Buddy *)result;
            [cell loadView];
        } else if ([result isKindOfClass:[UserGroup class]]) {
            cell.group = (UserGroup *)result;
            [cell loadViewForGroup];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CONTACT_TABLEVIEWCELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.contactTableView) {
        if (section == 0 || section == 1) {
            return 0;
        } else {
            return CONTACT_TABLEVIEWCELL_SECTION_HEIGHT;
        }
    } else {
        return 0;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return nil;
    }
    if (indexOffset == 2) {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:[self realSectionForTableSection:section] - indexOffset];
    }
    if (indexOffset == 3) {
        if (section == 2) {
            if (hasFamilyAccount) {
                return NSLocalizedString(@"Family Member", nil);
            }
            if (hasChatGroup) {
                return NSLocalizedString(@"Group", nil);
            }
        }
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:[self realSectionForTableSection:section] - indexOffset];
    }
    if (indexOffset == 4) {
        if (section == 2) {
            return NSLocalizedString(@"Family Member", nil);
        }
        if (section == 3) {
            return NSLocalizedString(@"Group", nil);
        }
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:[self realSectionForTableSection:section] - indexOffset];
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.contactTableView) {
        return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.contactTableView]) {
        if (section == 0 || section == 1) {
            return 1;
        }
        return [[self.accountSectionArray objectAtIndex:[self realSectionForTableSection:section]] count];
    } else {
        return [self.filteredArray count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([tableView isEqual:self.contactTableView]) {
        return [self tableSectionIndexForRealSection:[[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index]];
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.contactTableView]) {
        return [self.indexForNotEmptySection count];
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return nil;
    }
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(TABLE_HEADER_LABEL_X_OFFSET, TABLE_HEADER_LABEL_Y_OFFSET, TABLE_HEADER_LABEL_WIDTH, TABLE_HEADER_LABEL_HEIGHT);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = POPLISTVIEW_TABLEVIEW_CELL_TEXT_COLOR;
    titleLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    titleLabel.font = [UIFont fontWithName:TABLE_HEADER_LABEL_FONT_NAME size:TABLE_HEADER_LABEL_FONT_SIZE];
    titleLabel.text = sectionTitle;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, TABLE_HEADER_IMAGEVIEW_HEIGHT)];
    imageView.image = [UIImage imageNamed:CONTACT_TABLEVIEW_SECTION_IMAGE];
    
    [imageView addSubview:titleLabel];
    [titleLabel release];
    return [imageView autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (tableView == self.contactTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (section == 0 && row == 0) {
            
            RequestListViewController *requestViewController = [[RequestListViewController alloc] init];
            [self.parent.navigationController pushViewController:requestViewController animated:YES];
            [requestViewController release];
            return;
        }
        if (section == 1 && row == 0) {
            // go into the public account page
            OfficialListViewController *officialViewController = [[OfficialListViewController alloc] init];
            [self.parent.navigationController pushViewController:officialViewController animated:YES];
            [officialViewController release];
            return;
        }
        if (indexOffset == 2) {
            Buddy *buddy = [[self.accountSectionArray objectAtIndex:[self realSectionForTableSection:section]] objectAtIndex:row];
            [self pushInDetailViewWithBuddy:buddy];
        } else if (indexOffset == 3) {
            if (section == 2) {
                if (hasFamilyAccount) {
                    // go to show family account page
                    [self pushInDetailViewWithBuddy:[self.familyAccounts objectAtIndex:row]];
                } else if (hasChatGroup) {
                    [self pushInDetailViewWithGroup:[self.chatGroups objectAtIndex:row]];
                }
            } else {
                Buddy *buddy = [[self.accountSectionArray objectAtIndex:[self realSectionForTableSection:section]] objectAtIndex:row];
                [self pushInDetailViewWithBuddy:buddy];
            }
        } else if (indexOffset == 4) {
            if (section == 2) {
                // family member sectoin, go to view detail of family member
                [self pushInDetailViewWithBuddy:[self.familyAccounts objectAtIndex:row]];
            } else if (section == 3) {
                // chat group section
                [self pushInDetailViewWithGroup:[self.chatGroups objectAtIndex:row]];
            } else {
                // normal buddy section
                Buddy *buddy = [[self.accountSectionArray objectAtIndex:[self realSectionForTableSection:section]] objectAtIndex:row];
                [self pushInDetailViewWithBuddy:buddy];
            }
        }
    } else {
        // search the table view
        if ([[self.filteredArray objectAtIndex:row] isKindOfClass:[Buddy class]]) {
            Buddy *buddy = [self.filteredArray objectAtIndex:row];
            [self pushInDetailViewWithBuddy:buddy];
        } else if ([[self.filteredArray objectAtIndex:row] isKindOfClass:[UserGroup class]]) {
            UserGroup *group = [self.filteredArray objectAtIndex:row];
            [self pushInDetailViewWithGroup:group];
        }
    }
}

- (void)pushInDetailViewWithBuddy:(Buddy *)buddy
{
    if ([buddy.buddy_flag isEqualToString:@"1"]) {
        ContactInfoViewController *infoViewController = [[ContactInfoViewController alloc] initWithNibName:@"ContactInfoViewController" bundle:nil];
        infoViewController.buddy = buddy;
        infoViewController.contact_type = CONTACT_FRIEND;
        [self.parent.navigationController pushViewController:infoViewController animated:YES];
        [infoViewController release];
    } else if ([buddy.buddy_flag isEqualToString:@"2"]) {
        NonUserContactViewController *nonUserViewController = [[NonUserContactViewController alloc] init];
        nonUserViewController.buddy = buddy;
        [self.parent.navigationController pushViewController:nonUserViewController animated:YES];
        [nonUserViewController release];
    }
}

- (void)pushInDetailViewWithGroup:(UserGroup *)group
{
    GroupContactViewController *groupViewController = [[GroupContactViewController alloc] init];
    groupViewController.groupid = group.groupID;
    groupViewController.isStanger = NO;
    [self.parent.navigationController pushViewController:groupViewController animated:YES];
    [groupViewController release];
}

- (void)popListView:(PopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    
}

- (void)popListViewDidCancel
{
    
}



- (void)didResetUnreadRequest
{
    [self.contactTableView reloadData];
}

#pragma mark UISearchDisplayDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self filterContentForSearchText:searchBar.text];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
[self filterContentForSearchText:searchString];
    return YES;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor colorWithHexString:SETTING_BACKGROUND_COLOR]];
    [self.searchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.searchDisplayController.searchBar setTintColor:[UIColor blackColor]];
    
    for (UIView *subView in self.searchDisplayController.searchBar.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            button.titleLabel.textColor = [UIColor redColor];
        }
    }
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.filteredArray removeAllObjects];
    [self.contactTableView reloadData];
}

- (void)filterContentForSearchText:(NSString *)searchText
{
    if (self.filteredArray == nil) {
        self.filteredArray = [[[NSMutableArray alloc] init] autorelease];
    } else {
        [self.filteredArray removeAllObjects];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF contains[cd] %@)", searchText];
    if (indexOffset == 3) {
        if (hasFamilyAccount) {
            for (Buddy *buddy in self.familyAccounts) {
                if ([predicate evaluateWithObject:buddy.nickName] || [predicate evaluateWithObject:buddy.wowtalkID]) {
                    [self.filteredArray addObject:buddy];
                }
            }
        } else if (hasChatGroup) {
            for (UserGroup *group in self.chatGroups) {
                if ([predicate evaluateWithObject:group.groupNameLocal] || [predicate evaluateWithObject:group.shortid]) {
                    [self.filteredArray addObject:group];
                }
            }
        }
    } else if (indexOffset == 4) {
        for (Buddy *buddy in self.familyAccounts) {
            if ([predicate evaluateWithObject:buddy.nickName] || [predicate evaluateWithObject:buddy.wowtalkID]) {
                [self.filteredArray addObject:buddy];
            }
        }
        
        for (UserGroup *group in self.chatGroups) {
            if ([predicate evaluateWithObject:group.groupNameLocal] || [predicate evaluateWithObject:group.shortid]) {
                [self.filteredArray addObject:group];
            }
        }
        
        
    }
    for (NSInteger i = indexOffset; i < [self.indexForNotEmptySection count]; i++) {
        NSArray *temp = [self.accountSectionArray objectAtIndex:[self realSectionForTableSection:i]];
        for (Buddy *buddy in temp) {
            if ([predicate evaluateWithObject:buddy.nickName] || [predicate evaluateWithObject:buddy.wowtalkID]) {
                [self.filteredArray addObject:buddy];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_contactTableView release];
    [_accountSectionArray release];
    [_familyAccounts release];
    [_indexForNotEmptySection release];
    [_chatGroups release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setContactTableView:nil];
    [self setAccountSectionArray:nil];
    [self setFamilyAccounts:nil];
    [self setIndexForNotEmptySection:nil];
    [self setChatGroups:nil];
    [super viewDidUnload];
}
@end
