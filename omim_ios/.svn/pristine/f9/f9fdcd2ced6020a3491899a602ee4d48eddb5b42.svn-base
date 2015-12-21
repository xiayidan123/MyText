//
//  UICallQuality.m
//  omim
//
//  Created by Coca on 7/1/11.
//  Copyright 2011 WowTech Inc. All rights reserved.
//

#import "UICallQuality.h"
#import "WowTalkVoipIF.h"
//#import "ABUtil.h"
@implementation UICallQuality
-(void)updateCallQuality {
    if (![WowTalkVoipIF fIsWowTalkServiceReady]) {
        return;
    }
	float lQuality = [WowTalkVoipIF fGetCurrentCallQuality];
   	//NSLog(@"lQuality=%f",lQuality);
	switch ((int)lQuality) {
		case 0:
//			[self setImage:[[Theme sharedInstance] tileColoredImageWithName:NETSTATUS_0]];
			break;
		case 1:
		case 2:
//			[self setImage:[[Theme sharedInstance] tileColoredImageWithName:NETSTATUS_1]];
			break;
		case 3:
//            [self setImage:[[Theme sharedInstance] tileColoredImageWithName:NETSTATUS_2]];
            break;
            
		case 4:
		case 5:
//			[self setImage:[[Theme sharedInstance] tileColoredImageWithName:NETSTATUS_3]];
			break;
		default:
			break;
	}
}

-(void) start {
	self.hidden = NO;
	qualityRefreasher = [NSTimer scheduledTimerWithTimeInterval:2.0 
														  target:self 
														selector:@selector(updateCallQuality) 
														userInfo:nil 
														 repeats:YES];
}
-(void) stop {
	self.hidden = YES;
	[qualityRefreasher invalidate];
	qualityRefreasher=nil;
	
}



- (void)dealloc {
    [super dealloc];
	[qualityRefreasher invalidate];
}


@end
