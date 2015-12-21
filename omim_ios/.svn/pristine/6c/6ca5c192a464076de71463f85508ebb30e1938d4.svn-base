//
//  TableViewHeaderView.m
//  dev01
//
//  Created by Huan on 15/5/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "TableViewHeaderView.h"
#import "OMClass.h"
#import "Lesson.h"
@interface TableViewHeaderView()
@property (retain, nonatomic) IBOutlet UILabel *class_label;
@property (retain, nonatomic) IBOutlet UILabel *lesson_label;

@end


@implementation TableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
}

- (void)setClassModel:(OMClass *)classModel{
    _classModel = classModel;
    self.class_label.text = _classModel.groupNameOriginal;
    
}

- (void)setLessonModel:(Lesson *)lessonModel{
    _lessonModel = lessonModel;
    self.lesson_label.text = _lessonModel.title;
}

- (void)dealloc {
    [_class_label release];
    [_lesson_label release];
    [super dealloc];
}


@end
