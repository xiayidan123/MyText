//
//  timelineEmptyContentIndForAll.m
//  suzhou
//
//  Created by xu xiao feng on 14-4-1.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "timelineEmptyContentIndForAll.h"
#import "PublicFunctions.h"

@implementation TimelineEmptyContentIndForAll

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //background
        UIButton* bkgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, [TimelineEmptyContentIndForAll cellHeight])];
        bkgButton.backgroundColor = [UIColor clearColor];
        [bkgButton addTarget:self action:@selector(emptyBkgClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:bkgButton];
        [bkgButton release];
        
        //white padding
        UILabel* white_padding_top = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        white_padding_top.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:white_padding_top];
        [white_padding_top release];
        
        //image
        UIImageView* img_ind = [[UIImageView alloc] initWithFrame:CGRectMake(60, 30, 200, 40)];
        [img_ind setImage:[UIImage imageNamed:@"moments_list_bg.png"]];
        [self.contentView addSubview:img_ind];
        [img_ind release];
        
        //text
        UILabel* labelTxt = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 30)];
        labelTxt.backgroundColor = [UIColor clearColor];
        labelTxt.font = [UIFont systemFontOfSize:17];
        labelTxt.minimumScaleFactor = 7;

        labelTxt.adjustsFontSizeToFitWidth = TRUE;
        labelTxt.textColor = [UIColor blackColor];
        labelTxt.textAlignment = NSTextAlignmentCenter;
        labelTxt.text=NSLocalizedString(@"timeline_all_empty_ind_txt", Nil);
        [self.contentView addSubview:labelTxt];
        [labelTxt release];
        
        //white padding
        UILabel* white_padding_bottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 320, 30)];
        white_padding_bottom.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:white_padding_bottom];
        [white_padding_bottom release];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)emptyBkgClicked
{
    
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
    return 150;
}

@end