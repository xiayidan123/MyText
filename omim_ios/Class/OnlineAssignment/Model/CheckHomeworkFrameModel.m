//
//  CheckHomeworkFrameModel.m
//  dev01
//
//  Created by Huan on 15/7/30.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "CheckHomeworkFrameModel.h"
#import "NewhomeWorkModel.h"
#import "homeworkPhotosView.h"
#import "NSString+TextSize.h"

@implementation CheckHomeworkFrameModel

- (void)dealloc{
    self.homeworkModel = nil;
    [super dealloc];
}
- (void)setHomeworkModel:(NewhomeWorkModel *)homeworkModel{
    if (_homeworkModel != homeworkModel) {
        [_homeworkModel release];
        _homeworkModel = [homeworkModel retain];
        
        //整体宽度
        CGFloat orignalWidth = [UIScreen mainScreen].bounds.size.width;
        NSInteger count = _homeworkModel.homework_moment.multimedias.count;
        NSInteger length = _homeworkModel.homework_moment.text.length;
        if (count) {//有配图
            //照片View的宽度
            CGSize photosViewSize = [homeworkPhotosView sizeWithCount:(int)count isTeacher:NO];
            CGFloat photosViewX = Margin;
            CGFloat photosViewY = Margin;
            self.photoViewFrame = (CGRect){{photosViewX,photosViewY},photosViewSize};
            if (length) {//有配图有标题
                CGFloat contentX = photosViewX;
                CGFloat contentY = CGRectGetMaxY(self.photoViewFrame) + Margin * 2;
                CGFloat maxW = orignalWidth - Margin;
                CGSize contentSize = [_homeworkModel.homework_moment.text sizeWithFont:ContentFont maxW:maxW];
                self.contentLabelFrame = (CGRect){{contentX,contentY},contentSize};
                self.checkViewHeight = CGRectGetMaxY(self.contentLabelFrame) + Margin;
            }else{//有配图无标题
                self.checkViewHeight = CGRectGetMaxY(self.photoViewFrame) + Margin;
            }
        }else{//无配图有标题
            
            CGFloat contentX = Margin;
            CGFloat contentY = Margin;
            CGFloat maxW = orignalWidth - Margin;
            CGSize contentSize = [_homeworkModel.homework_moment.text sizeWithFont:ContentFont maxW:maxW];
            self.contentLabelFrame = (CGRect){{contentX,contentY},contentSize};
            self.checkViewHeight = CGRectGetMaxY((CGRect){{contentX,contentY},contentSize}) + Margin;
        }
    }
    
}
@end
