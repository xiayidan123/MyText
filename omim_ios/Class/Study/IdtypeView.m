//
//  IdtypeView.m
//  dev01
//
//  Created by macbook air on 14-9-25.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "IdtypeView.h"

@implementation IdtypeView




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _teacherView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
        _teacherView.image =  [UIImage imageNamed:@"register_unchecked.png"];
        _studentView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 0, 22, 22)];
        _studentView.image = [UIImage imageNamed:@"register_checked.png"];
        
        _lalStudent = [[UILabel alloc]initWithFrame:CGRectMake(124, 0, 76, 22)];
        _lalStudent.text = NSLocalizedString(@"Student",nil);
        _lalStudent.font = [UIFont systemFontOfSize:17];
        _lalTeacher = [[UILabel alloc]initWithFrame:CGRectMake(34, 0, 76, 22)];
        _lalTeacher.text = NSLocalizedString(@"Teacher",nil);
        _lalTeacher.font = [UIFont systemFontOfSize:17];
        
        _teacherView.userInteractionEnabled = YES;
        _studentView.userInteractionEnabled = YES;
        _lalStudent.userInteractionEnabled = YES;
        _lalTeacher.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        
        
        [self addSubview:_teacherView];
        [self addSubview:_studentView];
        [self addSubview:_lalTeacher];
        [self addSubview:_lalStudent];
        [_teacherView release];
        [_studentView release];
        [_lalStudent release];
        [_lalTeacher release];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}
@end
