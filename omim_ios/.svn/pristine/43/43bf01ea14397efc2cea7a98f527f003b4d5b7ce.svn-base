//
//  GroupInfoBuddyCell.m
//  omim
//
//  Created by wow on 14-2-23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "GroupInfoBuddyCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation GroupInfoBuddyCell

@synthesize label;
@synthesize lbl_role = _lbl_role;
@synthesize deleteicon = _deleteicon;

- (id)init {
	
    if (self = [super init]) {
		
        self.frame = CGRectMake(0, 0, 58, 79);
		
		[[NSBundle mainBundle] loadNibNamed:@"GroupInfoBuddyCell" owner:self options:nil];
        
        [self addSubview:self.view];    
	}
	
    return self;
}

- (void)dealloc
{
    self.lbl_role  = nil;
    self.label = nil;
    self.deleteicon = nil;
    [_headImageView release],_headImageView = nil;
    [super dealloc];
}



@end
