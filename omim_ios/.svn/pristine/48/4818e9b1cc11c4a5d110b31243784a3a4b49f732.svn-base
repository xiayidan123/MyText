//
//  SetupProfileViewController.m
//  dev01
//
//  Created by jianxd on 14-1-23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "SetupProfileViewController.h"
#import "UISize.h"
#import "DeviceHelper.h"
#import "Constants.h"
#import "NSString+Compare.h"
#import "AvatarHelper.h"
#import "NSFileManager+extension.h"
#import "SDKConstant.h"
#import "WowTalkWebServerIF.h"
#import "WTUserDefaults.h"
#import "WTError.h"
#import "AppDelegate.h"

@interface SetupProfileViewController ()
@property (nonatomic) BOOL hasPickPhoto;
@end

@implementation SetupProfileViewController

@synthesize hasPickPhoto;

@synthesize containerView;
@synthesize avatarBorder;
@synthesize avatarImage;
@synthesize inputBackground;
@synthesize nameTextField;
@synthesize enterButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    hasPickPhoto = NO;
    inputBackground.image = [[UIImage imageNamed:TABLE_BLACK_IMAGE] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
//    inputBackground.image = nil;
//    inputBackground.backgroundColor = [UIColor whiteColor];
    nameTextField.background = nil;
    nameTextField.backgroundColor = [UIColor clearColor];
    nameTextField.placeholder = NSLocalizedString(@"Please Enter Your Name", nil);
    nameTextField.textColor = [UIColor whiteColor];
    [nameTextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground:)];
    [containerView addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPickActionSheet:)];
    avatarBorder.userInteractionEnabled = YES;
    [avatarBorder addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    [enterButton setBackgroundImage:[[UIImage imageNamed:LARGE_BLUE_BUTTON] stretchableImageWithLeftCapWidth:20 topCapHeight:10]
                           forState:UIControlStateNormal];
    [enterButton addTarget:self action:@selector(setNickname) forControlEvents:UIControlEventTouchUpInside];
    [enterButton setTitle:NSLocalizedString(@"Enter WowCity", nil) forState:UIControlStateNormal];
    [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    enterButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    enterButton.titleLabel.textColor = [UIColor whiteColor];
    if ([DeviceHelper isIphone5]) {
        avatarBorder.frame = CGRectMake(110, 150, 100, 100);
        avatarImage.frame = CGRectMake(112, 152, 96, 96);
        inputBackground.frame = CGRectMake(16, 290, 288, 44);
        nameTextField.frame = CGRectMake(21, 297, 268, 30);
        enterButton.frame = CGRectMake(16, 350, 288, 44);
    } else {
        avatarBorder.frame = CGRectMake(110, 150, 100, 100);
        avatarImage.frame = CGRectMake(112, 152, 96, 96);
        inputBackground.frame = CGRectMake(16, 290, 288, 44);
        nameTextField.frame = CGRectMake(21, 297, 268, 30);
        enterButton.frame = CGRectMake(16, 350, 288, 44);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super viewWillDisappear:animated];
}

- (void)didTapBackground:(UITapGestureRecognizer *)recognizer
{
    [nameTextField resignFirstResponder];
}

- (void)didUploadAvatar:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] objectForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        hasPickPhoto = YES;
        NSData *data = [AvatarHelper getThumbnailForUser:[WTUserDefaults getUid]];
        if (data) {
            avatarImage.image = [UIImage imageWithData:data];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to set avatar", nil)
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

- (void)didResetNickname:(NSNotification *)notif
{
    NSError *error = [[notif userInfo] objectForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        [[AppDelegate sharedAppDelegate] setupApplicaiton:NO];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to change nickname", nil)
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    CGRect keyboardFrame = [[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat viewHeight = [UISize screenHeightNotIncludingStatusBar];
    CGFloat transformY = keyboardFrame.size.height - (viewHeight - inputBackground.frame.origin.y - inputBackground.frame.size.height);
    NSTimeInterval duration = [[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = containerView.frame;
        frame.origin.y = -transformY;
        containerView.frame = frame;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    NSTimeInterval duration = [[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = containerView.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:duration animations:^{
        containerView.frame = frame;
    }];
}

- (void)setNickname
{
    NSString *nickname = nameTextField.text;
    if ([NSString isEmptyString:nickname] || !hasPickPhoto) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please set avatar and nickname", nil)
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [WowTalkWebServerIF updateMyProfileWithNickName:nickname
                                                 withStatus:nil
                                               withBirthday:nil
                                                    withSex:nil
                                                   withArea:nil
                                               withCallback:@selector(didResetNickname:)
                                               withObserver:self];
        });
    }
}

- (void)showPickActionSheet:(UITapGestureRecognizer *)recognizer
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Take a photo", nil), NSLocalizedString(@"Select from album", nil), nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

#pragma mark - ActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = nil;
    switch (buttonIndex) {
        case 0:
            picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [self presentViewController:picker animated:YES completion:nil];
            }
            break;
        case 1:
            picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [self presentViewController:picker animated:YES completion:nil];
            }
            break;
        case 2:
            break;
        default:
            break;
    }
    [picker release];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];
    
    UIImage *thumbnail = [AvatarHelper getThumbnailFromImage:image];
    UIImage *avatar = [AvatarHelper getPhotoFromImage:image];
    
    NSString *thumbpath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:@"mythumbnail" WithSubFolder:SDK_AVATAR_IMAGE_DIR]];
    BOOL success = [UIImagePNGRepresentation(thumbnail) writeToFile:thumbpath atomically:YES];
    
    if (success) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [WowTalkWebServerIF uploadMyThumbnail:thumbpath withCallback:@selector(didUploadAvatar:) withObserver:self];
        });
    }
    
    NSString *avatarPath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:@"myphoto" WithSubFolder:SDK_AVATAR_IMAGE_DIR]];
    success = [UIImagePNGRepresentation(avatar) writeToFile:avatarPath atomically:YES];
    if (success) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [WowTalkWebServerIF uploadMyPhoto:avatarPath withCallback:nil withObserver:nil];
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [enterButton release];
    [inputBackground release];
    [nameTextField release];
    [avatarBorder release];
    [avatarImage release];
    [containerView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setEnterButton:nil];
    [self setInputBackground:nil];
    [self setNameTextField:nil];
    [self setAvatarBorder:nil];
    [self setAvatarImage:nil];
    [self setContainerView:nil];
    [super viewDidUnload];
}
@end
