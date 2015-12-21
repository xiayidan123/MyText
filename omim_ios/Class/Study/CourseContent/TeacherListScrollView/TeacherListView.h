//
//  TeacherListScrollView.h
//  dev01
//
//  Created by 杨彬 on 14-12-27.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadImageView.h"



@protocol TeacherListViewDelegate <NSObject>

- (void)enterTeacherDetailVC:(PersonModel *)teacherModel;

@end



@interface TeacherListView : UIView<HeadImageViewDelegate>


@property (retain,nonatomic)NSMutableArray *teacherArray;
@property (assign,nonatomic)id <TeacherListViewDelegate>delegate;


@end
