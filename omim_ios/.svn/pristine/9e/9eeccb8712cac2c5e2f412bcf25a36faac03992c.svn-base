//
//  LastestMsgCell.m
//  omim
//
//  Created by Coca on 6/2/11.
//  Copyright 2011 WOW Technology Co.,Ltd. All rights reserved.
//

#import "LastestMsgCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation LastestMsgCell

@synthesize lblcount;
@synthesize iv_countbg;
@synthesize lblUserName;
@synthesize lblMsg;
@synthesize lblSentDate;

@synthesize btn_delete;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.iv_divider setImage:[UIImage imageNamed:@"divider_320.png"]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

-(void)dealloc
{
    [self.iv_countbg release],self.iv_countbg = nil;
    [self.lblcount release],self.lblcount = nil;
    [self.lblMsg release],self.lblMsg = nil;
    [self.lblSentDate release],self.lblSentDate = nil;
    [self.lblUserName release],self.lblUserName = nil;
    
    [self.btn_delete release],self.btn_delete = nil;
    
    [_headImageView release];
    [super dealloc];
}

@end
