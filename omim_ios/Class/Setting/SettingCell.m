//
//  SettingCell.m
//  omim
//
//  Created by Harry on 14-2-2.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "SettingCell.h"

#import <QuartzCore/QuartzCore.h>

#import "WTHeader.h"

#import "Constants.h"


@implementation SettingCell

@synthesize titleLabel = _titleLabel;
@synthesize subTitleLabel = _subTitleLabel;
@synthesize iconImageView = _iconImageView;
@synthesize iconIndicator = _iconIndicator;
- (void)dealloc
{
    [_iconImageView release],_iconImageView = nil;
    [_subTitleLabel release],_subTitleLabel = nil;
    [_titleLabel release],_titleLabel = nil;
    [_iconIndicator release],_iconIndicator = nil;
    [_headImageView release],_headImageView = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIView *cellview = [self getCellView];
        [self.contentView addSubview:cellview];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (UIView *)getCellView
{
    CGRect rect = CGRectMake(SCREEN_X_ORIGIN, SCREEN_Y_ORIGIN, SCREEN_BOUNDS_WIDTH, SETTING_TABLEVIEWCELL_WIDTH);
    UIView *bgView = [[[UIView alloc] initWithFrame:rect] autorelease];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SETTING_TABLEVIEWCELL_TITLELABEL_X_ORIGIN, SETTING_TABLEVIEWCELL_TITLELABEL_Y_ORIGIN, SETTING_TABLEVIEWCELL_TITLELABEL_WIDTH, SETTING_TABLEVIEWCELL_TITLELABEL_HEIGHT)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17.0];

    _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SETTING_TABLEVIEWCELL_IMAGEVIEW_X_ORIGIN,SETTING_TABLEVIEWCELL_IMAGEVIEW_Y_ORIGIN, SETTING_TABLEVIEWCELL_IMAGEVIEW_WIDTH, SETTING_TABLEVIEWCELL_IMAGEVIEW_HEIGHT)];
    _iconImageView.layer.cornerRadius = _iconImageView.frame.size.height/2;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.backgroundColor = [UIColor clearColor];
    
    _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SETTING_TABLEVIEWCELL_SUBTITLELABEL_X_ORIGIN, SETTING_TABLEVIEWCELL_SUBTITLELABEL_Y_ORIGIN, SETTING_TABLEVIEWCELL_SUBTITLELABEL_WIDTH, SETTING_TABLEVIEWCELL_SUBTITLELABEL_HEIGHT)];
    _subTitleLabel.adjustsFontSizeToFitWidth = NO;
    _subTitleLabel.backgroundColor = [UIColor clearColor];
    _subTitleLabel.textColor = [UIColor colorWithHexString:SETTING_ORANGE_TEXT_COLOR];
    _subTitleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    _subTitleLabel.textAlignment = NSTextAlignmentRight;
    
    
    _iconIndicator= [[UIImageView alloc]
                                         initWithFrame:CGRectMake(320-TABLE_ROW_INIT_OFFSET-8-5,
                                                                  20, 8, 8)];
    _iconIndicator.hidden = YES;
    
    
    _headImageView = [[OMHeadImgeView alloc] initWithFrame:CGRectMake(SETTING_TABLEVIEWCELL_IMAGEVIEW_X_ORIGIN,SETTING_TABLEVIEWCELL_IMAGEVIEW_Y_ORIGIN, SETTING_TABLEVIEWCELL_IMAGEVIEW_WIDTH, SETTING_TABLEVIEWCELL_IMAGEVIEW_HEIGHT)];
    
    
    [bgView addSubview:_iconImageView];
    [bgView addSubview:_subTitleLabel];
    [bgView addSubview:_titleLabel];
    [bgView addSubview:_iconIndicator];
    [bgView addSubview:_headImageView];

    return bgView;
}


@end
