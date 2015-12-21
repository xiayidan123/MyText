//
//  OMAlbumBrowseManager.m
//  dev01
//
//  Created by 杨彬 on 15/4/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMAlbumBrowseManager.h"
#import "OMViewState.h"
#import "OMAlbumBrowseCell.h"
#import "AppDelegate.h"
#import "PublicFunctions.h"
@interface OMAlbumBrowseManager ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (retain, nonatomic)NSArray *state_array;

@property (retain, nonatomic)UICollectionView *collection_view;

@property (assign, nonatomic)BOOL collectionView_showcontent;


@end



@implementation OMAlbumBrowseManager

-(void)dealloc{
    self.state_array = nil;
    self.collection_view = nil;
    [super dealloc];
}


+ (id)sharedManager{
    static OMAlbumBrowseManager *_m = nil;
    if (!_m){
        _m = [[OMAlbumBrowseManager alloc]init];
    }
    return _m;
}

- (void)showWithState:(NSArray *)state_array withIndex:(NSIndexPath *)indexPath{
    self.state_array = state_array;
    self.collectionView_showcontent = NO;
    if (self.collection_view == nil){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        UICollectionView *collection_view = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        [layout release];
        collection_view.dataSource = self;
        collection_view.delegate = self;
        collection_view.backgroundColor = [UIColor blackColor];
        collection_view.collectionViewLayout = layout;
        collection_view.pagingEnabled = YES;
        collection_view.alwaysBounceHorizontal = YES;
        collection_view.showsHorizontalScrollIndicator = NO;
        [collection_view registerNib:[UINib nibWithNibName:@"OMAlbumBrowseCell" bundle:nil] forCellWithReuseIdentifier:@"OMAlbumBrowseCell"];
        self.collection_view = collection_view;
        [collection_view release];
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    self.collection_view.alpha = 0;
    [window addSubview:self.collection_view];
    
    
    OMViewState *state = self.state_array[indexPath.row];
    UIImageView *imageview = (UIImageView *)state.original_view;
    const CGFloat fullW = window.frame.size.width;
    const CGFloat fullH = window.frame.size.height;
    
    CGRect rect = [window convertRect:imageview.frame fromView:imageview.superview];
    [state.superview addSubview:imageview];
    imageview.hidden = YES;
    UIImageView *mirror_imageView = [[UIImageView alloc]initWithFrame:rect];
    mirror_imageView.contentMode = UIViewContentModeScaleAspectFill;
    mirror_imageView.image = imageview.image;
    
    [window addSubview:mirror_imageView];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.collection_view.alpha = 1;
        mirror_imageView.transform = CGAffineTransformIdentity;
        CGSize size = (mirror_imageView.image) ? mirror_imageView.image.size
        : mirror_imageView.frame.size;
        CGFloat ratio = MIN(fullW / size.width, fullH / size.height);
        CGFloat W = ratio * size.width;
        CGFloat H = ratio * size.height;
        mirror_imageView.frame = CGRectMake((fullW - W) / 2, (fullH - H) / 2, W, H);
    }completion:^(BOOL finished) {
        [mirror_imageView removeFromSuperview];
        [mirror_imageView release];
        self.collectionView_showcontent = YES;
        [self.collection_view reloadData];
        self.collection_view.contentOffset = CGPointMake(indexPath.row * fullW, 0);
        imageview.hidden = NO;
    }];
}


+ (void)endShow{
    
    
}


#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OMAlbumBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OMAlbumBrowseCell" forIndexPath:indexPath];
    OMViewState *state = self.state_array[indexPath.row];
    cell.photo_imageView.image = ((UIImageView *)state.original_view).image;
    cell.moment_id = state.moment_id;
    cell.file = state.file;
    cell.photo_imageView.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.collectionView_showcontent){
        return self.state_array.count;
    }else{
        return 0;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OMAlbumBrowseCell *cell = (OMAlbumBrowseCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imageview = cell.photo_imageView;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    OMViewState *state = self.state_array[indexPath.row];
    CGRect rect = [window convertRect:imageview.frame fromView:imageview.superview];
    
    UIImageView *mirror_imageView = [[UIImageView alloc]initWithFrame:rect];
    mirror_imageView.image = imageview.image;
    mirror_imageView.contentMode = UIViewContentModeScaleAspectFit;
    [window addSubview:mirror_imageView];
    state.original_view.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.collection_view.alpha = 0;
        mirror_imageView.frame = [window convertRect:state.frame fromView:state.superview];
        mirror_imageView.transform = state.transform;
    }completion:^(BOOL finished) {
        [mirror_imageView removeFromSuperview];
        mirror_imageView.image = nil;
        [mirror_imageView release];
        [self.collection_view removeFromSuperview];
        self.collection_view = nil;
        state.original_view.hidden = NO;
    }];
}








@end
