//
//  AddContactViewController.m
//  omim
//
//  Created by Harry on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "AddContactViewController.h"
#import "SocialCell.h"
#import "SearchContactViewController.h"
#import "CustomNavButton.h"
#import "Constants.h"
#import "WTHeader.h"
#import "QRDetectionViewController.h"
#import "PublicFunctions.h"

#import "AddressBookViewController.h"
#import "CreateGroupViewController.h"
#import "QRScanViewController.h"
#import "LocalPeopleListViewController.h"
#import "SearchOfficialAccountViewController.h"
#import <MessageUI/MessageUI.h>

#import <ZXingWidgetController.h>
#import <QRCodeReader.h>

#import "SearchContactVC.h"

#import "LoginFromQRViewController.h"

#import "OMQRCodeScanViewController.h"

@interface AddContactViewController () <ZXingDelegate, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

- (void)initTableView;

@end

@implementation AddContactViewController

@synthesize tableView = _tableView;
@synthesize enableGroupCreation = _enableGroupCreation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text =  NSLocalizedString(@"Add contacts",nil);
    label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;


    [self initTableView];

//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     [_tableView setSeparatorInset:(UIEdgeInsetsMake(0, 50, 0, 0))];
    self.tableView.backgroundColor = [UIColor colorWithHexString:SETTING_BACKGROUND_COLOR];
    self.tableView.backgroundView = nil;
    
    self.tableView.scrollEnabled = FALSE;
    
    UIBarButtonItem *cancelBarButton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(fBack)];
    [self.navigationItem addLeftBarButtonItem:cancelBarButton];
    [cancelBarButton release];
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 15.0f)];

    }
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    [_tableView release];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)fBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 
#pragma mark Table 

//设置分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.enableGroupCreation) {
        return 4;
    }
    return 1;
}

//设置cell总数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.enableGroupCreation) {
        if (section == 0) {
            return 2;
        } else if (section == 1) {
            return 1;
        } else if (section == 2) {
            return 1;
        } else if (section == 3) {
            return 1;
        }
    } else {
        if (section == 0) {
            return 2;
        } else {
            return 1;
        }
    }
    return 0;
}


