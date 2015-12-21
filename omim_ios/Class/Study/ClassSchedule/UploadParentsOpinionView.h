//
//  UploadParentsOpinionView.h
//  dev01
//
//  Created by 杨彬 on 15-1-1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
#import "GalleryViewController.h"
#import "UIPlaceHolderTextView.h"


@interface UploadParentsOpinionView : UIView<UITextViewDelegate,QBImagePickerControllerDelegate,GalleryViewControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (retain, nonatomic) IBOutlet UIButton *btn_audio;
@property (retain ,nonatomic) UIPlaceHolderTextView *textView_text;
@property (copy, nonatomic) NSString * text_placeholder;
- (IBAction)addAudioAction:(id)sender;

@end
