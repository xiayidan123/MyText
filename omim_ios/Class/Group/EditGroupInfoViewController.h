//
//  EditGroupInfoViewController.h
//  omim
//
//  Created by coca on 2013/04/30.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberGridView.h"
#import "ChoosePlaceViewController.h"
@class UserGroup;
@protocol ChangeInfoDelegate;
@protocol ContactPickerViewControllerDelegate;
@protocol ViewDetailedLocationVCDelegate;
@protocol ChangeGroupNameDelegate;

@interface EditGroupInfoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MemberGridViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,ChoosePlaceDelegate>

@property (nonatomic,retain) IBOutlet UITableView* tb_group;

@property BOOL inDeleteMode;
@property BOOL isStanger;

@property BOOL isCreator;
@property BOOL isManager;
@property BOOL isNormalMember;

@property (nonatomic,retain)  UserGroup* group;   // have to extend this group



@end
