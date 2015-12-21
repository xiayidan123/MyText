//
//  AddBuddyFromSchoolVC.h
//  dev01
//
//  Created by 杨彬 on 14-12-17.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"
#import "OMHeadImgeView.h"

@class SchoolMember;


typedef NS_ENUM(NSInteger, AddBuddyFromSchoolVCColor) {
    RED_COLOR_IN_ADDBUDDYFROMSCHOOLVC,
    GREEN_COLOR_IN_ADDBUDDYFROMSCHOOLVC,
    BLUE_COLOR_IN_ADDBUDDYFROMSCHOOLVC,
};



@interface AddBuddyFromSchoolVC : UIViewController<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet OMHeadImgeView *imageView_headimage;

@property (retain, nonatomic) IBOutlet UILabel *lab_user_name;
@property (retain, nonatomic) IBOutlet UIButton *btn_addBuddy;
@property (retain, nonatomic) IBOutlet UIButton *btn_messege;
//@property (assign, nonatomic) BOOL isMyClassPush;
@property (retain, nonatomic) IBOutlet UILabel *lab_status;

@property (assign, nonatomic) AddBuddyFromSchoolVCColor color;

@property (retain,nonatomic)PersonModel *person;

@property (nonatomic,retain) Buddy* buddy;

- (IBAction)addBuddyAction:(id)sender;
- (IBAction)sendMessegeAction:(id)sender;
@end
