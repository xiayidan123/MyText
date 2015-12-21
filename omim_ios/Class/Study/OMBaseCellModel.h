//
//  OMBaseCellModel.h
//  dev01
//
//  Created by 杨彬 on 15/2/28.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OMBaseCellModelType) {
    OMBaseCellModelTypeTextField,
    OMBaseCellModelTypeDatePicker,
    OMBaseCellModelTypeTimePicker,
    OMBaseCellModelTypeCountDownTimer,
    OMBaseCellModelTypeDefault
};


@interface OMBaseCellModel : NSObject

@property (nonatomic,retain)NSString *title;
@property (nonatomic,retain)NSString *content;

@property (retain, nonatomic) NSString * old_content;

@property (nonatomic,assign)OMBaseCellModelType type;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)OMBaseCellModelWithDic:(NSDictionary *)dic;



@end
