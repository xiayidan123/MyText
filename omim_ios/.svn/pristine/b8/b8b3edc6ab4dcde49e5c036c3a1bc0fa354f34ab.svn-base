//
//  EditClassInformationTableVC.h
//  dev01
//
//  Created by 杨彬 on 15/3/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMViewController.h"
@class OMClass;
@class EditClassInformationTableVC;

@protocol EditClassInformationTableVCDelegate <NSObject>

@optional
- (void)editClassInformationTableVC:(EditClassInformationTableVC *)editClassInformationTableVC didEditedWithClassModel:(OMClass *)classModel;


@end


@interface EditClassInformationTableVC : OMViewController


@property (assign, nonatomic) id <EditClassInformationTableVCDelegate>delegate;


@property (retain, nonatomic)OMClass *classModel;

@property (retain, nonatomic)NSMutableArray *lessonArray;

@end
