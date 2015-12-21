//
//  GalleryPhotoView.h
//  dev01
//
//  Created by jianxd on 14-12-5.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryPhotoView : UIScrollView <UIScrollViewDelegate>{
    CGFloat initialOffset;
    
    BOOL _isZoomed;
}

@property (nonatomic,retain) UIImage* image;
@property (nonatomic,retain) UIImageView* imageview;


- (void)resetZoom;
@end
