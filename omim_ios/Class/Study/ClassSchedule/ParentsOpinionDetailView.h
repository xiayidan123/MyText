//
//  ParentsOpinionDetailView.h
//  dev01
//
//  Created by 杨彬 on 15-1-1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"
@protocol ParentsOpinionDetailVCDelegate <NSObject>

- (void)enterParentsOpinionDetailVC:(int)SelectedIndex;

@end

@interface ParentsOpinionDetailView : UIView
@property (assign, nonatomic) id<ParentsOpinionDetailVCDelegate>delegate;
@property (retain,nonatomic)Moment *parentsOpinonModel;

@property (retain, nonatomic) IBOutlet UILabel *lab_title;

@property (retain, nonatomic) IBOutlet UIButton *btn_audio;

@property (retain, nonatomic) IBOutlet UIView *view_line1;
@property (retain, nonatomic) IBOutlet UIView *view_line2;

@end
