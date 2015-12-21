/* UIDuration.h
 *
 *  wowtalk
 *
 *  Created by eki-chin on 11/03/19.
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */     



#import <UIKit/UIKit.h>


@interface UIDuration : UILabel {
@private 
	NSTimer *durationRefreasher;
	int mDuration;
    int mStatus; //0:normal ; 1:paused by me; 2:paused by callee
}

-(void) start;
-(void) stop;
-(void) pause:(int)mode;
-(void) resume;
-(int)getDuration;
@end
