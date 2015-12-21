//
//  ActivityPhotoViewController.m
//  dev01
//
//  Created by 杨彬 on 14-11-26.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "ActivityPhotoViewController.h"
#import "PublicFunctions.h"
#import "WTHeader.h"
#import "Constants.h"

@interface ActivityPhotoViewController ()
{
    UIScrollView *_scrollView_Photo;
    UIPageControl *_pageControl;
}

@end


@implementation ActivityPhotoViewController

-(void)dealloc{
    [_pageControl release],_pageControl = nil;
    [_scrollView_Photo release],_scrollView_Photo = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:NO];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self configNavigationBar];
    
    [self loadPhotoScrollView];
    
    [self loadPageControl];
}


-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDownloadThumbImage:) name:@"download_event_multimedia" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configNavigationBar{
    UILabel *titleLabel = [[[UILabel alloc]init] autorelease];
    titleLabel.text = NSLocalizedString(@"Photo",nil);
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backBarItem = [PublicFunctions getCustomNavButtonOnLeftSide:YES target:self image:[UIImage imageNamed:@"icon_back_white"] selector:@selector(backAction)];
    [self.navigationItem addLeftBarButtonItem:backBarItem];
    
    UIBarButtonItem *rightbutton = [PublicFunctions getCustomNavButtonOnLeftSide:NO target:self image:[UIImage imageNamed:NAV_DOWNLOAD_IMAGE] selector:@selector(savePhoto)];
    [self.navigationItem addRightBarButtonItem:rightbutton];
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)savePhoto{
    UIImageView *photoView = (UIImageView *)[_scrollView_Photo viewWithTag:300 + _pageControl.currentPage];
    
    UIImageWriteToSavedPhotosAlbum(photoView.image, nil, nil,nil);
}


- (void)loadPhotoScrollView{
    _scrollView_Photo = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView_Photo.contentSize = CGSizeMake(self.view.bounds.size.width * (_activityModel.mediaArray.count - 1), 0);
    _scrollView_Photo.pagingEnabled = YES;
    _scrollView_Photo.delegate = self;
    _scrollView_Photo.showsHorizontalScrollIndicator = NO;
    _scrollView_Photo.contentOffset = CGPointMake(self.view.bounds.size.width * (_indexOfPhoto - 1), 0);
    [self.view addSubview:_scrollView_Photo];
    
    for (int i=1 ;i<_activityModel.mediaArray.count; i++){
        NSString *filePath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@.%@",[_activityModel.mediaArray[i] fileid],[_activityModel.mediaArray[i] ext]] WithSubFolder:@"eventmedia"]];
        BOOL isDirectory;
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (exist && !isDirectory){
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:filePath];
            CGFloat _w;
            CGFloat _h;
            if (image.size.width / image.size.height > ((self.view.bounds.size.width - 20)/(self.view.bounds.size.height - 84))){
                _w = self.view.bounds.size.width - 20;
                _h = (self.view.bounds.size.width - 20)/image.size.width*image.size.height;
            }else{
                _h = self.view.bounds.size.height - 84;
                _w = (self.view.bounds.size.height - 84)/image.size.height*image.size.width;
            }
            UIImageView *photoView = (UIImageView *)[_scrollView_Photo viewWithTag:100+i];
            if (!photoView){
                photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _w, _h)];
                photoView.tag = 300 + i;
                [_scrollView_Photo addSubview:photoView];
                [photoView release];
            }
            photoView.frame = CGRectMake(0, 0, _w, _h);
            photoView.center = CGPointMake(self.view.bounds.size.width / 2 + self.view.bounds.size.width * (i-1), _scrollView_Photo.center.y - 32);
            photoView.image = image;

            [image release];
            
        }
        else {
            [WowTalkWebServerIF getEventMedia:_activityModel.mediaArray[i] isThumb:NO showingOrder:5000 withCallback:@selector(didDownloadImage:) withObserver:self];
            
            NSString *fileThumbPath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@.%@",[_activityModel.mediaArray[i] thumbnailid],[_activityModel.mediaArray[i] ext]] WithSubFolder:@"eventmedia"]];
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:fileThumbPath];
            
            if (image == nil || image.size.width == 0 || image.size.height == 0){
                image = [UIImage imageNamed:@"events_default_pic.png"];
            }
            
            CGFloat _w;
            CGFloat _h;
            if (image.size.width / image.size.height > ((self.view.bounds.size.width - 20)/(self.view.bounds.size.height - 84))){
                _w = self.view.bounds.size.width - 20;
                _h = (self.view.bounds.size.width - 20)/image.size.width*image.size.height;
            }else{
                _h = self.view.bounds.size.height - 84;
                _w = (self.view.bounds.size.height - 84)/image.size.height*image.size.width;
            }
            UIImageView *photoView = (UIImageView *)[_scrollView_Photo viewWithTag:100+i];
            if (!photoView){
                photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _w, _h)];
            }
            photoView.frame = CGRectMake(0, 0, _w, _h);
            photoView.center = CGPointMake(self.view.bounds.size.width / 2 + self.view.bounds.size.width * (i-1), _scrollView_Photo.center.y - 32);
            photoView.image = image;
            photoView.tag = 300 + i;
            [image release];
            [_scrollView_Photo addSubview:photoView];
            [photoView release];
            
        }
    }
}


