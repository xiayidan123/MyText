//
//  UIVideoMuteButton.h
//  omim
//
//  Created by Coca on 12/14/11.
//  Copyright (c) 2011 WowTech Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIVideoMuteButton : UIButton {
@private
    
	bool mIsOn;
}

@property (nonatomic,retain) UIImage* mOnImage;
@property (nonatomic,retain) UIImage* mOffImage;

-(void) initWithOnImage:(UIImage*) onImage offImage:(UIImage*) offImage;
-(void) initButton;
-(bool) reset;
-(bool) isOn;
-(bool) toggle;

@end
