//
//  CheckVersionCell.m
//  dev01
//
//  Created by 杨彬 on 15/3/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "CheckVersionCell.h"
#import "OMNetWork_Setting.h"
#import "SetCellFrameModel.h"


@interface CheckVersionCell ()
@property (retain, nonatomic) IBOutlet UILabel *title_leabel;
@property (retain, nonatomic) IBOutlet UILabel *content_label;

@end


@implementation CheckVersionCell


- (void)dealloc {
    self.frameModel = nil;
    self.title_leabel = nil;
    self.content_label = nil;
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *checkVersionCellID = @"checkVersionCellID";
    CheckVersionCell *cell = [tableView dequeueReusableCellWithIdentifier:checkVersionCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CheckVersionCell" owner:self options:nil] lastObject];
    }
    [cell checkVersion];
    return cell;
}


-(void)setFrameModel:(SetCellFrameModel *)frameModel{
    [_frameModel release],_frameModel = nil;
    _frameModel = [frameModel retain];
    self.title_leabel.text = _frameModel.title;
    self.content_label.text = _frameModel.content;
    
    if (_frameModel.canEnter){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)checkVersion{
    [OMNetWork_Setting getLatestVersionInfoWithCallback:@selector(didCheckForUpdates:) withObserver:self];
}


- (void)didCheckForUpdates:(NSNotification *)notif
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSError *error = [[notif userInfo] objectForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        BOOL hasNewVersion = [[[notif userInfo] objectForKey:@"fileName"] boolValue];
        SetCellFrameModel *frameModel = [[SetCellFrameModel alloc] init];
        frameModel.title = self.frameModel.title;
        frameModel.cellHeight = self.frameModel.cellHeight;
        if (hasNewVersion){
            frameModel.canEnter = YES;
            frameModel.content = NSLocalizedString(@"有新版本可用",nil);
        }else{
            frameModel.canEnter = NO;
            frameModel.content = NSLocalizedString(@"已是最新版本",nil);
        }
        self.frameModel = frameModel;
        [frameModel release];
    }
}

@end
