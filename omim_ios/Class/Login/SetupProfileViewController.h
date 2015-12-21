//
//  SetupProfileViewController.h
//  dev01
//
//  Created by jianxd on 14-1-23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupProfileViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (retain, nonatomic) IBOutlet UIView *containerView;

@property (retain, nonatomic) IBOutlet UIImageView *avatarBorder;
@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;

@property (retain, nonatomic) IBOutlet UIImageView *inputBackground;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;

@property (retain, nonatomic) IBOutlet UIButton *enterButton;

@end
