//
//  ActivityDetailCell.m
//  dev01
//
//  Created by 杨彬 on 14-11-3.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "ActivityDetailCell.h"
#import "GalleryView.h"
#import "ActivityDetailImage.h"
#import "WowTalkWebServerIF.h"
#import "WTFile.h"
#import "WTHeader.h"

@implementation ActivityDetailCell
{
    NSInteger _indexOfImage;
}

-(void)dealloc{
//    UIView *view = [self.contentView ]
    [_activityModel release];
    [super dealloc];
}

-(void)showCellWithIndexPath:(NSIndexPath *)indexPath {
    self.layer.masksToBounds = YES;
    for (UIView *view in self.contentView.subviews){
        [view removeFromSuperview];
    }
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                ActivityDetailImage *activityDetailImage = [[ActivityDetailImage alloc]initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 254) andActivityModel:_activityModel];
                activityDetailImage.tag = 5000;
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, activityDetailImage.bounds.size.width , activityDetailImage.bounds.size.height);
                [self.contentView addSubview:activityDetailImage];
                [activityDetailImage release];
                self.layer.masksToBounds = NO;
            }break;
            case 1:{
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, 60, 12)];
                titleLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"开始时间",nil)];
                titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
                titleLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
                [view addSubview:titleLabel];
                [titleLabel release];
                
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(81, 16, self.contentView.bounds.size.width - 81, 12)];
                NSDate *startTimeDate = [NSDate dateWithTimeIntervalSince1970:[_activityModel.start_timestamp integerValue]];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
                contentLabel.text = [formatter stringFromDate:startTimeDate];
                contentLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
                contentLabel.numberOfLines = 0;
                contentLabel.textColor = [UIColor blackColor];
                [view addSubview:contentLabel];
                [contentLabel release];
                [formatter release];
                
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, view.bounds.size.width , view.bounds.size.height);
                
                [self.contentView addSubview:view];
                [view release];
            }break;
            case 2:{
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, 60, 12)];
                titleLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"结束时间",nil)];
                titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
                titleLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
                [view addSubview:titleLabel];
                [titleLabel release];
                
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(81, 16, self.contentView.bounds.size.width - 81, 12)];
                NSDate *endTimeDate = [NSDate dateWithTimeIntervalSince1970:[_activityModel.end_timestamp integerValue]];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
                contentLabel.text = [formatter stringFromDate:endTimeDate];
                contentLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
                contentLabel.numberOfLines = 0;
                contentLabel.textColor = [UIColor blackColor];
                [view addSubview:contentLabel];
                [contentLabel release];
                
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, view.bounds.size.width , view.bounds.size.height);
                
                [self.contentView addSubview:view];
                [view release];
            }break;
            case 3:{
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, 60, 12)];
                titleLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"地点",nil)];
                titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
                titleLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
                [view addSubview:titleLabel];
                [titleLabel release];
                
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(81, 16, self.contentView.bounds.size.width - 81, 12)];
                contentLabel.text = _activityModel.area;
                contentLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];;
                contentLabel.textColor = [UIColor blackColor];
                [view addSubview:contentLabel];
                [contentLabel release];
                
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, view.bounds.size.width , view.bounds.size.height);
                
                [self.contentView addSubview:view];
                [view release];
            }break;
            case 4:{
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, 60, 12)];
                titleLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"费用",nil)];
                titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
                titleLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
                [view addSubview:titleLabel];
                [titleLabel release];
                
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(81, 16, self.contentView.bounds.size.width - 81, 12)];
                if ([_activityModel.coin integerValue] == 0){
                    contentLabel.text = NSLocalizedString(@"免费",nil);
                }else {
                    contentLabel.text = _activityModel.coin;
                }
                contentLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];;
//                contentLabel.textColor = [UIColor colorWithRed:208.0/255 green:2.0/255 blue:27.0/255 alpha:1];
                [view addSubview:contentLabel];
                [contentLabel release];
                
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, view.bounds.size.width , view.bounds.size.height);
                
                [self.contentView addSubview:view];
                [view release];
            }break;
            case 5:{
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, 60, 12)];
                titleLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"主办",nil)];
                titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
                titleLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
                [view addSubview:titleLabel];
                [titleLabel release];
                
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(81, 16, self.contentView.bounds.size.width - 81, 12)];
                contentLabel.text = _activityModel.owner_name;
                contentLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];;
                contentLabel.textColor = [UIColor blackColor];
                [view addSubview:contentLabel];
                [contentLabel release];
                
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, view.bounds.size.width , view.bounds.size.height);
                
                [self.contentView addSubview:view];
                [view release];
            }break;
            case 6:{
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, 60, 12)];
//                titleLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"联系方式",nil)];
                titleLabel.text = NSLocalizedString(@"报名者列表",nil);
                titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
                titleLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
                [view addSubview:titleLabel];
                [titleLabel release];
                
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(81, 16, self.contentView.bounds.size.width - 81, 12)];
                contentLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];;
                contentLabel.textColor = [UIColor blackColor];
                [view addSubview:contentLabel];
                [contentLabel release];
                
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, view.bounds.size.width , view.bounds.size.height);
                
                [self.contentView addSubview:view];
                [view release];
                
                
                self.selectionStyle = UITableViewCellSelectionStyleNone;
            }break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 1 && indexPath.row == 0){
        [self loadGalleryView];
        
    }
    else if (indexPath.section == 2 && indexPath.row == 0){
        [self loadActivityContent];
    }else{
        return;
    }
    
}


