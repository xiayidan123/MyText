//
//  homeworkPhotosView.m
//  dev01
//
//  Created by Huan on 15/7/30.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//  多个照片View

#import "homeworkPhotosView.h"
#import "WTFile.h"
#import "YBPhotoModel.h"
#import "checkPhotoView.h"
#import "OMViewState.h"
#import "OMAlbumBrowseManager.h"
#define HWStatusPhotoWH 80
#define TeachersPhotoWH 80
#define HWStatusPhotoMargin 10
#define HWStatusPhotoMaxCol(count) (3)

@interface homeworkPhotosView()<checkPhotoViewDelegate>

@property (retain, nonatomic) UIView * bottomLineView;

@property (retain, nonatomic) NSMutableArray * photo_model_array;

@property (retain, nonatomic) NSMutableArray * photo_view_array;

@property (retain, nonatomic) NSMutableArray * photo_state_arry;
@end

@implementation homeworkPhotosView


- (void)dealloc{
    self.bottomLineView = nil;
    self.photos = nil;
    self.photo_model_array = nil;
    self.photo_view_array = nil;
    self.moment_id = nil;
    self.photo_state_arry = nil;
    [super dealloc];
}

- (void)setPhotos:(NSArray *)photos
{
    [_photos release],_photos = nil;
    _photos = [photos retain];
    
    if (_photos == nil )return;
    
    int photosCount = photos.count;
    
//    for (int i = 0; i < photosCount; i++) {
//        WTFile *file = photos[i];
//        YBPhotoModel *photo_model = [[YBPhotoModel alloc] init];
//        photo_model.image_obj = file;
//        [self.photo_model_array addObject:photo_model];
//        [photo_model release];
//    }
    NSMutableArray *photo_state_arry = [[[NSMutableArray alloc]init] autorelease];
    for (int i = 0; i < photosCount; i++) {
        OMViewState *state = [[OMViewState alloc] init];
        state.file = photos[i];
        state.moment_id = self.moment_id;
        [photo_state_arry addObject:state];
        [state release];
    }
    self.photo_model_array = photo_state_arry;
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    // 图片个数
    NSUInteger photo_model_count = self.photo_model_array.count;
    // 控件个数
    NSUInteger photo_view_count = self.photo_view_array.count;
    
    NSUInteger count = photo_model_count > photo_view_count ? photo_model_count : photo_view_count ;
    
    CGFloat inset = HWStatusPhotoMargin;
    
    CGFloat width = HWStatusPhotoWH;
    CGFloat height = width;
    
    for (int i = 0; i < count; i++) {
        checkPhotoView *photoView = nil;
        WTFile *photo = nil;
        if (i >= photo_model_count){// 控件有多
            photoView = self.photo_view_array[i];
            photoView.hidden = YES;
        }else if (i >= photo_view_count){// 控件不足 创建新控件
            photoView = [[checkPhotoView alloc] init];
            photoView.delegate = self;
            photo = self.photos[i];
            [self addSubview:photoView];
            [self.photo_view_array addObject:photoView];
            [photoView release];
        }else{
            photoView = self.photo_view_array[i];
            photoView.hidden = NO;
            photo = self.photos[i];
        }
        
        photoView.file = photo;
        
        OMViewState *state = self.photo_model_array[i];
        if (state.file == photoView.file){
            [state setStateWithView:photoView];
        }
        // 排控件的位置
        photoView.width = width;
        photoView.height = height;
        
        photoView.x = (width + inset) * (i%3);
        photoView.y = (height + inset) * (i/3);
        
        photoView.tag = i;
        
    }
    self.bottomLineView.height = 0.5;
    
}


+ (CGSize)sizeWithCount:(int)count isTeacher:(BOOL)isTeacher
{
    if (isTeacher) {
        // 最大列数（一行最多有多少列）
        int maxCols = HWStatusPhotoMaxCol(count);
        
        int cols = (count >= maxCols)? maxCols : count;
        CGFloat photosW = cols * TeachersPhotoWH + (cols - 1) * HWStatusPhotoMargin;
        
        // 行数
        int rows = (count + maxCols - 1) / maxCols;
        CGFloat photosH = rows * TeachersPhotoWH + (rows - 1) * HWStatusPhotoMargin;
        
        return CGSizeMake(photosW, photosH);
    }else{
        // 最大列数（一行最多有多少列）
        int maxCols = HWStatusPhotoMaxCol(count);
        
        int cols = (count >= maxCols)? maxCols : count;
        CGFloat photosW = cols * HWStatusPhotoWH + (cols - 1) * HWStatusPhotoMargin;
        
        // 行数
        int rows = (count + maxCols - 1) / maxCols;
        CGFloat photosH = rows * HWStatusPhotoWH + (rows - 1) * HWStatusPhotoMargin;
        
        return CGSizeMake(photosW, photosH);
    }
}


#pragma mark - Set and Get

-(NSMutableArray *)photo_model_array{
    if (_photo_model_array == nil){
        _photo_model_array = [[NSMutableArray alloc]init];
    }
    return _photo_model_array;
}


-(NSMutableArray *)photo_view_array{
    if (_photo_view_array == nil){
        _photo_view_array = [[NSMutableArray alloc]init];
    }
    return _photo_view_array;
}


- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(-15, CGRectGetMaxY(self.bounds) + 15, [UIScreen mainScreen].bounds.size.width, 0.5)];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_bottomLineView];
    }
    return _bottomLineView;
}

- (NSMutableArray *)photo_state_arry{
    if (!_photo_model_array) {
        _photo_model_array = [[NSMutableArray alloc] init];
    }
    return _photo_model_array;
}


- (void)checkPhotoView:(checkPhotoView *)checkPhotoView{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:checkPhotoView.tag inSection:0];
    [[OMAlbumBrowseManager sharedManager] showWithState:self.photo_model_array withIndex:indexPath];
}
@end
