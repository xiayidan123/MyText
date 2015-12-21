//
//  ActivityListCell.m
//  dev01
//
//  Created by 杨彬 on 14-10-23.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "ActivityListCell.h"
#import "WowTalkWebServerIF.h"
#import "WTFile.h"
#import "WTHeader.h"

#import "ActivityModel.h"

@interface ActivityListCell ()

@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *lal_title;
@property (retain, nonatomic) IBOutlet UIImageView *imgv_activityImage;

@property (retain, nonatomic) IBOutlet UILabel *lal_startTime;
@property (retain, nonatomic) IBOutlet UILabel *lal_endTime;
@property (retain, nonatomic) IBOutlet UILabel *lal_place;
@property (retain, nonatomic) IBOutlet UILabel *lal_master;
@property (retain, nonatomic) IBOutlet UILabel *lal_apply;


@property (retain, nonatomic) IBOutlet UILabel *lal_startTimeContent;
@property (retain, nonatomic) IBOutlet UILabel *lal_endTimeContent;
@property (retain, nonatomic) IBOutlet UILabel *lal_placeContent;
@property (retain, nonatomic) IBOutlet UILabel *lal_masterContent;
@property (retain, nonatomic) IBOutlet UILabel *lal_applyContent;

@property (copy, nonatomic) NSString * mediaType;

@end


@implementation ActivityListCell


- (void)dealloc {
    [_activityModel release];
    [_bgView release];
    [_lal_title release];
    [_imgv_activityImage release];
    [_lal_place release];
    [_lal_master release];
    [_lal_apply release];
    [_lal_placeContent release];
    [_lal_masterContent release];
    [_lal_applyContent release];
    [_lal_startTime release];
    [_lal_endTime release];
    [_lal_startTimeContent release];
    [_lal_endTimeContent release];
    self.mediaType = nil;
    [super dealloc];
}

- (void)awakeFromNib {
    
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    
    self.lal_startTime.text = NSLocalizedString(@"开始时间:",nil);
    self.lal_endTime.text = NSLocalizedString(@"结束时间:",nil);
    self.lal_place.text = NSLocalizedString(@"地点:",nil);
    self.lal_master.text = NSLocalizedString(@"主办:",nil);
    self.lal_apply.text = NSLocalizedString(@"报名:",nil);
}

- (void)setActivityModel:(ActivityModel *)activityModel{
    self.lal_title.text = activityModel.text_title;
    
    NSDate *startTimeDate = [NSDate dateWithTimeIntervalSince1970:[activityModel.start_timestamp integerValue]];
    NSDate *endTimeDate = [NSDate dateWithTimeIntervalSince1970:[activityModel.end_timestamp integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    self.lal_startTimeContent.text =  [formatter stringFromDate:startTimeDate];
    self.lal_endTimeContent.text = [formatter stringFromDate:endTimeDate];
    self.lal_placeContent.text = activityModel.area;
    self.lal_masterContent.text = activityModel.owner_name;
    [formatter release];
    
    
    if ([activityModel.member_count integerValue] <= 0){
        self.lal_applyContent.text = NSLocalizedString(@"暂时无人报名",nil);
    }else {
        self.lal_applyContent.text = activityModel.member_count;
    }
    if (activityModel.mediaArray.count != 0){
        for (int i=0; i<=activityModel.mediaArray.count; i++){
            if (i == activityModel.mediaArray.count){
                self.mediaType = [activityModel.mediaArray[0] ext];
                [WowTalkWebServerIF getEventMedia:activityModel.mediaArray[0] isThumb:YES showingOrder:5000 withCallback:@selector(didDownloadImage:) withObserver:nil];
            }else{
                NSString *filePath = [NSFileManager absolutePathForFileInDocumentFolder:[NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@.%@",[activityModel.mediaArray[i] thumbnailid],[activityModel.mediaArray[i] ext]] WithSubFolder:@"eventmedia"]];
                BOOL isDirectory;
                BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
                if (exist && !isDirectory){
                    UIImage *image = [[UIImage alloc]initWithContentsOfFile:filePath];
                    self.imgv_activityImage.image = image;
                    [image release];
                    break;
                }
            }
        }
    }
}



/*
- (void)didDownloadImage:(NSNotification *)notif{
    NSError* error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSString *fileName = [[notif name] componentsSeparatedByString:@"download_event_multimedia"][1];
        
        NSString *relativefilepath = [NSFileManager relativePathToDocumentFolderForFile:[NSString stringWithFormat:@"%@.%@",fileName,_mediaType] WithSubFolder:@"eventmedia"];
        NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:relativefilepath];
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:absolutepath];
        _imgv_activityImage.image = image;
        [image release];
    }
}
 */


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ActivityListCellID = @"ActivityListCellID";
    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityListCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ActivityListCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
