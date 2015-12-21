/* UIToggleButton.m
 *
 *  wowtalk
 *
 *  Created by eki-chin on 11/03/19.
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */      
#import "UIToggleButton.h"


@implementation UIToggleButton
@synthesize mOnColor,mOffColor;

-(void) touchUp:(id) sender {
	[self toggle];
}
-(bool) isOn {
	return mIsOn;
}
-(bool) toggle {
	if (mIsOn) {
        
        if (mInitType == 1) {
            [self setBackgroundImage:mOffImage forState:UIControlStateNormal];
        }
        else
        {
            [self setBackgroundColor:self.mOffColor];
        }
     
        mIsOn=!mIsOn;
		[self onOff];
	} 
    else {
        if (mInitType == 1) {
            [self setBackgroundImage:mOnImage forState:UIControlStateNormal];
        }
		else
        {
            [self setBackgroundColor:self.mOnColor];
        }
		mIsOn=!mIsOn;
		[self onOn];
	}
	return mIsOn;
	
}
-(bool) reset {
	mIsOn = [self isInitialStateOn];
    if (mInitType == 1) {
        	[self setBackgroundImage:mIsOn?mOnImage:mOffImage forState:UIControlStateNormal];
    }
    else 
    {
        [self setBackgroundColor:mIsOn?self.mOnColor:self.mOffColor];
    }
	return mIsOn;
}

-(void) initWithOnImage:(UIImage*) onImage offImage:(UIImage*) offImage {
	mOnImage = [onImage retain];
	mOffImage = [offImage retain];
	mIsOn=NO;
    mInitType = 1;  // image
	[self reset];
	[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
	
}

-(void) initWithOnColor:(UIColor *)onColor offColor:(UIColor *)offColor
{
    self.mOnColor = onColor;
    self.mOffColor = offColor;
    mIsOn = NO;
    mInitType = 0;  // color
    [self reset];
	[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */


- (void)dealloc {
   
	[mOffImage release];
	[mOffImage release];
  //  [self.mOnColor release];
  //  [self.mOffColor release];
    [super dealloc];
}

-(void) onOn {
    [NSException raise:NSInternalInconsistencyException 
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}
-(void) onOff {
    [NSException raise:NSInternalInconsistencyException 
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}
-(bool) isInitialStateOn {
    [NSException raise:NSInternalInconsistencyException 
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return false;
}


@end
