//
//  ParentsOpinionDetailView.m
//  dev01
//
//  Created by 杨彬 on 15-1-1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ParentsOpinionDetailView.h"
#import "WTHeader.h"

@interface ParentsOpinionDetailView ()


@end


@implementation ParentsOpinionDetailView


- (void)dealloc {
    [_parentsOpinonModel release];
    [_lab_title release];
    [_btn_audio release];
    [_view_line1 release];
    [_view_line2 release];
    
    self.parentsOpinonModel = nil;
    [super dealloc];
}




-(void)setParentsOpinonModel:(Moment *)parentsOpinonModel{
    _btn_audio.hidden = YES;
    _parentsOpinonModel = [parentsOpinonModel retain];
    _btn_audio.layer.cornerRadius = 5;
    _btn_audio.layer.borderWidth = 1;
    _btn_audio.layer.borderColor = [UIColor colorWithRed:140.0/255 green:140.0/255 blue:140.0/255 alpha:1].CGColor;
    _btn_audio.layer.masksToBounds = YES;
    
    
    _lab_title.text = _parentsOpinonModel.text;
    _lab_title.numberOfLines = 0;
    _lab_title.font = [UIFont systemFontOfSize:16];
    
    
    CGRect rect = [_lab_title.text boundingRectWithSize:CGSizeMake(_lab_title.bounds.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:nil];
    if (rect.size.height <49){
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 49);
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _lab_title.frame.origin.y + rect.size.height + 100);
    _view_line1.center = CGPointMake(self.bounds.size.width /2 ,_view_line1.center.y + rect.size.height -44 );
    _view_line2.center = CGPointMake(self.bounds.size.width /2 ,_view_line2.center.y + rect.size.height -44 );
    _lab_title.frame = CGRectMake(_lab_title.frame.origin.x, _lab_title.frame.origin.y, _lab_title.frame.size.width, rect.size.height );
    [self loadGalleryView];
}




- (void)loadGalleryView{
    CGFloat height = 0;
    if (self.parentsOpinonModel.multimedias.count != 0){
        height = 75;
        self.view_line2.hidden = NO;
    }else{
        self.view_line2.hidden = YES;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - height);
    }
    
    UIScrollView *scrollView_Image = [[UIScrollView alloc]initWithFrame:CGRectMake(16, 14.5 + _lab_title.frame.origin.y + _lab_title.frame.size.height, self.bounds.size.width - 32, height)];
    scrollView_Image.tag = 220;
    scrollView_Image.contentSize = CGSizeMake(4 + 71*(_parentsOpinonModel.multimedias.count - 1), 0);
    scrollView_Image.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView_Image];
    [scrollView_Image release];
    
    if (_parentsOpinonModel.multimedias.count <= 0){
        UILabel *promptBox = [[UILabel alloc]initWithFrame:scrollView_Image.bounds];
        promptBox.text = NSLocalizedString(@"暂无图片",nil);
        [scrollView_Image addSubview:promptBox];
        [promptBox release];
    }
    
    for (int i=0; i< _parentsOpinonModel.multimedias.count; i++){
        NSString *filePath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@.%@",[_parentsOpinonModel.multimedias[i] thumbnailid],[_parentsOpinonModel.multimedias[i] ext]] WithSubFolder:@"momentsmedia"]];
        
        UIImageView *photoView = [[UIImageView alloc]initWithFrame:CGRectMake(4 + 71*i, 5, 67, 67)];
        photoView.tag = 230 + i;
        photoView.userInteractionEnabled = YES;
        [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
        [scrollView_Image addSubview:photoView];
        
        
        BOOL isDirectory;
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (exist && !isDirectory){
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:filePath];
            photoView.image = image;
            [image release];
        }
        else {
            [WowTalkWebServerIF getMomentMedia:_parentsOpinonModel.multimedias[i] isThumb:YES inShowingOrder:i+5000 forMoment:_parentsOpinonModel.moment_id withCallback:@selector(didDownloadImage:) withObserver:self];
            
        }
        [photoView release];
    }
    
    
}


- (void)didDownloadImage:(NSNotification *)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSString *fileName = [[notif name] componentsSeparatedByString:@"download_moment_multimedia"][1];
        for (int i=0; i<_parentsOpinonModel.multimedias.count; i++){
            if ([[_parentsOpinonModel.multimedias[i] thumbnailid] isEqualToString:fileName]){
                NSString *relativefilepath = [NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@.%@",fileName,[_parentsOpinonModel.multimedias[i] ext]] WithSubFolder:@"momentsmedia"];
                NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:relativefilepath];
                UIImage *image = [[UIImage alloc]initWithContentsOfFile:absolutepath];
                
                UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:220];
                UIImageView *photoView = (UIImageView *)[scrollView viewWithTag:230 + i];
                photoView.image = image;
                [image release];
            }
        }
    }
}



- (void)imageClick:(UITapGestureRecognizer *)tap{
    if ([_delegate respondsToSelector:@selector(enterParentsOpinionDetailVC:)]){
        [_delegate enterParentsOpinionDetailVC:tap.view.tag - 230];
    }
}


@end
