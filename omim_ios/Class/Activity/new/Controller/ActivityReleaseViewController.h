//
//  ActivityReleaseViewController.h
//  dev01
//
//  Created by 杨彬 on 14-11-19.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "QBImagePickerController.h"
#import "GalleryViewController.h"
#import "UIPlaceHolderTextView.h"
@protocol ActivityReleaseDelegate <NSObject>

- (void)refreshActivityListViewController;

@end


@interface ActivityReleaseViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate, QBImagePickerControllerDelegate,GalleryViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,assign) id<ActivityReleaseDelegate> delegate;
@property (nonatomic,retain) NSMutableArray* selectedPhotos;
@property (nonatomic,assign) ALAssetsLibrary* assetLib;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView_bg;


@property (retain, nonatomic) IBOutlet UIView *view_background;

#pragma mark-----section0

@property (retain, nonatomic) IBOutlet UIView *view_section0;
@property (retain, nonatomic) IBOutlet UILabel *lab_title;
@property (retain, nonatomic) IBOutlet UITextView *textView_title;



#pragma mark-----section1
@property (retain, nonatomic) IBOutlet UIView *view_section1;
@property (retain, nonatomic) IBOutlet UILabel *lab_startDate;
@property (retain, nonatomic) IBOutlet UILabel *lab_StartDateContent;
@property (retain, nonatomic) IBOutlet UIImageView *uiImageView_markStartDate;

@property (retain, nonatomic) IBOutlet UIView *view_startDate;
@property (retain, nonatomic) IBOutlet UIView *view_endDate;
@property (retain, nonatomic) IBOutlet UIView *view_area;
@property (retain, nonatomic) IBOutlet UIView *view_maxMember;
@property (retain, nonatomic) IBOutlet UIView *view_coin;


@property (retain, nonatomic) IBOutlet UILabel *lab_endDate;
@property (retain, nonatomic) IBOutlet UILabel *lab_endDateContent;
@property (retain, nonatomic) IBOutlet UIImageView *uiImageView_markEndDate;


@property (retain, nonatomic) IBOutlet UILabel *lab_area;
@property (retain, nonatomic) IBOutlet UILabel *lab_maxMember;
@property (retain, nonatomic) IBOutlet UILabel *lab_coin;

@property (retain, nonatomic) IBOutlet UITextView *textView_area;
@property (retain, nonatomic) IBOutlet UITextField *textField_maxMember;
@property (retain, nonatomic) IBOutlet UITextField *textField_coin;


#pragma mark-----section2

@property (retain, nonatomic) IBOutlet UIView *view_section2;


#pragma mark-----section3

@property (retain, nonatomic) IBOutlet UIView *view_section3;
//@property (retain, nonatomic) IBOutlet UITextView *textView_description;
@property(retain,nonatomic)UIPlaceHolderTextView *textView_description;

#pragma mark-----section4

@property (retain, nonatomic) IBOutlet UIView *view_section4;

@property (retain, nonatomic) IBOutlet UILabel *lab_isGetMemberInfo;

@property (retain, nonatomic) IBOutlet UISwitch *switch_isGetMemberInfo;



#pragma mark-----section5

@property (retain, nonatomic) IBOutlet UIView *view_section5;

@property (retain, nonatomic) IBOutlet UILabel *lab_isOpen;

@property (retain, nonatomic) IBOutlet UISwitch *switch_isOpen;



@end
