/* UIHangUpButton.m
 *
 *
 *  Created by eki-chin on 11/12/13
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */          

#import "UIHangUpButton.h"
#import "WowTalkVoipIF.h"

@implementation UIHangUpButton


-(void) touchUp:(id) sender {
     [WowTalkVoipIF fTerminateCall];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
		[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}	


- (void)dealloc {
    [super dealloc];
}


@end
