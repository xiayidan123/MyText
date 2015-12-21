//
//  UICallQuality.h
//  omim
//
//  Created by Coca on 7/1/11.
//  Copyright 2011 WowTech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UICallQuality : UIImageView {
@private 
	NSTimer *qualityRefreasher;
}

-(void) start;
-(void) stop;

@end
