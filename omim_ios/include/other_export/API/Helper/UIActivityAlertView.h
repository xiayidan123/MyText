//
//  UIActivityAlertView.h
//  omim
//
//  Created by Coca on 6/15/11.
//  Copyright 2011 WOW Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIActivityAlertView : UIAlertView {
	
	UIActivityIndicatorView *activityView;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityView;

- (void) close;
	
@end
