//
//  timelineEmptyContentIndForSingle.m
//  suzhou
//
//  Created by xu xiao feng on 14-4-1.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "timelineEmptyContentIndForSingle.h"
#import "Colors.h"

#define BG_BUTTON_TAG 1
#define ADD_IMG_TAG 2
#define DETAIL_TXT_TAG 3


@implementation TimelineEmptyContentIndForSingle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //background
        UIButton* bkgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, [TimelineEmptyContentIndForSingle cellHeight])];
        bkgButton.backgroundColor = [UIColor whiteColor];
        bkgButton.tag=BG_BUTTON_TAG;
        [bkgButton addTarget:self action:@selector(emptyBkgClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:bkgButton];
        [bkgButton release];
        
        //white padding
        UILabel* white_padding_top = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        white_padding_top.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:white_padding_top];
        [white_padding_top release];
        
        //today text
        UILabel* labelToday = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 25)];
        labelToday.backgroundColor = [UIColor clearColor];
        labelToday.font = [UIFont boldSystemFontOfSize:20];
        labelToday.minimumScaleFactor = 7;
        labelToday.adjustsFontSizeToFitWidth = TRUE;
        labelToday.textColor = [UIColor blackColor];
        labelToday.textAlignment = NSTextAlignmentLeft;
        labelToday.text=NSLocalizedString(@"timeline_single_today", Nil);
        [self.contentView addSubview:labelToday];
        [labelToday release];

        //add image
        UIImageView* img_ind = [[UIImageView alloc] initWithFrame:CGRectMake(5, 35, 40, 40)];
        [img_ind setImage:[UIImage imageNamed:@"add_member.png"]];
        [img_ind setBackgroundColor:[UIColor clearColor]];
        img_ind.tag = ADD_IMG_TAG;
        [self.contentView addSubview:img_ind];
        [img_ind release];
        
        //detail text
        UILabel* labelDetail = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, 270, 40)];
        labelDetail.backgroundColor = [UIColor clearColor];
        labelDetail.font = [UIFont systemFontOfSize:13];
        labelDetail.minimumScaleFactor = 7;
        labelDetail.numberOfLines=0;
        labelDetail.adjustsFontSizeToFitWidth = TRUE;
        labelDetail.textColor = [UIColor blackColor];
        labelDetail.textAlignment = NSTextAlignmentLeft;
        labelDetail.text=NSLocalizedString(@"timeline_single_detail_text", Nil);
        labelDetail.tag=DETAIL_TXT_TAG;
        labelDetail.lineBreakMode=NSLineBreakByWordWrapping;
        [self.contentView addSubview:labelDetail];
        [labelDetail release];
    }
    return self;
}

-(void)setIsMe:(BOOL)isMeState
{
    _isMe=isMeState;
    UIImageView* img_ind=(UIImageView *)[self.contentView viewWithTag:ADD_IMG_TAG];
    UILabel* labelDetail=(UILabel *)[self.contentView viewWithTag:DETAIL_TXT_TAG];
    if (isMeState) {
        img_ind.hidden=FALSE;
        labelDetail.frame=CGRectMake(50, 35, 270, 40);
        
    } else {
        img_ind.hidden=TRUE;
        labelDetail.frame=CGRectMake(5, 35, 310, 40);
        
    }
}

-(void)emptyBkgClicked
{
    if (nil != self.delegate) {
        if([self.delegate respondsToSelector:@selector(emptyViewClicked:)]) {
            [self.delegate performSelector:@selector(emptyViewClicked:) withObject:self];
        }
    }
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

+(CGFloat)cellHeight
{
    return 90;
}

@end
