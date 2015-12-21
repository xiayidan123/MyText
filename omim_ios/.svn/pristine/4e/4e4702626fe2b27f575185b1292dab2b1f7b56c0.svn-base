//
//  ContactInfoViewController.h
//  omim
//
//  Created by Harry on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Buddy.h"
#import "CustomIOS7AlertView.h"
#import "OMHeadImgeView.h"



typedef enum
{
    CONTACT_FRIEND = 0,
    CONTACT_GROUP,
    CONTACT_STRANGER,
    CONTACT_OFFICIAL_ACCOUNT,
    CONTACT_NOT_USER
} CONTACT_TYPE;

@interface ContactInfoViewController :  UIViewController
<UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
UIAlertViewDelegate,
CustomIOS7AlertViewDelegate,
UITextFieldDelegate>
{
    UITableView *_tableView;

}

@property (nonatomic, assign) CONTACT_TYPE contact_type;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) Buddy *buddy;
@property (nonatomic, retain) UIImageView *imageview;

@property (nonatomic, retain) OMHeadImgeView *headImageView;

@property (nonatomic,retain) IBOutlet UIButton* btn_makecall;
@property (nonatomic,retain) IBOutlet UIButton* btn_message;

- (IBAction)startChat:(id)sender;
-(IBAction)makeCall:(id)sender;

@end
