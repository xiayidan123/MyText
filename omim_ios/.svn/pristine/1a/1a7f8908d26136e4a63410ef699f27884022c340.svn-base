//
//  TempChatRoomInfoViewController.h
//  omim
//
//  Created by elvis on 2013/05/23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewDelegate.h"
#import "MemberGridView.h"
#import "ContactPickerViewController.h"

@class GroupChatRoom;

@interface TempChatRoomInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MemberGridViewDelegate,UIActionSheetDelegate,ContactPickerViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView * mytableView;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic,retain)  GroupChatRoom* group;

@property BOOL inDeleteMode;

@end
