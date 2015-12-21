//
//  SocialCell.m
//  omim
//
//  Created by Harry on 14-2-2.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "SocialCell.h"

#import <QuartzCore/QuartzCore.h>

@implementation SocialCell

@synthesize iconImageView = _iconImageView;
@synthesize titleLabel = _titleLabel;

- (void)dealloc
{
    [_iconImageView release];
    [_titleLabel release];
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *v = [self getCellView];
        [self.contentView addSubview:v];
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    return self;
}

- (UIView *)getCellView
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 320.0f, 44.0f);
    
    UIView *SocialCellView = [[[UIView alloc] initWithFrame:rect] autorelease];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 7.0f, 30.0f, 30.0f)];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 7.0f, 200.0f, 30.0f)];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = @"";
    
    [SocialCellView addSubview:_iconImageView];
    [SocialCellView addSubview:_titleLabel];
    
    
    self.iconnotice = [[[UIImageView alloc] initWithFrame:CGRectMake(250, 13, 20,18 )] autorelease];
    [self.iconnotice setImage:[UIImage imageNamed:@"unread_count_bg.png"]];
    [SocialCellView addSubview:self.iconnotice];
    
    self.lbl_count = [[[UILabel alloc] initWithFrame:CGRectMake( self.iconnotice.frame.origin.x, self.iconnotice.frame.origin.y, self.iconnotice.frame.size.width, self.iconnotice.frame.size.height)] autorelease];
    self.lbl_count.backgroundColor = [UIColor clearColor];
    self.lbl_count.textAlignment = NSTextAlignmentCenter;
    self.lbl_count.adjustsFontSizeToFitWidth = TRUE;
    
    //修改人：李国权  ||  修改时间：2015年12月16日  ||  说明：设置label的自小字体，minimumFontSize已弃用
    //修改前代码开始
//    self.lbl_count.minimumFontSize = 7;
    //修改前代码结束
    
    //修改后代码开始
    self.lbl_count.minimumScaleFactor = 7;
    //修改后代码结束
    
    self.lbl_count.textColor = [UIColor whiteColor];
    
    [SocialCellView addSubview:self.lbl_count];
    [self.iconnotice setHidden:TRUE];
    [self.lbl_count setHidden:TRUE];
    
    return SocialCellView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
