//
//  UIImage+Resize.h
//  omim
//
//  Created by coca on 2012/10/17.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)


- (UIImage*) resizeToSize:(CGSize)targetSize;

- (UIImage*) resizeToSqaureSize:(CGSize)targetSize;  // crop a square from the images;

- (CGRect)  calculateSqaureCropRect;

- (CGRect) calculateSqaureCropRectForThumbnail;

- (CGSize) calculateTheScaledSize:(CGSize)originalSize withMaxSize:(CGSize)maxSize;




@end
