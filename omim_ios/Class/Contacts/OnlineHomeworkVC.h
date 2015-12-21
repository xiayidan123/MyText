//
//  OnlineHomeworkVC.h
//  dev01
//
//  Created by Huan on 15/3/24.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ParentChatRoomVC.h"
#import "OnlineHomeViewController.h"
#import "PersonModel.h"
@interface OnlineHomeworkVC : UIViewController
@property (nonatomic, retain) OnlineHomeViewController *schoolVC;
@property (retain, nonatomic) UIImage *homeworkIMG;
@property (retain, nonatomic) UIImage *homeworkThumnailIMG;
@property (copy, nonatomic) NSString *dirName;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *thumbnailPath;
@property (nonatomic, assign) CGSize maxThumbnailSize;
@end
