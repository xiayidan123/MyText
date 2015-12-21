//
//  MomentLocationView.h
//  dev01
//
//  Created by 杨彬 on 15/4/14.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MomentLocationCellModel;
@class MomentLocationView;

@protocol MomentLocationViewDelegate <NSObject>

@optional

- (void)MomentLocationView:(MomentLocationView *)locationView momentLocationCellModel:(MomentLocationCellModel *)locationModel;

@end


@interface MomentLocationView : UIView

@property (assign, nonatomic)id<MomentLocationViewDelegate>delegate;

@property (retain, nonatomic)MomentLocationCellModel *locationCellModel;

@end