//设置某个cell对象
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellId = @"AddFriendObjectCell";
    SocialCell *socialCell = (SocialCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
    if (!socialCell) {
        socialCell = [[[SocialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId] autorelease];
    }

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (self.enableGroupCreation) {
        
        if (section == 0) {
            if (row == 0) {
                [socialCell.iconImageView setImage:[UIImage imageNamed: @"addcontacts_icon_search"]];
                [socialCell.titleLabel setText:NSLocalizedString(@"Search",nil)];
            }
            else if (row ==1) {
                [socialCell.iconImageView setImage:[UIImage imageNamed:@"addcontacts_icon_scan"]];
                [socialCell.titleLabel setText:NSLocalizedString(@"Scan QRCode", nil)];
            }
            else if (row == 2) {
                [socialCell.iconImageView setImage:[UIImage imageNamed:@"addcontacts_icon_nearby"]];
                [socialCell.titleLabel setText:NSLocalizedString(@"Nearby user", nil)];
            }
        } else if (section == 1) {
            [socialCell.iconImageView setImage:[UIImage imageNamed: @"addcontacts_icon_group"]];
            [socialCell.titleLabel setText:NSLocalizedString(@"Create a group",nil)];
        } else if (section == 2) {
            [socialCell.iconImageView setImage:[UIImage imageNamed: @"addcontacts_icon_account"]];
            [socialCell.titleLabel setText:NSLocalizedString(@"Offical account",nil)];
        } else if (section == 3) {
            [socialCell.iconImageView setImage:[UIImage imageNamed:@"addcontacts_icon_tellfriend"]];
            [socialCell.titleLabel setText:NSLocalizedString(@"Tell friend", nil)];
        }
        
    }
    else{
         
        if (section == 0) {
            if (row == 0) {
                [socialCell.iconImageView setImage:[UIImage imageNamed: @"table_search.png"]];
                [socialCell.titleLabel setText:NSLocalizedString(@"Search",nil)];
            }
            else if (row ==1) {
                [socialCell.iconImageView setImage:[UIImage imageNamed:@"table_qrcode.png"]];
                [socialCell.titleLabel setText:NSLocalizedString(@"Scan QRCode", nil)];
            }
            else if (row == 2){
                [socialCell.iconImageView setImage:[UIImage imageNamed: @"table_from_contact.png"]];
                [socialCell.titleLabel setText:NSLocalizedString(@"Local contact",nil)];
            }
        }
        else if (section == 1){
            [socialCell.iconImageView setImage:[UIImage imageNamed: @"table_official.png"]];
            [socialCell.titleLabel setText:NSLocalizedString(@"Offical account",nil)];
        }
    }
    
    return socialCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            
//            _searchContactViewController = [[SearchContactViewController alloc] init];
//            [self.navigationController pushViewController:_searchContactViewController animated:YES];
//            [_searchContactViewController release];
            
            SearchContactVC *searchContactVC = [[SearchContactVC alloc]init];
            [self.navigationController pushViewController:searchContactVC animated:YES];
            [searchContactVC release];
        }
        else if (row == 1) {
            OMQRCodeScanViewController *qrcodeScanVC = [[OMQRCodeScanViewController alloc]initWithNibName:@"OMQRCodeScanViewController" bundle:nil];
            [self.navigationController pushViewController:qrcodeScanVC animated:YES];
            [qrcodeScanVC release];
            
//            QRDetectionViewController *zxingViewController = [[QRDetectionViewController alloc] initWithDelegate:self showCancel:YES OneDMode:YES showLicense:YES];
//            NSMutableSet *readers = [[NSMutableSet alloc] init];
//            QRCodeReader *reader = [[QRCodeReader alloc] init];
//            [readers addObject:reader];
//            [reader release];
//            zxingViewController.readers = readers;
//            [readers release];
//            [self.navigationController pushViewController:zxingViewController animated:YES];
//            [zxingViewController release];

        }
        else if (row ==2) {
            LocalPeopleListViewController *localViewController = [[LocalPeopleListViewController alloc] init];
            [self.navigationController pushViewController:localViewController animated:YES];
            [localViewController release];
        }
        
    }
    else if (section == 1) {
        if (self.enableGroupCreation) {
            CreateGroupViewController* cgvc = [[CreateGroupViewController alloc] init];
            [self.navigationController pushViewController:cgvc animated:YES];
            [cgvc release];
            
        }
        else{
            _searchContactViewController = [[SearchContactViewController alloc] init];
            _searchContactViewController.searchOfficialAccountMode = TRUE;
            [self.navigationController pushViewController:_searchContactViewController animated:YES];
            [_searchContactViewController release];
        }
    }
    else if (section == 2){
        SearchOfficialAccountViewController *searchVC = [[SearchOfficialAccountViewController alloc] init];
        [self.navigationController pushViewController:searchVC animated:YES];
        [searchVC release];
    }
    else if (section == 3) {
        [self tellFriends];
    }
    
    
}

-(void)tellFriends
{
    UIActionSheet* actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"close", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Send email", nil), NSLocalizedString(@"SMS", nil),nil];
    
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [actionsheet showInView:self.view];
    
    [actionsheet release];
    
}

-(void)sendmail
{
    NSString* strInviteMsg = NSLocalizedString(@"I am living in WowTalk. It is great, join me now!", nil);
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:NSLocalizedString(@"Join WowTalk with me", nil)];
        [controller setMessageBody:strInviteMsg isHTML:NO];
//        [self presentModalViewController:controller animated:YES];
        [self presentViewController:controller animated:YES completion:nil];
        [controller release];
        
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:"]];
    }
}

-(void)sendsms
{
    //Tell friends
    
    NSString* strInviteMsg = NSLocalizedString(@"I am living in WowTalk. It is great, join me now!", nil);
    
    NSString *reqSysVer = @"4.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
		// A system version of 4.0 or greater is required
        if([MFMessageComposeViewController canSendText])
        {
            MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
            controller.body = strInviteMsg;
            controller.messageComposeDelegate = self;
//            [self presentModalViewController:controller animated:YES];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
    else {
        [UIPasteboard generalPasteboard].string = strInviteMsg;
        
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"sms:?"]];
        
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self becomeFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result
{
    NSLog(@"扫描结果  %@", result);
}

- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller
{
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self sendmail];
    } else if (buttonIndex == 1) {
        [self sendsms];
    }
}


@end





