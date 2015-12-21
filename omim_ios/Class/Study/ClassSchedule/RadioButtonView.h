//
//  RadioButtonView.h
//  dev01
//
//  Created by 杨彬 on 14-12-30.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadioButtonViewDelegate <NSObject>

- (void)didSeletedWithIndex:(NSInteger) selectIndex;

@end



@interface RadioButtonView : UIView

@property (nonatomic,assign)id<RadioButtonViewDelegate>delegate;

@property (nonatomic,assign)NSInteger numberOfSelectPart;
@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,assign) BOOL enabledSelect;



@end
