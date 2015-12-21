//
//  GroupButton.h
//  wowtalkbiz
//
//  Created by elvis on 2013/10/03.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupButton;

@protocol GroupButtonDelegate <NSObject>

@optional
-(void)deleteThisGroup:(GroupButton*)button;

@end

@interface GroupButton : UIButton

@property (nonatomic,retain) NSString* buttontext;
@property (assign) id<GroupButtonDelegate> delegate;

@property BOOL isNotEditable;


@end
