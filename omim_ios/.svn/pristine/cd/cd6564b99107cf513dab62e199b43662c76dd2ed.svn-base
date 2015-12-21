/* UIAddVideoButton.h
 *
 *  Created by eki-chin on 11/12/13
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */   

#import <UIKit/UIKit.h>


@class CallProcessVC;

@interface UIAddVideoButton : UIButton<UIAlertViewDelegate>{
@private

    UIImage* mOnImage;
	UIImage* mOffImage;
	bool mIsOn;
    
    int mInitType;  // 0: color, 1:image
    
    int mode;

    UIAlertView* alertview;
}
@property (nonatomic,retain)  NSString* mCalleeName;
@property (nonatomic,retain)  UIColor* mOnColor;
@property (nonatomic,retain)  UIColor* mOffColor;
                                                  
@property (nonatomic,retain)  CallProcessVC* vc;


-(void) initWithOnImage:(UIImage*) onImage offImage:(UIImage*) offImage displayInVC:(id)vc;

-(void) initWithOnColor:(UIColor*) onColor offColor:(UIColor*) offColor displayInVC:(CallProcessVC *)vc;

-(bool) reset;
-(bool) isOn;
-(void) startTheInvite;
-(void) acceptVideo;
-(void) setOff;
@end
