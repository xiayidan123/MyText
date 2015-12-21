//
//  OMPulldownMenuView.h
//  OMPulldownView
//
//  Created by Starmoon on 15/7/15.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMPulldownMenuView;

@protocol OMPulldownMenuViewDelegate <NSObject>

- (void)menuView:(OMPulldownMenuView *)menuView didSeletedItemtIndexPath:(NSIndexPath *)indexPath;

@end


@interface OMPulldownMenuView : UIView

@property (assign, nonatomic) id <OMPulldownMenuViewDelegate> delegate;

@property (strong, nonatomic) NSMutableArray * items;

@property (assign, nonatomic) CGFloat unfold_height;

@property (assign, nonatomic) CGFloat item_height;


@end
