//
//  RCViewCell.m
//  RCLabel
//
//  Created by wow on 14-3-21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "RCViewCell.h"
#import "Constants.h"

@implementation RCViewCell

@synthesize rtLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
        RCLabel *label = [[RCLabel alloc] initWithFrame:CGRectMake(0,0,320 - 30 - 10,100)];
		
        self.rtLabel = label;
        
        [label release];
        
		[self.contentView addSubview:self.rtLabel];
		
		[self.rtLabel setBackgroundColor:[UIColor clearColor]];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGSize optimumSize = [self.rtLabel optimumSize];
    
	CGRect frame = [self.rtLabel frame];
	
    frame.size.height = (int)optimumSize.height + 5;
	
    [self.rtLabel setFrame:frame];
    
}

-(void)dealloc
{
     self.rtLabel = nil;
    [super dealloc];
}


@end

