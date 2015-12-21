//
//  TableFooterCell.h
//  dev01
//
//  Created by 杨彬 on 14-11-28.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FooterCellStatePullBegin,
    FooterCellStateLoading,
    FooterCellRelease
}FooterCellState;

@interface TableFooterCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicator_show;
@property (retain, nonatomic) IBOutlet UILabel *lab_prompt;

- (void)updateState:(FooterCellState)state;

@end
