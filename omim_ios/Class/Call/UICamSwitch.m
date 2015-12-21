/* UICamSwitch.m
 *
 *  Created by eki-chin on 11/12/13
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */  
#import "UICamSwitch.h"
#include "WowTalkVoipIF.h"


@implementation UICamSwitch
-(void) touchUp:(id) sender {
	[WowTalkVoipIF fVideoCall_SwitchCaptureCamera];
}

- (id) superInit {
	[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		[self superInit];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
		[self superInit];
	}
    return self;
}	


- (void)dealloc {
    [super dealloc];
}





@end
