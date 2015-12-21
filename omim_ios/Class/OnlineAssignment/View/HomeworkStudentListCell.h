//
//  HomeworkStudentListCell.h
//  dev01
//
//  Created by Huan on 15/5/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SchoolMember;

@protocol HomeworkStudentListCellDelegate <NSObject>

- (void)remindHomeworkWithSchoolMember:(SchoolMember *)schoolMember;

@end

@interface HomeworkStudentListCell : UITableViewCell
@property (retain, nonatomic) SchoolMember * schoolMember;
@property (assign, nonatomic) id<HomeworkStudentListCellDelegate> delegate;

@property (retain, nonatomic) IBOutlet UILabel *name_label;
@property (retain, nonatomic) IBOutlet UIButton *state_btn;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *widthLayout;

@end
