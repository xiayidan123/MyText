//
//  SchoolContractContentsCell.h
//  dev01
//
//  Created by 杨彬 on 14-12-17.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RADataObject.h"



@protocol SchoolContractContentsCellDelegate <NSObject>

- (void)beginGroupChatWithRAObject:(RADataObject *)raDataObject;

@end


@interface SchoolContractContentsCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imageView_mark;
@property (retain, nonatomic) IBOutlet UILabel *lab_title;
@property (assign, nonatomic)BOOL *isClass;
@property (retain, nonatomic) IBOutlet UIButton *btn_beginGroupChat;
@property (assign, nonatomic) BOOL isHideGroupBtn;
@property (assign, nonatomic)id<SchoolContractContentsCellDelegate>delegate;
@property (assign,nonatomic)RADataObject *raDataObject;

- (void)setLevel:(NSInteger)level;

- (void)state;
- (IBAction)clickBeginGroupChat:(id)sender;

@end
