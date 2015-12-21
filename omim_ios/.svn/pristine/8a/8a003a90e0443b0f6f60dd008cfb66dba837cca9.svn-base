//
//  MyClassFunctionCell.h
//  dev01
//
//  Created by 杨彬 on 15/3/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyClassFunctionCell;

@protocol MyClassFunctionCellDelegate <NSObject>

- (void)clickMemberListButtonWithMyClassFunctionCell:(MyClassFunctionCell *)myClassFunctionCell;

- (void)clickClassNotificationButtonWithMyClassFunctionCell:(MyClassFunctionCell *)myClassFunctionCell;

- (void)clickLeaveApplyButtonWithMyClassFunctionCell:(MyClassFunctionCell *)myClassFunctionCell;

- (void)clickMakeUpLessonsButtonWithMyClassFunctionCell:(MyClassFunctionCell *)myClassFunctionCell;

- (void)clickTakePhotoForQuestionsButtonWithMyClassFunctionCell:(MyClassFunctionCell *)myClassFunctionCell;

- (void)clickHomeWorkOnLineButtonWithMyClassFunctionCell:(MyClassFunctionCell *)myClassFunctionCell;

- (void)clickclassCircleActionButtonWithMyClassFunctionCell:(MyClassFunctionCell *)myClassFunctionCell;

@end


@interface MyClassFunctionCell : UITableViewCell

@property (nonatomic, assign)id<MyClassFunctionCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
