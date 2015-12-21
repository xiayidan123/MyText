/* UIMuteButton.m
 *
 *  Created by eki-chin on 11/12/13
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */       
#import "UIPauseResumeButton.h"
#include "WowTalkVoipIF.h"


@implementation UIPauseResumeButton



-(void) onOn {
    [WowTalkVoipIF fPauseResumeCall:true];
}
-(void) onOff {
    [WowTalkVoipIF fPauseResumeCall:false];
}
-(bool) isInitialStateOn {
    
	@try {

        return [WowTalkVoipIF fIsCallPaused];
        
        
    } @catch(NSException* e) {
		//not ready yet
		return false;
	}
	
}


@end
