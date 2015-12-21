//
//  TableFooterCell.m
//  dev01
//
//  Created by 杨彬 on 14-11-28.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "TableFooterCell.h"

@implementation TableFooterCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle  =UITableViewCellSelectionStyleNone;
}


- (void)dealloc {
    [_ActivityIndicator_show release];
    [_lab_prompt release];
    [super dealloc];
}

-(void)updateState:(FooterCellState)state{
    if (state == FooterCellStatePullBegin) {
        _lab_prompt.text = NSLocalizedString(@"footer pull up to load", nil);
        _lab_prompt.textAlignment = NSTextAlignmentCenter;
        _lab_prompt.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        _ActivityIndicator_show.hidden = YES;
    } else if (state == FooterCellStateLoading) {
        _lab_prompt.text = NSLocalizedString(@"footer loading", nil);
        _ActivityIndicator_show.hidden = NO;
        [_ActivityIndicator_show startAnimating];
    }else if (state == FooterCellRelease){
        _lab_prompt.text = NSLocalizedString(@"释放刷新", nil);//release to load
        _lab_prompt.textAlignment = NSTextAlignmentCenter;
        _lab_prompt.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        _ActivityIndicator_show.hidden = YES;
    }
}
@end
