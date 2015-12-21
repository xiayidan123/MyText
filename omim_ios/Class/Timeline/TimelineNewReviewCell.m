//
//  TimelineNewReviewCell.m
//  suzhou
//
//  Created by xu xiao feng on 14-4-3.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "TimelineNewReviewCell.h"
#import "PublicFunctions.h"
#import "WTNetworkTaskConstant.h"

#define DETAIL_TEXT_TAG 1

@implementation TimelineNewReviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //background
        UIButton* bkgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, [TimelineNewReviewCell cellHeight])];
        bkgButton.backgroundColor = [UIColor clearColor];
        [bkgButton addTarget:self action:@selector(emptyBkgClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:bkgButton];
        [bkgButton release];
        
        //timeline cell round white bg
        UIImageView* bg_card1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [TimelineNewReviewCell cellHeight])];
        [bg_card1 setImage:[PublicFunctions strecthableImage:@"timeline_card_bg.png"]];
        [self.contentView addSubview:bg_card1];
        [bg_card1 release];
        
        //image for timeline_notification
        UIImageView* img_notification = [[UIImageView alloc] initWithFrame:CGRectMake(17, 15, 40, 40)];
        [img_notification setImage:[UIImage imageNamed:@"timeline_notification.png"]];
        [self.contentView addSubview:img_notification];
        [img_notification release];
        
        //detail text
        UILabel* labelTxt = [[UILabel alloc] initWithFrame:CGRectMake(67, 20, 280, 30)];
        labelTxt.backgroundColor = [UIColor clearColor];
        labelTxt.font = [UIFont systemFontOfSize:17];
        labelTxt.minimumScaleFactor = 7;
        labelTxt.adjustsFontSizeToFitWidth = TRUE;
        labelTxt.textColor = [UIColor blackColor];
        labelTxt.textAlignment = NSTextAlignmentLeft;
        labelTxt.tag=DETAIL_TEXT_TAG;
        [self.contentView addSubview:labelTxt];
        [labelTxt release];
        
        //right arrow
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)emptyBkgClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TIMELINE_VIEW_NEW_REVIEWS object:self];
}

-(void)setDetailText:(NSString *)detailText
{
    UILabel* labelTxt=(UILabel *)[self.contentView viewWithTag:DETAIL_TEXT_TAG];
    labelTxt.text = detailText;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSInteger)cellHeight
{
    return 70;
}

@end
