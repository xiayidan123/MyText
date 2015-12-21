//
//  CustomActionSheet.h
//  omim
//
//  Created by Harry on 14-1-31.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomActionSheet : UIActionSheet <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign) BOOL isGroupTypePicker;
@property (retain, nonatomic)NSString* chosenType;

@property (copy, nonatomic)   NSString *age;
@property (assign, nonatomic) BOOL isPicker;
@property (retain, nonatomic) NSString *selectedGender;
@property (copy, nonatomic)   NSArray *array;
@property (retain, nonatomic) UIPickerView *genderPicker;
@property (retain, nonatomic) UIDatePicker *datePicker;
@property (retain,nonatomic) UIPickerView* grouptypePicker;

@property (nonatomic,retain) NSString* initialDate;


- (id)initWithTitle:(NSString *)title isDatePicker:(BOOL)isDatePicker delegate:(id /*<UIActionSheetDelegate>*/)delegate;

-  (id)initGroupPickerWithInitialChoice:(NSString*)choice  delegate:(id)delegate;

- (void)showInView:(UIView *)view;

- (NSString *)age:(NSDate *)theDate;


@end