- (void)didDownloadImage:(NSNotification *)notif{
    NSString *fileName = [[notif userInfo] objectForKey:@"fileName"];
    for (int i=1; i<_activityModel.mediaArray.count; i++){
        if ([[_activityModel.mediaArray[i] fileid] isEqualToString:fileName]){
            NSString *relativefilepath = [NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@.%@",fileName,[_activityModel.mediaArray[i] ext]] WithSubFolder:@"eventmedia"];
            NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:relativefilepath];
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:absolutepath];
            if (image == nil || image.size.width == 0|| image.size.height == 0){
                image = [UIImage imageNamed:@"events_default_pic.png"];
            }
            CGFloat _w;
            CGFloat _h;
            if (image.size.width / image.size.height > ((_scrollView_Photo.bounds.size.width - 20)/(_scrollView_Photo.bounds.size.height - 84))){
                _w = _scrollView_Photo.bounds.size.width - 20;
                _h = (_scrollView_Photo.bounds.size.width - 20)/image.size.width*image.size.height;
            }else{
                _h = _scrollView_Photo.bounds.size.height - 84;
                _w = (_scrollView_Photo.bounds.size.height - 84)/image.size.height*image.size.width;
            }
            UIImageView *photoView = (UIImageView *)[_scrollView_Photo viewWithTag:300+i];
            photoView.frame = CGRectMake(0, 0, _w, _h);
            photoView.center = CGPointMake(self.view.bounds.size.width / 2 + self.view.bounds.size.width * (i-1), _scrollView_Photo.center.y - 32);
            photoView.image = image;
            [image release];
        }
    }
}

- (void)didDownloadThumbImage:(NSNotification *)notif{
    NSString *fileName = [[notif userInfo] objectForKey:@"fileName"];
    for (int i=1; i<_activityModel.mediaArray.count; i++){
        if ([[_activityModel.mediaArray[i] thumbnailid] isEqualToString:fileName]){
            NSString *relativefilepath = [NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@.%@",[_activityModel.mediaArray[i] fileid],[_activityModel.mediaArray[i] ext]] WithSubFolder:@"eventmedia"];
            NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:relativefilepath];
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:absolutepath];
            if (image == nil || image.size.width == 0|| image.size.height == 0){
                relativefilepath = [NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@.%@",[_activityModel.mediaArray[i] thumbnailid],[_activityModel.mediaArray[i] ext]] WithSubFolder:@"eventmedia"];
                image = [[UIImage alloc]initWithContentsOfFile:absolutepath];
                if (image == nil || image.size.width == 0|| image.size.height == 0){
                    image = [UIImage imageNamed:@"events_default_pic.png"];
                }
            }
            CGFloat _w;
            CGFloat _h;
            if (image.size.width / image.size.height > ((_scrollView_Photo.bounds.size.width - 20)/(_scrollView_Photo.bounds.size.height - 84))){
                _w = _scrollView_Photo.bounds.size.width - 20;
                _h = (_scrollView_Photo.bounds.size.width - 20)/image.size.width*image.size.height;
            }else{
                _h = _scrollView_Photo.bounds.size.height - 84;
                _w = (_scrollView_Photo.bounds.size.height - 84)/image.size.height*image.size.width;
            }
            UIImageView *photoView = (UIImageView *)[_scrollView_Photo viewWithTag:300+i];
            photoView.frame = CGRectMake(0, 0, _w, _h);
            photoView.center = CGPointMake(self.view.bounds.size.width / 2 + self.view.bounds.size.width * (i-1), _scrollView_Photo.center.y - 32);
            photoView.image = image;
            [image release];
        }
    }
}



- (void)loadPageControl{
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.center = CGPointMake(self.view.center.x, self.view.bounds.size.height / 10 * 8);
    [self.view addSubview:_pageControl];
    _pageControl.numberOfPages = _activityModel.mediaArray.count - 1;
    _pageControl.enabled = NO;
    _pageControl.currentPage = _indexOfPhoto - 1;
}


#pragma mark-----UIScrollView
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    _pageControl.currentPage = page;
}


@end
