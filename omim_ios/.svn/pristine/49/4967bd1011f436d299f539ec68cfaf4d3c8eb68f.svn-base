//
//  TableFooterView.m
//  dev01
//
//  Created by jianxd on 13-7-9.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "TableFooterView.h"

@implementation TableFooterView

@synthesize activityIndicator = _activityIndicator;
@synthesize infoLabel = _infoLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    [super awakeFromNib];
}

- (void)updateState:(FooterViewState)state
{
    if (state == FooterViewStatePullBegin) {
        NSString *labelText = NSLocalizedString(@"footer pull up to load", nil);
        CGSize labelSize = [labelText sizeWithFont:[UIFont boldSystemFontOfSize:15.0]
                                 constrainedToSize:CGSizeMake(320.0, 20.0)];
        _infoLabel.frame = CGRectMake((self.frame.size.width - labelSize.width) / 2, 15, labelSize.width, 20);
        _infoLabel.text = labelText;
        _activityIndicator.hidden = YES;
    } else if (state == FooterViewStateLoading) {
        NSString *labelText = NSLocalizedString(@"footer loading", nil);
        CGSize labelSize = [labelText sizeWithFont:[UIFont boldSystemFontOfSize:15.0]
                                 constrainedToSize:CGSizeMake(320.0, 20.0)];
        _infoLabel.frame = CGRectMake((self.frame.size.width - labelSize.width) / 2, 15, labelSize.width, 20.0);
        _infoLabel.text = labelText;
        _activityIndicator.frame = CGRectMake((self.frame.size.width - labelSize.width) / 2 - 30, 15, 20, 20);
        _activityIndicator.hidden = NO;
        [_activityIndicator startAnimating];
    }
}

- (void)dealloc {
    [_activityIndicator release];
    [_infoLabel release];
    [super dealloc];
}
@end
