//
//  UIVideoMuteButton.m
//  omim
//
//  Created by eki-chin on 12/14/11.
//  Copyright (c) 2011 WowTech Inc. All rights reserved.
//

#import "UIVideoMuteButton.h"
#include "WowTalkVoipIF.h"

@implementation UIVideoMuteButton
@synthesize mOnImage,mOffImage;

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
-(void) touchUp:(id) sender {
	[self toggle];
}
-(bool) isOn {
	return mIsOn;
}
-(bool) toggle {
	if (mIsOn) {
		[self setImage:self.mOffImage forState:UIControlStateNormal];
		mIsOn=!mIsOn;
		[self onOff];
	} else {
		[self setImage:self.mOnImage forState:UIControlStateNormal];
		mIsOn=!mIsOn;
		[self onOn];
	}
	return mIsOn;
	
}
-(bool) reset {
	mIsOn = [self isInitialStateOn];
	[self setImage:mIsOn?self.mOnImage:self.mOffImage forState:UIControlStateNormal];
	return mIsOn;
}
-(void)initButton
{
    mIsOn=NO;
    [self reset];
	[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) initWithOnImage:(UIImage*) onImage offImage:(UIImage*) offImage {
	self.mOffImage =offImage;
    self.mOnImage = onImage;
    
    mIsOn=NO;
	[self reset];
	[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
	
}


- (void)dealloc {
    [super dealloc];
	[mOffImage release];
	[mOnImage release];
}


@end
