//
//  MomentRecordView.h
//  dev01
//
//  Created by 杨彬 on 15/4/10.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MomentRecordModel;
@class MomentRecordView;
@class WTFile;


@interface MomentRecordView : UIView

@property (retain, nonatomic)MomentRecordModel *record_model;

@property (copy, nonatomic)NSString *moment_id;

@end
