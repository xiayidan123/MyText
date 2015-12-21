//
//  GalleryViewController.h
//  omimbiz
//
//  Created by elvis on 2013/08/14.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Buddy;
@class UserGroup;

@protocol GalleryViewControllerDelegate <NSObject>

@optional
-(void)didDeletePhotosInGallery:(NSMutableArray*)arr_deleted;

@end

@interface GalleryViewController : UIViewController<UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    CGFloat lastScale;
	CGFloat lastRotation;
	
	CGFloat firstX;
	CGFloat firstY;
    
    BOOL isButtonHide;
    BOOL isSaved;
    
    CGFloat screenHeight;
    CGFloat screenWidth;

    UIImage* image;
}

@property BOOL isViewMessages;
@property BOOL isViewMoments;
@property BOOL isViewAssests;
@property BOOL isViewBuddyAvatar;
@property BOOL isViewGroupAvatar;
@property BOOL isViewEvents;

@property BOOL isEnableDelete;

@property (nonatomic,retain) Buddy* buddy;
@property (nonatomic,retain) UserGroup* group;


@property NSInteger startpos;

@property (nonatomic,retain) NSString* momentid;

@property (assign) id<GalleryViewControllerDelegate> delegate;

@property (nonatomic,retain) IBOutlet UILabel* lbl_count;

@property (nonatomic,retain) IBOutlet UIScrollView* sv_container;

@property (nonatomic,retain) IBOutlet UIImageView* iv_container;

@property (nonatomic,retain) NSMutableArray* arr_assets;  // for viewing the images when creating the moment

@property (nonatomic,retain) NSMutableArray* arr_imgs;    // for viewing the moments images & viewing the msging

@property (nonatomic,retain) NSMutableArray* arr_msgs;

@property (nonatomic,retain) NSMutableArray* arr_saved;

@property (nonatomic,retain) NSMutableArray *arr_events;

@property (nonatomic,retain) NSString* originalFilePath;

@property (nonatomic,assign) CGRect thumbnailFrame;

@property (nonatomic,retain) UIImage* image;



@end
