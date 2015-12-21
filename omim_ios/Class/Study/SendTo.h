//
//  SendTo.h
//  dev01
//
//  Created by Huan on 15/3/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendTo : UIViewController
@property (retain, nonatomic) UIImage *homeworkIMG;
@property (retain, nonatomic) UIImage *homeworkThumnailIMG;
@property (copy, nonatomic) NSString *dirName;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *thumbnailPath;
@property (retain, nonatomic) NSArray *imageDataArray;
@property (nonatomic,assign) CGSize maxThumbnailSize;
@end