- (void)loadGalleryView{
    UIScrollView *scrollView_Image = [[UIScrollView alloc]initWithFrame:CGRectMake(16, 7.5, self.contentView.bounds.size.width - 32, 75)];
    scrollView_Image.tag = 220;
    scrollView_Image.delegate = nil;
    scrollView_Image.contentSize = CGSizeMake(4 + 71*(_activityModel.mediaArray.count - 1), 0);
    scrollView_Image.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:scrollView_Image];
    [scrollView_Image release];
    
    if (_activityModel.mediaArray.count <= 1){
        UILabel *promptBox = [[UILabel alloc]initWithFrame:scrollView_Image.bounds];
        promptBox.text = NSLocalizedString(@"暂无图片",nil);
        [scrollView_Image addSubview:promptBox];
        [promptBox release];
    }
    
    for (int i=1; i< _activityModel.mediaArray.count; i++){
        NSString *filePath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@.%@",[_activityModel.mediaArray[i] thumbnailid],[_activityModel.mediaArray[i] ext]] WithSubFolder:@"eventmedia"]];
        BOOL isDirectory;
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (exist && !isDirectory){
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:filePath];
            UIImageView *photoView = [[UIImageView alloc]initWithFrame:CGRectMake(4 + 71*(i- 1), 5, 67, 67)];
            photoView.image = image;
            photoView.tag = 220 + i;
            photoView.userInteractionEnabled = YES;
            [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
            [scrollView_Image addSubview:photoView];
            [image release];
            [photoView release];
        }
        else {
            [WowTalkWebServerIF getEventMedia:_activityModel.mediaArray[i] isThumb:YES showingOrder:5000 withCallback:@selector(didDownloadImage:) withObserver:nil];
        }
    }
}


- (void)didDownloadImage:(NSNotification *)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSString *fileName = [[notif name] componentsSeparatedByString:@"download_event_multimedia"][1];
        for (int i=1; i<_activityModel.mediaArray.count; i++){
            if ([[_activityModel.mediaArray[i] thumbnailid] isEqualToString:fileName]){
                NSString *relativefilepath = [NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@.%@",fileName,[_activityModel.mediaArray[i] ext]] WithSubFolder:@"eventmedia"];
                NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:relativefilepath];
                UIImage *image = [[UIImage alloc]initWithContentsOfFile:absolutepath];
                UIImageView *photoView = [[UIImageView alloc]initWithFrame:CGRectMake(4 + 71*(i- 1), 5, 67, 67)];
                photoView.tag = 220 + i;
                photoView.userInteractionEnabled = YES;
                [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
                photoView.image = image;
                UIScrollView *scrollView = (UIScrollView *)[self.contentView viewWithTag:220];
                [scrollView addSubview:photoView];
                [image release];
                [photoView release];
            }
        }
    }
}

- (void)imageClick:(UITapGestureRecognizer *)tap{
    if ([_delegate respondsToSelector:@selector(clickImageWithIndex:)]){
        [_delegate clickImageWithIndex:tap.view.tag - 220];
    }
}

- (void)loadActivityContent{
    UILabel *activityContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, self.contentView.bounds.size.width - 30, 100)];
    activityContentLabel.numberOfLines = 0;
    activityContentLabel.font = [UIFont systemFontOfSize:16];
    activityContentLabel.text = _activityModel.text_content;
    
    CGRect rect = [activityContentLabel.text boundingRectWithSize:CGSizeMake(activityContentLabel.bounds.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:nil];
    
    activityContentLabel.frame = CGRectMake(activityContentLabel.frame.origin.x, activityContentLabel.frame.origin.y, activityContentLabel.frame.size.width, rect.size.height );
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,activityContentLabel.bounds.size.height+ 24);
    [self.contentView addSubview:activityContentLabel];
    [activityContentLabel release];
    
}

@end
