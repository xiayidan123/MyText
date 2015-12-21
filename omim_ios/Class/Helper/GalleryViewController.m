//
//  GalleryViewController.m
//  omimbiz
//
//  Created by elvis on 2013/08/14.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "GalleryViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "GalleryPhotoView.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "VersionHelper.h"
#import "WTHeader.h"

@interface GalleryViewController ()
{
    CGRect viewFrameBeforeZoom;
    CGRect scrollViewFrameBeforeZoom;
    CGSize scrollViewContentSizeBeforeZoom;
    CGPoint scrolViewContentOffsetBeforeZoom;
    int oldPage;
    NSTimer *_timer;
}

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger totalLength;

@property (nonatomic,retain) NSMutableArray* arr_deletedasset;

@end

#define TAG_PHOTOVIEW_SINGLE        1

@implementation GalleryViewController

@synthesize currentPage = _currentPage;
@synthesize page = _page;
@synthesize totalLength = _totalLength;

@synthesize image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)didReceiveMemoryWarning
//{
//    // Releases the view if it doesn't have a superview.
//    //[super didReceiveMemoryWarning];
//}


-(void)dealloc
{
    self.arr_deletedasset = nil;
    [super dealloc];
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self.navigationItem enableRightBarButtonItem];
    //[self saveShow];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(saveShow) userInfo:nil repeats:NO];
}

-(void)savePhoto
{
    
    [self.navigationItem disableRightBarButtonItem];
    UIImageWriteToSavedPhotosAlbum(self.image, self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
    
}

-(void)saveShow
{
    UIAlertView *avSave = [[UIAlertView alloc]initWithTitle:nil message:@"已保存到本地相册" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    avSave.alertViewStyle = UIAlertViewStyleDefault;
    [avSave show];
    [avSave release];
    
}

-(void)deletePhoto
{
    if (self.arr_deletedasset== nil) {
        self.arr_deletedasset = [[[NSMutableArray alloc] init] autorelease];
    }
    
    NSURL* url = [self.arr_assets objectAtIndex:self.startpos];
    [self.arr_deletedasset addObject:url];
    
    [self.arr_assets removeObjectAtIndex:self.startpos];
    
    if (self.arr_assets != nil && [self.arr_assets count]>0) {
        if (self.startpos == [self.arr_assets count]) {
            self.startpos --;
        }
        
        self.lbl_count.text = [NSString stringWithFormat:@"%zi/%zi",self.startpos +1,[self.arr_assets count]];
        for (UIView *subView in [self.sv_container subviews]) {
            [subView removeFromSuperview];
        }
        [self buildScrollView];
    } else {
        [self goBack];
    }
}


-(IBAction)fdismiss:(id)sender
{
    [UIView animateWithDuration:0.3
                     animations:^(void) {
                         self.view.alpha= 0;
                     } completion:^(BOOL finished) {
                         // we're going to crossfade, so change the background to clear
                         //     [self dismissModalViewControllerAnimated:NO];
                         if([self.view superview] != nil)
                         {
                             [self.view removeFromSuperview];
                         }
                         
                     }];
    
}


#pragma mark - View lifecycle
-(void)goBack{
    
    if (self.arr_deletedasset&&[self.arr_deletedasset count]>0&& self.delegate && [self.delegate respondsToSelector:@selector(didDeletePhotosInGallery:)]) {
        [self.delegate didDeletePhotosInGallery:self.arr_deletedasset];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configNav
{
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    label.text = NSLocalizedString(@"Photo",nil);
    
    self.navigationItem.titleView = label;
    [label sizeToFit];
    
    self.navigationItem.backBarButtonItem = nil;
    
    UIBarButtonItem *leftbutton = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:NAV_BACK_IMAGE] selector:@selector(goBack)];
    [self.navigationItem addLeftBarButtonItem:leftbutton];
    [leftbutton release];
    
    if (self.isEnableDelete) {
        UIBarButtonItem *rightbutton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_DELETE_IMAGE] selector:@selector(deletePhoto)];
        [self.navigationItem addRightBarButtonItem:rightbutton];
        [rightbutton release];
    }
    else{
        UIBarButtonItem *rightbutton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_DOWNLOAD_IMAGE] selector:@selector(savePhoto)];
        [self.navigationItem addRightBarButtonItem:rightbutton];
        [rightbutton release];
    }
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self.view window] == nil)
    {
        self.view = nil;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //    [self configNav];
    
    screenWidth = [UISize screenWidth];
    screenHeight = [UISize screenHeight];
    lastScale = 1.0;
    
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    self.iv_container.userInteractionEnabled = YES;
    
    self.lbl_count.backgroundColor = [UIColor clearColor];
    self.lbl_count.font = [UIFont boldSystemFontOfSize:17];
    self.lbl_count.textAlignment = NSTextAlignmentCenter;
    self.lbl_count.textColor = [UIColor whiteColor];
    
    if (self.isViewAssests) {
        self.lbl_count.text = [NSString stringWithFormat:@"%zi/%zi", self.startpos + 1, [self.arr_assets count]];
    } else if (self.isViewMoments) {
        self.lbl_count.text = [NSString stringWithFormat:@"%zi/%zi", self.startpos + 1, [self.arr_imgs count]];
    } else if (self.isViewBuddyAvatar || self.isViewGroupAvatar) {
        self.lbl_count.text = @"";
    } else if (self.isViewMessages) {
        self.lbl_count.text = [NSString stringWithFormat:@"%zi/%zi", self.startpos + 1, [self.arr_msgs count]];
    }
    [self buildScrollView];
}

