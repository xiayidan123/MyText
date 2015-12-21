/* UIMuteButton.m
 *
 *  wowtalk
 *
 *  Created by eki-chin on 11/03/19.
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */    
#import "UIMuteButton.h"
#include "WowTalkVoipIF.h"


@implementation UIMuteButton



-(void) onOn {
    [WowTalkVoipIF fMuteMic:true];
}
-(void) onOff {
    [WowTalkVoipIF fMuteMic:false];

}
-(bool) isInitialStateOn {
  
	@try {
		return [WowTalkVoipIF fIsMicMuted];
	} @catch(NSException* e) {
		//not ready yet
		return false;
	}
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
