//
//  UserResultCell.h
//  dev01
//
//  Created by jianxd on 14-6-20.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMHeadImgeView.h"
//@class Buddy;
typedef NS_ENUM(NSInteger, UserResultCellStatus) {
    NOTADD,
    ADDING,
    DIDADD
};
@interface UserResultCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *idLabel;
@property (retain, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, assign) UserResultCellStatus status;

@property (retain, nonatomic) IBOutlet OMHeadImgeView *headImageView;
@end