- (void)buildScrollView
{
    self.sv_container.pagingEnabled = YES;
    _totalLength = 0;
    if (self.isViewAssests) {
        _totalLength = [self.arr_assets count];
        for (int i = 0; i < _totalLength; i++) {
            if ([[VersionHelper systemVersion] floatValue] < 5.0) {
                NSLog(@"count : %zi < ", _totalLength);
                [[PublicFunctions defaultAssetsLibrary] assetForURL:[self.arr_assets objectAtIndex:i]
                                                        resultBlock:^(ALAsset *asset){
                                                            ALAssetRepresentation *defaultRep = [asset defaultRepresentation];
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                GalleryPhotoView *photoView = [[GalleryPhotoView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
                                                                
                                                                //                                                                [photoView setImage:[UIImage imageWithCGImage:[defaultRep fullResolutionImage]
                                                                //                                                                                                        scale:[defaultRep scale]
                                                                //                                                                                                  orientation:[defaultRep orientation]]];
                                                                [photoView setImage:[UIImage imageWithCGImage:defaultRep.fullScreenImage]];
                                                                
                                                                if (i == self.startpos) {
                                                                    self.image = photoView.image;
                                                                }
                                                                photoView.tag = i + 1;
                                                                [self.sv_container addSubview:photoView];
                                                                [photoView release];
                                                            });
                                                        }
                                                       failureBlock:^(NSError *error){}];
                
            } else {
                NSLog(@"count : %zi >= ", _totalLength);
                dispatch_group_t group = dispatch_group_create();
                dispatch_group_enter(group);
                dispatch_queue_t queue = dispatch_queue_create("loadphoto", DISPATCH_QUEUE_SERIAL);
                dispatch_async(queue, ^{
                    [[PublicFunctions defaultAssetsLibrary] assetForURL:[self.arr_assets objectAtIndex:i] resultBlock:^(ALAsset *asset) {
                        ALAssetRepresentation *defaultRep = [asset defaultRepresentation];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            GalleryPhotoView *photoView = [[GalleryPhotoView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
                            
                            //                            [photoView setImage:[UIImage imageWithCGImage:[defaultRep fullResolutionImage]
                            //                                                                    scale:[defaultRep scale]
                            //                                                              orientation:0]];
                            [photoView setImage:[UIImage imageWithCGImage:defaultRep.fullScreenImage]];
                            
                            if (i == self.startpos) {
                                self.image = photoView.image;
                            }
                            photoView.tag = i + 1;
                            [self.sv_container addSubview:photoView];
                            [photoView release];
                            dispatch_group_leave(group);
                        });
                    }failureBlock:^(NSError *error) {
                        
                        dispatch_group_leave(group);
                    }];
                });
            }
            [self.sv_container setContentSize:CGSizeMake(_totalLength * 320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
            [self.sv_container setContentOffset:CGPointMake(320 * self.startpos, 0)];
            self.sv_container.pagingEnabled = YES;
        }
    } else if (self.isViewMoments) {
        _totalLength = [self.arr_imgs count];
        for (int i = 0; i < _totalLength; i++) {
            GalleryPhotoView *photoView = [[GalleryPhotoView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
            WTFile *file = (WTFile *)[self.arr_imgs objectAtIndex:i];
            NSString *originalFilePath = [NSFileManager absoluteFilePathForMedia:file];
            if (![NSFileManager mediafileExistedAtPath:originalFilePath]) {
                NSData *data = [MediaProcessing getMediaForFile:file.thumbnailid withExtension:file.ext];
                if (data) {
                    [photoView setImage:[UIImage imageWithData:data]];
                }
                [WowTalkWebServerIF getMomentMedia:file isThumb:FALSE inShowingOrder:i forMoment:self.momentid withCallback:@selector(didGetFullResolutionPhoto:) withObserver:self];
            } else {
                [photoView setImage:[UIImage imageWithContentsOfFile:originalFilePath]];
            }
            
            if (i == self.startpos) {
                self.image = photoView.image;
            }
            photoView.tag = i + 1;
            [self.sv_container addSubview:photoView];
            [photoView release];
        }
        [self.sv_container setContentSize:CGSizeMake(_totalLength * 320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
        [self.sv_container setContentOffset:CGPointMake(320 * self.startpos, 0)];
    } else if (self.isViewEvents) {
        self.sv_container.pagingEnabled = YES;
        _totalLength = [self.arr_events count];
        for (int i = 0; i < _totalLength; i++) {
            GalleryPhotoView *photoView = [[GalleryPhotoView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
            WTFile *file = (WTFile *)[self.arr_events objectAtIndex:i];
            NSData *data = [MediaProcessing getMediaForEvent:file.fileid withExtension:file.ext];
            if (data) {
                [photoView setImage:[UIImage imageWithData:data]];
            } else {
                NSData *data = [MediaProcessing getMediaForEvent:file.thumbnailid withExtension:file.ext];
                if (data) {
                    [photoView setImage:[UIImage imageWithData:data]];
                }
                [WowTalkWebServerIF getEventMedia:file isThumb:NO showingOrder:i withCallback:@selector(didDownloadImageForEvent:) withObserver:self];
            }
            if (i == self.startpos) {
                self.image = photoView.image;
            }
            photoView.tag = i + 1;
            [self.sv_container addSubview:photoView];
            [photoView release];
            [self.sv_container setContentSize:CGSizeMake(_totalLength * 320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
            [self.sv_container setContentOffset:CGPointMake(320 * self.startpos, 0)];
        }
    } else if (self.isViewGroupAvatar) {
        GalleryPhotoView *photoView = [[GalleryPhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
        if (self.group.needToDownloadPhoto || ![AvatarHelper getAvatarForGroup:self.group.groupID]) {
            [photoView setImage:[UIImage imageWithData:[AvatarHelper getThumbnailForGroup:self.group.groupID]]];
            [WowTalkWebServerIF getGroupAvatar:self.group.groupID withCallback:@selector(getGroupPhoto:) withObserver:self];
        } else {
            NSString *originalPath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:self.group.groupID WithSubFolder:SDK_GROUP_AVATAR_IMAGE_DIR]];
            [photoView setImage:[UIImage imageWithContentsOfFile:originalPath]];
        }
        self.image = photoView.image;
        photoView.tag = TAG_PHOTOVIEW_SINGLE;
        [self.sv_container addSubview:photoView];
        [photoView release];
        
        [self.sv_container setContentSize:CGSizeMake(320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
        [self.sv_container setContentOffset:CGPointMake(0, 0)];
        self.sv_container.pagingEnabled = NO;
    } else if (self.isViewBuddyAvatar) {
        GalleryPhotoView *photoView = [[GalleryPhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
        if (self.buddy.needToDownloadPhoto || ![AvatarHelper getAvatarForUser:self.buddy.userID]) {
            NSString *originalPath = [NSFileManager absolutePathForFileInDocumentFolder:self.buddy.pathOfThumbNail];
            [photoView setImage:[UIImage imageWithContentsOfFile:originalPath]];
            [WowTalkWebServerIF getPhotoForUserID:self.buddy.userID withCallback:@selector(getBuddyPhoto:) withObserver:self];
        } else {
            NSString *originalPath = [NSFileManager absolutePathForFileInDocumentFolder:self.buddy.pathOfPhoto];
            [photoView setImage:[UIImage imageWithContentsOfFile:originalPath]];
        }
        self.image = photoView.image;
        photoView.tag = TAG_PHOTOVIEW_SINGLE;
        [self.sv_container addSubview:photoView];
        [photoView release];
        
        [self.sv_container setContentSize:CGSizeMake(320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
        [self.sv_container setContentOffset:CGPointMake(0, 0)];
        self.sv_container.pagingEnabled = NO;
    } else if (self.isViewMessages) {
        _totalLength = [self.arr_msgs count];
        for (int i = 0; i < _totalLength; i++) {
            GalleryPhotoView *photoView = [[GalleryPhotoView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
            ChatMessage *message = [self.arr_msgs objectAtIndex:i];
            NSString *filePath = [NSFileManager absolutePathForFileInDocumentFolder:message.pathOfMultimedia];
            if ([NSString isEmptyString:message.pathOfMultimedia] || ![NSFileManager mediafileExistedAtPath:filePath]) {
                if ([NSFileManager mediafileExistedAtPath:[NSFileManager absolutePathForFileInDocumentFolder:message.pathOfThumbNail]]) {
                    [photoView setImage:[UIImage imageWithContentsOfFile:[NSFileManager absolutePathForFileInDocumentFolder:message.pathOfThumbNail]]];
                }
                [WowTalkWebServerIF downloadMediaMessageOriginalFile:message withCallback:@selector(didDownloadOriginalPhoto:) withObserver:self];
            } else {
                if (![NSString isEmptyString:message.pathOfMultimedia] && [NSFileManager mediafileExistedAtPath:filePath]) {
                    [photoView setImage:[UIImage imageWithContentsOfFile:filePath]];
                }
            }
            if (i == self.startpos) {
                self.image = photoView.image;
            }
            photoView.tag = i + 1;
            [self.sv_container addSubview:photoView];
            [photoView release];
        }
        [self.sv_container setContentSize:CGSizeMake(_totalLength * 320, [UISize screenHeightNotIncludingStatusBarAndNavBar])];
        [self.sv_container setContentOffset:CGPointMake(320 * self.startpos, 0)];
        self.sv_container.pagingEnabled = YES;
    }
    [self configNav];
    NSLog(@"container width : %f", self.sv_container.contentSize.width);
    
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)refreshScrollViewWithTag:(int)tag
{
    GalleryPhotoView *photoView = (GalleryPhotoView *)[self.sv_container viewWithTag:tag];
    if (self.isViewBuddyAvatar) {
        NSString *originalPath = [NSFileManager absolutePathForFileInDocumentFolder:self.buddy.pathOfPhoto];
        [photoView setImage:[UIImage imageWithContentsOfFile:originalPath]];
        
    } else if (self.isViewGroupAvatar) {
        NSString *originalPath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:self.group.groupID WithSubFolder:SDK_GROUP_AVATAR_IMAGE_DIR]];
        [photoView setImage:[UIImage imageWithContentsOfFile:originalPath]];
    } else if (self.isViewMessages) {
        ChatMessage *message = [self.arr_msgs objectAtIndex:tag - 1];
        NSString *filePath = [NSFileManager absolutePathForFileInDocumentFolder:message.pathOfMultimedia];
        [photoView setImage:[UIImage imageWithContentsOfFile:filePath]];
    } else if (self.isViewMoments) {
        WTFile *file = [self.arr_imgs objectAtIndex:tag - 1];
        NSString  *originalPath = [NSFileManager absoluteFilePathForMedia:file];
        [photoView setImage:[UIImage imageWithContentsOfFile:originalPath]];
    } else if (self.isViewEvents) {
        WTFile *file = [self.arr_events objectAtIndex:tag - 1];
        NSData *data = [MediaProcessing getMediaForEvent:file.fileid withExtension:file.ext];
        if (data) {
            [photoView setImage:[UIImage imageWithData:data]];
        }
    }
}

-(void)didGetFullResolutionPhoto:(NSNotification*)notif
{
    
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSInteger imageindex = [[[notif userInfo] valueForKey:@"showingorder"] integerValue];
        
        if (imageindex  != self.startpos) {
            return;
        }
        [self refreshScrollViewWithTag:(int)imageindex + 1];
        
    }
    
}

-(void)getBuddyPhoto:(NSNotification*)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.buddy = [Database buddyWithUserID:self.buddy.userID];
        [self refreshScrollViewWithTag:TAG_PHOTOVIEW_SINGLE];
    }
}

-(void)getGroupPhoto:(NSNotification*)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        self.group = [Database getFixedGroupByID:self.group.groupID];
        [self refreshScrollViewWithTag:TAG_PHOTOVIEW_SINGLE];
    }
}

-(void)didDownloadOriginalPhoto:(NSNotification*)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        ChatMessage* msg = [[notif userInfo] valueForKey:WT_MESSAGE];
        int index = [self indexForMessage:msg];
        if (index != -1) {
            ChatMessage* oldmsg = (ChatMessage*)[self.arr_msgs objectAtIndex:index];
            oldmsg.pathOfMultimedia = msg.pathOfMultimedia;
            [self refreshScrollViewWithTag:index + 1];
        }
    }
    
}

- (void)didDownloadImageForEvent:(NSNotification *)notif
{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        int imageindex = [[[notif userInfo] valueForKey:@"showingorder"] intValue];
        
        if (imageindex  != self.startpos) {
            return;
        }
        [self refreshScrollViewWithTag:imageindex + 1];
        
    }
}


-(int)indexForMessage:(ChatMessage*)msg
{
    
    for (int i = 0; i< [self.arr_msgs count] ; i++) {
        ChatMessage* oldmsg = (ChatMessage*)[self.arr_msgs objectAtIndex:i];
        if (oldmsg.primaryKey == msg.primaryKey) {
            return i;
        }
    }
    return -1;
}

# pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.sv_container.frame.size.width;
    int page = floor((self.sv_container.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_currentPage == 0) {
        
    }
    if (_currentPage == 1) {
    }
}


@end