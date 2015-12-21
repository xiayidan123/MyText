//
//  AddChatMemberCell.h
//  omim
//
//  Created by Harry on 14-2-20.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMHeadImgeView.h"
@class Buddy;

@interface AddChatMemberCell : UITableViewCell

@property (assign, nonatomic) BOOL m_checked;
@property (retain, nonatomic) Buddy *buddy;
//@property (retain, nonatomic) UIImageView *iconImageView;
@property (retain, nonatomic) UIImageView *selectedImageView;
@property (retain, nonatomic) UIImageView *dividerImageview;
@property (retain, nonatomic) UILabel *nameLabel;
@property (retain, nonatomic) UILabel *signatureLabel;

@property (retain,nonatomic) OMHeadImgeView *headImageView;

- (void)loadContent:(Buddy *)buddy;

- (void) setChecked:(BOOL)checked;

@end
