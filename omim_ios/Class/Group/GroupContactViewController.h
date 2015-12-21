//
//  GroupContactViewController.h
//  omim
//
//  Created by coca on 2013/04/21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewDelegate.h"
#import "MemberGridView.h"
#import "ContactPickerViewController.h"
#import "CustomIOS7AlertView.h"

@class UserGroup;

@protocol ContactPickerViewControllerDelegate;

@interface GroupContactViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MemberGridViewDelegate,UIActionSheetDelegate,ContactPickerViewControllerDelegate,UIAlertViewDelegate,CustomIOS7AlertViewDelegate,UITextFieldDelegate>


@property BOOL NoNeedToInitGroup;
@property BOOL refreshTable;

@property BOOL isStanger;

@property BOOL isCreator;
@property BOOL isManager;
@property BOOL isNormalMember;

@property BOOL inDeleteMode;

@property (nonatomic,retain) IBOutlet UITableView* tb_detail;

@property (nonatomic,retain)  UserGroup* group;   // have to extend this group
@property (nonatomic,retain) NSString* groupid;

@end
