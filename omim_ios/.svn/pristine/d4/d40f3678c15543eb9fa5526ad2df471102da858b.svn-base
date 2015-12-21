/* UIDuration.m
 *  wowtalk
 *
 *  Created by eki-chin on 11/03/19.
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */    



#import "UIDuration.h"
#import "WowTalkVoipIF.h"

@implementation UIDuration

-(void)updateCallDuration {
    if (![WowTalkVoipIF fIsWowTalkServiceReady]) {
        return;
    }
	mDuration = [WowTalkVoipIF fGetCurrentCallDuration];
    NSString* txtMsg=@"";
	if(mDuration<0){
        //do nothing
    }
    else if (mDuration < 60) {
		txtMsg=[NSString stringWithFormat: @"%02i s", mDuration];
	} else {
		txtMsg=[NSString stringWithFormat: @"%02i:%02i", mDuration/60,mDuration - 60 *(mDuration/60)];
	}
    
    if (mStatus>0) {
        if (mStatus==1) {
            txtMsg=NSLocalizedString(@"Paused",nil);
        }
        else{
            txtMsg=[NSString stringWithFormat:@"%@ %@",txtMsg,NSLocalizedString(@"Paused by callee",nil)]; //TODO better to change it to the user name;
        }
    }
    
    
    [self setText:txtMsg];
}

-(void) start {
	mDuration = 0;
    mStatus = 0;
	[self setText:@"00 s"];
	durationRefreasher = [NSTimer	scheduledTimerWithTimeInterval:1 
														  target:self 
														selector:@selector(updateCallDuration) 
														userInfo:nil 
														 repeats:YES];
}
-(void) stop {
	[durationRefreasher invalidate];
	durationRefreasher=nil;
	mDuration = 0;
    mStatus = 0;
}

-(void) pause:(int)mode{
    mStatus = mode;
}

-(void) resume{
    mStatus=0;
}


-(int)getDuration{
	return mDuration;
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
	[durationRefreasher invalidate];
}


@end
