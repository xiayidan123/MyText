//
//  UserResultCell.m
//  dev01
//
//  Created by jianxd on 14-6-20.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "UserResultCell.h"
#import "PublicFunctions.h"


@interface UserResultCell ()

@end

@implementation UserResultCell

- (void)awakeFromNib
{
    // Initialization code
    [self setupView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    [self setupView];
    // Configure the view for the selected state
}

- (void)setupView
{
    _addButton.frame = CGRectMake(250, 10, 60, 40);
    _addButton.backgroundColor = [UIColor colorWithRed:0.51 green:0.68 blue:0.98 alpha:1];
    [_addButton setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
    _addButton.layer.cornerRadius = 3;
    _addButton.layer.masksToBounds = YES;

    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    

}

-(void)setStatus:(UserResultCellStatus)status{
    _status = status;
    if (status == NOTADD){
        [_addButton setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
        _addButton.backgroundColor = [UIColor colorWithRed:0.11 green:0.68 blue:0.98 alpha:1];
    }else if (status == ADDING){
        _addButton.enabled = NO;
        [_addButton setTitle:NSLocalizedString(@"Adding", nil) forState:UIControlStateNormal];
        _addButton.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1];
    }else {
        _addButton.enabled = NO;
        [_addButton setTitle:NSLocalizedString(@"Already Added", nil) forState:UIControlStateDisabled];
        _addButton.backgroundColor = [UIColor colorWithRed:0.56 green:0.84 blue:0.99 alpha:1];
    }
}

- (void)dealloc {
    [_nameLabel release],_nameLabel = nil;
    [_idLabel release],_idLabel = nil;
    [_addButton release],_addButton = nil;
    [_headImageView release],_headImageView = nil;
    [super dealloc];
}
@end
