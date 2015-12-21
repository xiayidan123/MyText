//
//  EditClassInformationModel.h
//  dev01
//
//  Created by 杨彬 on 15/2/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EditClassInformationModelType) {
    EditClassInformationModelDefault,
    EditClassInformationModelDate,
    EditClassInformationModelTime
};


@interface EditClassInformationModel : NSObject

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,assign,readonly)EditClassInformationModelType type;
@property (nonatomic,assign)BOOL isOpen;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)editClassInformationWithDict:(NSDictionary *)dict;

@end
