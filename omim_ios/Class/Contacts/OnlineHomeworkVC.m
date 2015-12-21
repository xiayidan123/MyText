//
//  OnlineHomeworkVC.m
//  dev01
//
//  Created by Huan on 15/3/24.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OnlineHomeworkVC.h"
#import "AppDelegate.h"
#import "OMTabBarVC.h"
#import "MessagesVC.h"
#import "PublicFunctions.h"
#import "Database.h"
#import "Constants.h"
#import "Buddy.h"
#import "NSFileManager+extension.h"
#import "UIImage+Resize.h"
#import "WowTalkWebServerIF.h"
#import "WTError.h"
#import "OMMessageVC.h"
@interface OnlineHomeworkVC ()<SchoolViewControllerDelegate>
@property (nonatomic, retain) Buddy *buddy;
@property (nonatomic, assign) BOOL needCropping;
@property (nonatomic, copy) NSString *diName;
@property (nonatomic, retain) PersonModel *person;

@end

@implementation OnlineHomeworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"在线作业", nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    //    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.schoolVC = [[[OnlineHomeViewController alloc] init] autorelease];
    self.schoolVC.delegate = self;
    [self.view addSubview:self.schoolVC.view];
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    [self scalePhoto];
    
    
//    self.schoolVC.delegate = self;
    
}
- (void)scalePhoto
{
    self.maxThumbnailSize = CGSizeMake(MULTIMEDIACELL_THUMBNAIL_MAX_X, MULTIMEDIACELL_THUMBNAIL_MAX_Y);
    UIImage *image = self.homeworkIMG;
    CGSize targetSize;
    CGSize targetSizeThumbnail;
    if (self.needCropping) {
        if (image.size.height>image.size.width)
        {
            targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.width, image.size.width) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
        }
        else
        {
            targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.height, image.size.height) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
        }
        
        self.homeworkIMG = [image resizeToSqaureSize:targetSize];
        
        targetSizeThumbnail = [self.homeworkIMG calculateTheScaledSize:CGSizeMake(self.homeworkIMG.size.width, self.homeworkIMG.size.height) withMaxSize: self.maxThumbnailSize];
        
        self.homeworkThumnailIMG = [image resizeToSqaureSize:targetSizeThumbnail];
        
    }
    else
    {
        targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.width, image.size.height) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
        
        self.homeworkIMG = [image resizeToSize:targetSize];
        
        targetSizeThumbnail = [self.homeworkIMG calculateTheScaledSize:CGSizeMake(self.homeworkIMG.size.width, self.homeworkIMG.size.height) withMaxSize: self.maxThumbnailSize];
        
        self.homeworkThumnailIMG = [image resizeToSize:targetSizeThumbnail];
        
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        //            [picker release];
        
    }
}
#pragma mark SchoolViewControllerDelegate
- (void)addBuddyFromSchoolWithPersonModel:(PersonModel *)person
{
    self.person = person;
    self.buddy = [Database buddyWithUserID:person.uid];
    if (self.buddy){//取相册缩略图和原图 并用self.buddy.userID拼接缩略图和原图的路径
        
        self.diName = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:self.buddy.userID];
        [self appendPath];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC fComposeWowTalkMsgToUser:self.buddy withFirstChat:NO andViewController:self];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];
        if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[OMMessageVC class]]){
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
    else
    {
        [WowTalkWebServerIF getBuddyWithUID:person.uid withCallback:@selector(didGetBuddyWithUID:) withObserver:self];
    }
}
- (void)didGetBuddyWithUID:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.buddy = [Database buddyWithUserID:self.person.uid];
        self.diName = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:self.buddy.userID];
        [self appendPath];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC.omMessageVC fComposeWowTalkMsgToUser:self.buddy withFirstChat:NO andViewController:self];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).tabBarVC jumpToOtherVCWithIndex:0];
        if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[OMMessageVC class]]){
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
}



-(NSString *)imagePath
{
    if (!_imagePath) {
        _imagePath = [NSFileManager randomRelativeFilePathInDir:self.diName ForFileExtension:JPG];
    }
    return _imagePath;
}

- (NSString *)thumbnailPath
{
    if (!_thumbnailPath) {
        _thumbnailPath = [NSFileManager randomRelativeFilePathInDir:self.diName ForFileExtension:JPG];
    }
    return _thumbnailPath;
}
- (NSString *)diName
{
    if (!_diName) {
        _diName = [MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:self.buddy.userID];
    }
    return _diName;
}
- (void)appendPath
{
    NSData * data = [NSData dataWithData:UIImageJPEGRepresentation(self.homeworkIMG, 1.0f)];//1.0f = 100% quality
    
    [data writeToFile:[NSFileManager absolutePathForFileInDocumentFolder:self.imagePath] atomically:YES];
    NSLog(@"imgpath : %@",self.imagePath);
    NSData * data2 = [NSData dataWithData:UIImageJPEGRepresentation(self.homeworkThumnailIMG, 1.0f)];  //1.0f = 100% quality
    NSLog(@"thumnailPath : %@",self.thumbnailPath);
    [data2 writeToFile: [NSFileManager absolutePathForFileInDocumentFolder:self.thumbnailPath] atomically:YES];
}
#pragma mark - AddCourseControllerDelegate
- (void)refreshSchoolTree{
    [self.schoolVC loadData];
}
@end
