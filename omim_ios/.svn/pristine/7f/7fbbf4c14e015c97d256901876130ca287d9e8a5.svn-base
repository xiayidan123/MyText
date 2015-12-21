/* VideoViewController.h
 *
 *  Created by eki-chin on 11/12/13
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */    
#import <UIKit/UIKit.h>

//@class  UICopyPasteLabel;
@class  UIVideoMuteButton;
@class UICamSwitch;
@class UIDuration;



@interface VideoCallVC : UIViewController {

	BOOL isFirst;
    BOOL _isPreviewShown;

}

// portrait
@property (nonatomic, retain) IBOutlet UIView* mPortrait;
@property (nonatomic,retain)  IBOutlet UIView* uv_Preview;
@property (nonatomic,retain) IBOutlet UIView* uv_operationbar;

@property (nonatomic, retain) IBOutlet UIImageView* mDisplay;
@property (nonatomic, retain) IBOutlet UIImageView* mPreview;

@property (nonatomic,retain)  IBOutlet UIButton* btn_showPreview;

@property (nonatomic, retain) IBOutlet UIButton* mHangUp;
@property (nonatomic, retain) IBOutlet UIVideoMuteButton* mMute;
@property (nonatomic, retain) IBOutlet UICamSwitch* mCamSwitch;

@property (nonatomic, retain) IBOutlet UIDuration* pLblCallDuration;


-(IBAction)fEndCall;



@end