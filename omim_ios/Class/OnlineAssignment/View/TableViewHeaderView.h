//
//  TableViewHeaderView.h
//  dev01
//
//  Created by Huan on 15/5/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMClass;
@class Lesson;
@interface TableViewHeaderView : UIView
@property (retain, nonatomic) OMClass * classModel;
@property (retain, nonatomic) Lesson * lessonModel;
@end
