//
//  SettingCell.h
//  omim
//
//  Created by Harry on 14-2-2.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMHeadImgeView.h"

#define TABLE_CELL_SECTION_0_COVER_HEIGHT 80
#define TABLE_CELL_DEF_HEIGHT 44
#define TABLE_SECTION_HEADER_HEIGHT 20
#define TABLE_NORMAL_CELL_IMG_IND_SIZE 30

#define TABLE_ROW_INIT_OFFSET 20

#define TABLE_SEPRATOR_HEIGHT 1

@interface SettingCell : UITableViewCell
{

}

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *subTitleLabel;
@property (nonatomic,retain) UIImageView *iconImageView;
@property (nonatomic,retain) UIImageView *iconIndicator;

@property (nonatomic,retain) OMHeadImgeView *headImageView;

- (UIView *)getCellView;

@end
