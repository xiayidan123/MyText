//
//  UIGridView.h
//  foodling2
//
//  Created by Tanin Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIGridViewDelegate;
@class UIGridViewCell;

@interface UIGridView : UITableView<UITableViewDelegate, UITableViewDataSource> {
	UIGridViewCell *tempCell;
    
    UIView* footerview;
   
    
    int offset;
    
   
}
@property BOOL isLoadingMore;
@property BOOL hasFootview;
@property (nonatomic,assign) UIActivityIndicatorView* indicator;
@property (nonatomic,assign) UILabel* lbl_loading;

@property (nonatomic, retain) IBOutlet id<UIGridViewDelegate> uiGridViewDelegate;

- (void) setUp;
- (UIGridViewCell *) dequeueReusableCell;

- (IBAction) cellPressed:(id) sender;


-(void)stopLoading;

@end
