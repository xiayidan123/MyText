//
//  ImageScrollView.m
//  dev01
//
//  Created by jianxd on 13-12-2.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "ImageScrollView.h"
#import "MediaProcessing.h"
#import "WowTalkWebServerIF.h"
#import "WTFile.h"
#import "WTError.h"
#import "Constants.h"

#define INDICATOR_VIEW_TAG          11

@interface ImageScrollView()

@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) CGFloat imageWidth;
@property (retain, nonatomic) NSMutableArray *imageArray;
@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UIPageControl *pageControl;

@end

@implementation ImageScrollView

@synthesize currentPageIndex = _currentPageIndex;
@synthesize imageWidth = _imageWidth;
@synthesize imageArray = _imageArray;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

- (id)initWithFrame:(CGRect)frame imageWidth:(CGFloat)width imageArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageWidth = width;
        self.imageArray = [[NSMutableArray alloc] initWithArray:array];
        self.userInteractionEnabled = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.pagingEnabled = YES;
        NSInteger imageCount = [self.imageArray count];
        self.scrollView.contentSize = CGSizeMake(frame.size.width * imageCount, frame.size.height);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.delegate = self;
        for (int i = 0; i < imageCount; i++) {
            WTFile *file = [self.imageArray objectAtIndex:i];
            NSData *data = [MediaProcessing getMediaForEvent:file.thumbnailid withExtension:file.ext];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width * i, 0, frame.size.width, frame.size.height)];
            [imageView setImage:[UIImage imageNamed:@"default_pic.png"]];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                [imageView setImage:image];
            } else {
                UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((frame.size.width - 40) / 2,
                                                                                                                   (frame.size.height - 40) / 2,
                                                                                                                   (frame.size.width - 40) / 2 + 40,
                                                                                                                   (frame.size.height - 40) / 2 + 40)];
                indicatorView.tag = INDICATOR_VIEW_TAG;
                [imageView addSubview:indicatorView];
                [indicatorView startAnimating];
                [indicatorView release];
                [WowTalkWebServerIF getEventMedia:file isThumb:YES showingOrder:i withCallback:@selector(didDownloadFile:) withObserver:self];
            }
            imageView.tag = i;
            [self.scrollView addSubview:imageView];
            [imageView release];
        }
        [self addSubview:self.scrollView];
        
        // set the page control
        UIPageControl *control = [[UIPageControl alloc] init];
        control.numberOfPages = imageCount;
        control.currentPage = 0;
        control.hidesForSinglePage = YES;
        CGFloat controlWidth = [control sizeForNumberOfPages:imageCount].width;
        control.frame = CGRectMake(frame.size.width - controlWidth - 10, frame.size.height - 20, controlWidth, 20);
        [self addSubview:control];
        self.pageControl = control;
        [control release];
    }
    return self;
}

- (void)didDownloadFile:(NSNotification *)notification
{
    NSInteger index = [[[notification userInfo] objectForKey:@"showingorder"] integerValue];
    UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:index];
    UIView *view = [imageView viewWithTag:INDICATOR_VIEW_TAG];
    if (view) {
        [view removeFromSuperview];
    }
    WTFile *file = [self.imageArray objectAtIndex:index];
    NSData *data = [MediaProcessing getMediaForEvent:file.thumbnailid withExtension:file.ext];
    if (data) {
        imageView.image = [UIImage imageWithData:data];
    }
    NSError *error = [[notification userInfo] objectForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _currentPageIndex = page;
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if (_currentPageIndex == 0) {
//        [self.scrollView setContentOffset:CGPointMake(([self.imageArray count] - 2) * self.scrollView.frame.size.width, 0)];
//    }
//    if (_currentPageIndex == [self.imageArray count] - 1) {
//        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
//    }
}

- (void)dealloc
{
    [_imageArray release];
    [_scrollView release];
    [_pageControl release];
    [super dealloc];
}

@end
