//
//  AddShoolViewController.h
//  dev01
//
//  Created by macbook air on 14-9-25.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "OMViewController.h"

@protocol AddCourseControllerDelegate <NSObject>
- (void)refreshSchoolTree;
@end



@interface AddCourseController : OMViewController


@property (nonatomic,assign) id <AddCourseControllerDelegate>delegate;

@property (retain, nonatomic) IBOutlet UIView *inputView;

@property (retain, nonatomic) IBOutlet UITextField *tfCode;

@property (retain, nonatomic) IBOutlet UIButton *btnAdd;

@property (nonatomic,assign) BOOL isInvitationCodeInHomeVC;


- (IBAction)addClick:(id)sender;

@end
