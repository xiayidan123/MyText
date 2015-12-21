//
//  CoverView.h
//  omim
//
//  Created by elvis on 2013/05/19.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
    CoverViewPulling = 0,
    CoverViewNormal,
    CoverViewLoading
}CoverViewState;

@protocol CoverViewDelegate;
@class RotateIcon;
@interface CoverView : UIView{
    id _delegate;
//    CoverViewState _state;
    BOOL draggingEnded;
 
}
@property (nonatomic,assign) CoverViewState state;
@property BOOL autoScroll;
@property (nonatomic,retain)RotateIcon* rotateicon;
@property CGPoint initialContentOffset;
@property CGPoint refreshContentOffset;

@property (nonatomic,retain)  UIImageView* coverImage;
@property(nonatomic,assign) id <CoverViewDelegate> delegate;


- (void)coverViewDidScroll:(UIScrollView *)scrollView;
- (void)coverViewDidEndDragging:(UIScrollView *)scrollView;
- (void)coverViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
@end


@protocol CoverViewDelegate
- (void)coverViewDidTriggerRefresh:(CoverView*)view;
- (BOOL)coverViewDataSourceIsLoading:(CoverView*)view;

@optional
- (NSDate*)coverViewDataSourceLastUpdated:(CoverView*)view;

@end
