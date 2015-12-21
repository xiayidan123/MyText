//
//  SendToInSchoolCell.h
//  dev01
//
//  Created by Huan on 15/3/30.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnlineHomeworkVC.h"
@class Buddy;

@protocol SendToInSchoolDelegate <NSObject>

- (void)getBuddyFromCell:(Buddy *)buddy;

@end



@interface SendToInSchoolCell : UICollectionViewCell
@property (assign, nonatomic) id<SendToInSchoolDelegate> sendDelegate;
@property (retain, nonatomic) SchoolViewController *schoolVC;
@property (retain, nonatomic) NSMutableArray *dataArray;
@end
