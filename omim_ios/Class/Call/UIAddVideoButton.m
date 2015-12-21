/* UIAddVideoButton.m
 *
 *  Created by eki-chin on 11/12/13
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */        

#import "UIAddVideoButton.h"
#import "WTHeader.h"
#import "CallProcessVC.h"



@implementation UIAddVideoButton
@synthesize mCalleeName;
@synthesize mOffColor,mOnColor;
@synthesize vc;


////////////////////////////////////////////////////
-(void) startTheInvite {
    mIsOn = YES;
   

    [self setBackgroundImage:mIsOn?mOnImage:mOffImage forState:UIControlStateNormal];
      
    //pop up a notification
    mode = 1;  // invite others.
   
    
    [self.vc.lbl_connectionstatus setText:NSLocalizedString(@"is inviting the callee", nil)];
    
    [WowTalkVoipIF fVideoCall_StartInvite:YES];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView release];
    
}



-(void)acceptVideo{

     mIsOn = YES;

    
    
    if (alertview) {
        [alertview dismissWithClickedButtonIndex:0 animated:YES];
    }

    [self.vc.lbl_connectionstatus setText:NSLocalizedString(@"is establishing the connection", nil)];

    
    [WowTalkVoipIF fVideoCall_AcceptInvitation];
 
    [self setBackgroundImage:mIsOn?mOnImage:mOffImage forState:UIControlStateNormal];
 

}

-(void) setOff {
     mIsOn = NO;
     [self setBackgroundImage:mIsOn?mOnImage:mOffImage forState:UIControlStateNormal];
   
    [self.vc.lbl_connectionstatus setText:@""];

}


-(void) touchUp:(id) sender {
	if (mIsOn) {
		[self setOff];
	} 
    else 
    {
		[self startTheInvite];
	}
}
-(bool) isOn 
{
	return mIsOn;
}


-(bool) reset {
	mIsOn = FALSE;
 
    [self setBackgroundImage:mIsOn?mOnImage:mOffImage forState:UIControlStateNormal];
    
    [self.vc.lbl_connectionstatus setText:@""];

    
	return mIsOn;
}



////////////////////////////////////////////////////

- (id) init {
	[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
	return self;
}

-(void) initWithOnImage:(UIImage*) onImage offImage:(UIImage*) offImage displayInVC:(id)viewcontroller
{
    mOnImage = [onImage retain];
	mOffImage = [offImage retain];
	mIsOn=NO;
    mInitType = 1;  // image
    self.vc = viewcontroller;
    
	[self reset];
	[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
	
	
}

-(void) initWithOnColor:(UIColor *)onColor offColor:(UIColor *)offColor displayInVC:(CallProcessVC*)viewcontroller
{
    self.mOnColor = onColor;
    self.mOffColor = offColor;
    self.vc = viewcontroller;
    
	mIsOn=NO;
    mInitType = 0; // color
   
	[self reset];
	[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)dealloc {
    
	[mOffImage release];
	[mOffImage release];
    //  [self.mOnColor release];
    //  [self.mOffColor release];
    [super dealloc];
}


@end
