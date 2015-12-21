//
//  ShowHomeworkView.h
//  dev01
//
//  Created by Huan on 15/5/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewhomeWorkModel;
@class ShowHomeworkView;

@protocol ShowHomeworkViewDelegate <NSObject>

- (void)didClickEditButtonWithShowHomeworkView:(ShowHomeworkView *)showHomeworkView;

@end


@interface ShowHomeworkView : UIView

@property (assign, nonatomic) id<ShowHomeworkViewDelegate> delegate;

@property (retain, nonatomic) NewhomeWorkModel * homeworkModel;


@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;
@end
