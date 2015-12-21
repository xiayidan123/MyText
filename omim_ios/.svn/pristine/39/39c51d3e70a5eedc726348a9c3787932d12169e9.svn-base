//
//  SearchCell.m
//  omim
//
//  Created by Li  Beck on 14-2-3.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "SearchCell.h"

#import <QuartzCore/QuartzCore.h>

#import "WTHeader.h"

#import "Constants.h"


@implementation SearchCell

@synthesize groupName;
@synthesize groupLabel ;
@synthesize groupNumber ;
@synthesize groupImageview;

-(void)dealloc
{
    [groupName release];
    [groupLabel release];
    [groupNumber release];
    [groupImageview release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIView *cellview = [self getSearchCellView];
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


- (UIView *)getSearchCellView
{
    CGRect rect = CGRectMake(0,0,320,60);
    UIView *searchCellView = [[[UIView alloc] initWithFrame:rect] autorelease];
    
    groupImageview = [[UIImageView alloc] initWithFrame:CGRectMake(5,5, 40, 40)];
    groupImageview.layer.cornerRadius = 8.0;
    groupImageview.layer.masksToBounds = YES;
    groupImageview.backgroundColor = [UIColor clearColor];
    
    groupName = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, 250, 17)];
    groupName.adjustsFontSizeToFitWidth = YES;
    groupName.lineBreakMode = NSLineBreakByTruncatingTail;
    groupName.backgroundColor = [UIColor clearColor];
    groupName.font = [UIFont boldSystemFontOfSize:14];
    groupName.textAlignment = NSTextAlignmentLeft;
    groupName.text = NSLocalizedString(@"Group name", nil);
    
    groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 31, 40, 12)];
    groupLabel.adjustsFontSizeToFitWidth = YES;
    groupLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    groupLabel.backgroundColor = [UIColor clearColor];
    //    groupLabel.textColor = [UIColor colorWithHexString:SETTING_ORANGE_TEXT_COLOR];
    groupLabel.font = [UIFont boldSystemFontOfSize:12];
    groupLabel.textAlignment = NSTextAlignmentRight;
    groupLabel.text = NSLocalizedString(@"Group ID:", nil);
    
    groupNumber = [[UILabel alloc] initWithFrame:CGRectMake(95, 31, 210, 12)];
    groupNumber.adjustsFontSizeToFitWidth = YES;
    groupNumber.lineBreakMode = NSLineBreakByTruncatingTail;
    groupNumber.backgroundColor = [UIColor clearColor];
    groupNumber.textColor = [UIColor colorWithHexString:SETTING_ORANGE_TEXT_COLOR];
    groupNumber.font = [UIFont boldSystemFontOfSize:12];
    groupNumber.textAlignment = NSTextAlignmentLeft;
    
    [searchCellView addSubview:groupName];
    [searchCellView addSubview:groupLabel];
    [searchCellView addSubview:groupNumber];
    [searchCellView addSubview:groupImageview];
    
//    [groupName release];
//    [groupLabel release];
//    [groupNumber release];
//    [groupImageview release];
    
    return searchCellView;
}
@end