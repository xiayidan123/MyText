/* UIToggleButton.h
 *
 *  wowtalk
 *
 *  Created by eki-chin on 11/03/19.
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */     

#import <UIKit/UIKit.h>

@protocol UIToggleButtonDelegate 
	-(void) onOn;
	-(void) onOff;
	-(bool) isInitialStateOn;
@end

@interface UIToggleButton : UIButton<UIToggleButtonDelegate>
{
@private
	UIImage* mOnImage;
	UIImage* mOffImage;
//	id<UIToggleButtonDelegate> mActionHandler;
	bool mIsOn;
    
    int mInitType;  // 0: color, 1:image
	
	
}

@property (nonatomic,retain)  UIColor* mOnColor;
@property (nonatomic,retain)  UIColor* mOffColor;

-(void) initWithOnImage:(UIImage*) onImage offImage:(UIImage*) offImage;
-(void) initWithOnColor:(UIColor*) onColor offColor:(UIColor*) offColor;
-(bool) reset;
-(bool) isOn;
-(bool) toggle;

@end
