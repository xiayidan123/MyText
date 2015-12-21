//
//  RequestListCell.h
//  dev01
//
//  Created by Huan on 15/3/5.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
@interface RequestListCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *headImg;
@property (retain, nonatomic) IBOutlet UILabel *RequestMsg;
@property (retain, nonatomic) IBOutlet CustomButton *Accept;
@property (retain, nonatomic) IBOutlet CustomButton *Reject;
@property (retain, nonatomic) IBOutlet UILabel *nameLab;

@end
