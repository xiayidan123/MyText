//
//  TableFooterView.h
//  dev01
//
//  Created by jianxd on 13-7-9.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FooterViewStatePullBegin,
    FooterViewStateLoading
}FooterViewState;

@interface TableFooterView : UIView

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel;

- (void)updateState:(FooterViewState)state;

@end
