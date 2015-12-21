//
//  NewCameraVC.m
//  dev01
//
//  Created by Huan on 15/3/25.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "NewCameraVC.h"
#import "WTHeader.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Constants.h"
@interface NewCameraVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation NewCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (BOOL)startCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
//        self.imagePath = [NSFileManager randomRelativeFilePathInDir:dirName ForFileExtension:JPG];
//        self.thumbnailPath = [NSFileManager randomRelativeFilePathInDir:dirName ForFileExtension:JPG];
//        
        UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
        
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagepicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        imagepicker.videoMaximumDuration = 10;
        imagepicker.delegate = self;
        self.mmtType = MMT_UNKNOWN;
        
        imagepicker.showsCameraControls = TRUE;
        
        [self presentViewController:imagepicker animated:YES completion:nil];
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        [imagepicker release];
        
        return YES;
    }
    else
    {
        return NO;
    }
    
    return  NO;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        // get the image and save it
        self.mmtType = MMT_PHOTO;
        
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        
        CGSize targetSize;
        CGSize targetSizeThumbnail;
        
        UIImage *scaledImage;
        UIImage* thumbnailImage;
        
        if (self.needCropping)
        {
            
            if (image.size.height>image.size.width)
            {
                targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.width, image.size.width) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
            }
            else
            {
                targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.height, image.size.height) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
            }
            
            scaledImage = [image resizeToSqaureSize:targetSize];
            
            targetSizeThumbnail = [scaledImage calculateTheScaledSize:CGSizeMake(scaledImage.size.width, scaledImage.size.height) withMaxSize: self.maxThumbnailSize];
            
            thumbnailImage = [image resizeToSqaureSize:targetSizeThumbnail];
            
        }
        
        else
        {
            targetSize = [image calculateTheScaledSize:CGSizeMake(image.size.width, image.size.height) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
            
            scaledImage = [image resizeToSize:targetSize];
            
            targetSizeThumbnail = [scaledImage calculateTheScaledSize:CGSizeMake(scaledImage.size.width, scaledImage.size.height) withMaxSize: self.maxThumbnailSize];
            
            thumbnailImage = [image resizeToSize:targetSizeThumbnail];
        }
        
        
        //   NSLog(@"scaled image size width: %f, height: %f", scaledImage.size.width, scaledImage.size.height);
        //  NSLog(@"scaled thumbnail size width: %f, height: %f", thumbnailImage.size.width, thumbnailImage.size.height);
        
        NSData * data = [NSData dataWithData:UIImageJPEGRepresentation(scaledImage, 1.0f)];//1.0f = 100% quality
        
        [data writeToFile:[NSFileManager absolutePathForFileInDocumentFolder:self.imagePath] atomically:YES];
        
        NSData * data2 = [NSData dataWithData:UIImageJPEGRepresentation(thumbnailImage, 1.0f)];  //1.0f = 100% quality
        
        [data2 writeToFile: [NSFileManager absolutePathForFileInDocumentFolder:self.thumbnailPath] atomically:YES];
        
        [self.delegate getDataFromCamera:self];
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        /*
         if([self.parent isKindOfClass:[MsgComposerVC class]])
         {
         [(MsgComposerVC*)self.parent uv_barcontainer].hidden = NO;
         }
         */
    }
    
    
}


@end
