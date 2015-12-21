//
//  TeacherListViewController.h
//  dev01
//
//  Created by Huan on 15/4/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class SchoolMember;
@class OMClass;
@protocol TeacherListViewController <NSObject>

- (void)getTeacherList:(SchoolMember *)teacherModel;

@end

@interface TeacherListViewController : OMViewController
@property (assign, nonatomic) id<TeacherListViewController>delegate;
@property (retain, nonatomic) OMClass *OMClass;
@end
