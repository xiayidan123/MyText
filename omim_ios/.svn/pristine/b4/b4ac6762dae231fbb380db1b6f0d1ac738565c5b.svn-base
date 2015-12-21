    //
//  UIActivityAlertView.m
//  omim
//
//  Created by Coca on 6/15/11.
//  Copyright 2011 WOW Technology Co.,Ltd. All rights reserved.
//

#import "UIActivityAlertView.h"


@implementation UIActivityAlertView
@synthesize activityView;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 80, 30, 30)];
		[self addSubview:activityView];
		activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[activityView startAnimating];
        [activityView release];
    }
	
    return self;
}

- (void) close
{
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) dealoc
{
	[activityView release];
	[super dealloc];
}

@end
