//
//  UIImage+Resize.m
//  omim
//
//  Created by coca on 2012/10/17.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//


#import "UIImage+Resize.h"

#define radians( degrees ) ( degrees * M_PI / 180 )

@implementation UIImage (Resize)

- (UIImage*)resizeToSize:(CGSize)targetSize
{
    UIImage* sourceImage = self;
    
    
    // source image too small, return.
    if(sourceImage.size.width<targetSize.width && sourceImage.size.height<targetSize.height) return sourceImage;
    
    
    // UIImage* sourceImage = self;
    CGFloat targetWidth;
    CGFloat targetHeight;
    
    
    //   CGImageRef imageRef = [sourceImage CGImage];
    
    CGImageRef imageRef = [sourceImage CGImage];
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        
        targetWidth = targetSize.width;
        targetHeight = targetSize.height;
        
        bitmap = CGBitmapContextCreate(NULL, targetSize.width, targetSize.height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    else {
        
        targetWidth = targetSize.height;
        targetHeight = targetSize.width;
        
        bitmap = CGBitmapContextCreate(NULL, targetSize.width, targetSize.height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetSize.width, targetSize.height), imageRef);
        
        
    }
    else
    {
        
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetSize.height, targetSize.width), imageRef);
        
    }
    
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;

}

-(UIImage*)resizeToSqaureSize:(CGSize)targetSize
{
    
    UIImage* sourceImage = self;
    
    CGRect cropRect = [self calculateSqaureCropRect];
    
    // source image too small, return.
    if(sourceImage.size.width<targetSize.width && sourceImage.size.height<targetSize.height) return sourceImage;
    
    
    // UIImage* sourceImage = self;
    CGFloat targetWidth;
    CGFloat targetHeight;
    
    
    //   CGImageRef imageRef = [sourceImage CGImage];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([sourceImage CGImage], cropRect);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        
        targetWidth = targetSize.width;
        targetHeight = targetSize.height;
        
        bitmap = CGBitmapContextCreate(NULL, targetSize.width, targetSize.height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    else {
        
        targetWidth = targetSize.height;
        targetHeight = targetSize.width;
        
        bitmap = CGBitmapContextCreate(NULL, targetSize.width, targetSize.height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetSize.width, targetSize.height), imageRef);
        
        
    }
    else
    {
        
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetSize.height, targetSize.width), imageRef);
        
    }
    
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    CGImageRelease(imageRef);
    return newImage;

}


- (CGRect) calculateSqaureCropRect
{
   
    CGImageRef originalImageRef = [self CGImage];
    
    size_t originalImagewidth =CGImageGetWidth(originalImageRef);
    size_t originalImageHeight = CGImageGetHeight(originalImageRef);
    
//    NSLog(@"originalimage width: %zu, height: %zu", originalImagewidth, originalImageHeight);
    
    CGRect cropRect;
    
    // change the crop value.  It works only when we try to keep the width and height relationship. Means when its height is larger than its width, it will be the same after the crop.

        if (originalImageHeight > originalImagewidth){
            cropRect = CGRectMake(0, (originalImageHeight-originalImagewidth)/2, originalImagewidth, originalImagewidth);
        }
        
        else{
            cropRect = CGRectMake((originalImagewidth-originalImageHeight)/2, 0, originalImageHeight, originalImageHeight);
        }
        
    
  //  NSLog(@"recalculated crop: %f,  %f, %f, %f", cropRect.origin.x, cropRect.origin.y, cropRect.size.width,cropRect.size.height);
    //  CGImageRelease(originalImageRef);
    
    return cropRect;
}



-(CGSize) calculateTheScaledSize:(CGSize)originalSize withMaxSize:(CGSize)maxSize
{
    // if too small, return to the originalsize;
    if (originalSize.height< maxSize.height && originalSize.width<maxSize.width)
    {
        return originalSize;
    }
    
    CGSize scaledSize = maxSize;
    
    CGFloat aspectRatio = originalSize.width / originalSize.height;
    
    CGFloat width;
    CGFloat height;
    
    if (scaledSize.width / aspectRatio <= scaledSize.height) {
        width = scaledSize.width;
        height = width / aspectRatio;
    }
    else
    {
        height = scaledSize.height;
        width = height * aspectRatio;
    }
    
    
    return CGSizeMake(width, height);
}



@end
