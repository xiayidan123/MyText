//
//  OMAddContactViewController.m
//  dev01
//
//  Created by Starmoon on 15/7/22.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMAddContactViewController.h"

//#import "SearchContactVC.h"
//#import "QRDetectionViewController.h"
//#import "QRScanViewController.h"
//#import "LocalPeopleListViewController.h"
//#import "CreateGroupViewController.h"
//#import "SearchOfficialAccountViewController.h"
//#import <MessageUI/MessageUI.h>
//#import <ZXingWidgetController.h>
//#import <QRCodeReader.h>

#import "OMSearchContactViewController.h"
#import "OMQRCodeScanViewController.h"

@interface OMAddContactViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>


@property (retain, nonatomic) IBOutlet UITableView *items_tableView;

@property (retain, nonatomic) NSArray * items;

@end

@implementation OMAddContactViewController

- (void)dealloc {
    self.items = nil;
    [_items_tableView release];
    [super dealloc];
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Add contacts",nil);
    self.items_tableView.tableFooterView = [[[UIView alloc]init] autorelease];
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
    
}

-(void)sendsms
{
    
}


#pragma mark- UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *item_dic = self.items[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:item_dic[@"Image_name"]];
    cell.textLabel.text = NSLocalizedString(item_dic[@"Title"],nil);
    return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.items.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.items[section] count];
}




#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            OMSearchContactViewController *searchContactVC = [[OMSearchContactViewController alloc]initWithNibName:@"OMSearchContactViewController" bundle:nil];
            [self.navigationController pushViewController:searchContactVC animated:YES];
            [searchContactVC release];
        }
        else if (row == 1) {
            OMQRCodeScanViewController *qrcodeScanVC = [[OMQRCodeScanViewController alloc]initWithNibName:@"OMQRCodeScanViewController" bundle:nil];
            [self.navigationController pushViewController:qrcodeScanVC animated:YES];
            [qrcodeScanVC release];
        }
        else if (row ==2) {
           
        }
        
    }
    else if (section == 1) {
        
    }
    else if (section == 2){
        
    }
    else if (section == 3) {
        [self tellFriends];
    }
    
}

#pragma mrak - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self sendmail];
    } else if (buttonIndex == 1) {
        [self sendsms];
    }
}

#pragma mark - Set and Get

-(NSArray *)items{
    if (_items == nil){
        _items = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OMAddContactItems" ofType:@"plist"]] retain];
    }
    return _items;
}



@end