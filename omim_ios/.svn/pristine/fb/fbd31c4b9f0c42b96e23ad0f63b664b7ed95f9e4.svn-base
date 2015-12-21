//
//  ContantPreviewCell.h
//  omim
//
//  Created by Harry on 14-1-11.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMHeadImgeView.h"
@class Buddy;
@class UserGroup;
@class GroupChatRoom;

@interface ContactPreviewCell : UITableViewCell
{
    Buddy *_buddy;
}

@property (retain, nonatomic) Buddy *buddy;
@property (retain, nonatomic) IBOutlet UIImageView *authImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *signatureLabel;
@property (retain, nonatomic) IBOutlet OMHeadImgeView *headImageView;



@property (retain, nonatomic) UIImage *iconImage;
@property (retain, nonatomic) UIImage *authImage;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *signature;

@property (retain,nonatomic) UserGroup* group;
@property (retain,nonatomic) GroupChatRoom* temproom;

@property (retain,nonatomic) UIButton* btn_admin;


- (void)loadView;
-(void)loadViewForGroup;

-(void)loadViewForTempGroup;
@end
