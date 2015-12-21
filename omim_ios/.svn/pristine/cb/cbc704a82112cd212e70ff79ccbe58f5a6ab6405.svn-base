//
//  GroupInfoViewController.h
//  omim
//
//  Created by Harry on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewDelegate.h"
#import "MemberGridView.h"
#import "ContactPickerViewController.h"
@class UserGroup;
@class GroupChatRoom;
@protocol ContactPickerViewControllerDelegate;

@interface GroupInfoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MemberGridViewDelegate,UIActionSheetDelegate,ContactPickerViewControllerDelegate,UIAlertViewDelegate>


@property (nonatomic, retain) IBOutlet UITableView * mytableView;


@property (nonatomic, copy) NSString *groupid;


@property (nonatomic,retain)  UserGroup* group;   // have to extend this group


//@property BOOL refreshTable;

@property BOOL isStanger;

@property BOOL isCreator;
@property BOOL isManager;
@property BOOL isNormalMember;

@property BOOL inDeleteMode;


@end
