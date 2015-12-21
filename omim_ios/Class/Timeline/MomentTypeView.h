//
//  MomentTypeView.h
//  wowtalkbiz
//
//  Created by elvis on 2013/09/25.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MomentTypeViewDelegate <NSObject>

@optional
-(void)didSelectMomentType:(int)type;

@end

@interface MomentTypeView : UIView<UITableViewDelegate,UITableViewDataSource>


@property (assign) id<MomentTypeViewDelegate> delegate;


@end
