//
//  OMPulldownView.h
//  OMPulldownView
//
//  Created by Starmoon on 15/7/14.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OMPulldownItem.h"

@class OMPulldownView;

/** 标签按钮高度 */
#define Pulldown_TitleButton_Height 44

@protocol OMPulldownViewDelegate <NSObject>
@optional
- (void)pulldown:(OMPulldownView *)pulldownView didSeletedItem:(OMPulldownItem *)item atIndexPath:(NSIndexPath *)indexPath;

@end


@interface OMPulldownView : UIView

@property (assign, nonatomic) id<OMPulldownViewDelegate> delegate;

/** 选项置顶 */
@property (assign, nonatomic) BOOL item_top;


@property (copy, nonatomic) NSString * plist_file_name;

- (void)fastPackupMenu;

@end
