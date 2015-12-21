//
//  ContactPickerViewController.h
//  omim
//
//  Created by Harry on 14-2-20.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddContactViewController;
@class ContactInfoViewController;
@class Buddy;
@class ContactPickerViewController;
@protocol ContactPickerViewControllerDelegate <NSObject>

@optional
-(void)didChooseGroupMembers:(NSArray*)members withRequestor:(ContactPickerViewController*)requestor;

@end

@interface ContactPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>


@property (nonatomic,assign) id<ContactPickerViewControllerDelegate> delegate;

@property (nonatomic, retain) AddContactViewController *addContactViewController;
@property (nonatomic, retain) ContactInfoViewController *contactInfoViewController;

@property (nonatomic, retain) IBOutlet UITableView *selectContactTableView;

@property (nonatomic, assign) BOOL isAddGroupMembers;

@property (nonatomic, copy) NSString *groupID;

@property BOOL isChosenToStartAChat;
@property BOOL isManageGroupMember;
@property BOOL isAddMembersToStartAGroupChat;

@property (nonatomic,retain) NSMutableArray* exsitingBuddys;
@property (nonatomic,retain) NSMutableArray* selectedBuddys;
@property (nonatomic,retain) NSMutableArray* buddyButtons;

@property (nonatomic,retain) UIImageView* bottomBar;
@property (nonatomic,retain) UIScrollView* sv_container;
@property (nonatomic, retain) UIButton *confirmButton;



@end
