//
//  ViewLargePhotoVC.h
//  omim
//
//  Created by coca on 12/09/26.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class MsgComposerVC;
@interface ViewLargePhotoVC : UIViewController<UIGestureRecognizerDelegate>
{
    CGFloat lastScale;
	CGFloat lastRotation;
	
	CGFloat firstX;
	CGFloat firstY;	
    
    BOOL isButtonHide;
    BOOL isSaved;
    
    CGFloat screenHeight;
    CGFloat screenWidth;
    
    CGFloat originalImageviewWidth;
    CGFloat originalImageviewHeight;
    
    UIImage* image;
}


@property (nonatomic,retain) MsgComposerVC* parent;
@property (nonatomic,retain) IBOutlet UIScrollView* sv_container;
@property (nonatomic,retain) IBOutlet UIImageView* iv_container;

@property (nonatomic,retain) ALAsset* asset;

//@property (nonatomic,retain) IBOutlet UIButton* btn_dismiss;
//@property (nonatomic,retain) IBOutlet UIButton* btn_save;

@property (nonatomic,retain) NSString* originalFilePath;
@property (nonatomic,assign) CGRect thumbnailFrame;

@property (nonatomic,retain) UIImage* image;


//-(IBAction)fdismiss:(id)sender;
//-(IBAction)fSavePhoto:(id)sender;



@end
