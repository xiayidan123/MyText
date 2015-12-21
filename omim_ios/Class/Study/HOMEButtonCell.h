//
//  HOMEButtonCell.h
//  dev01
//
//  Created by Huan on 15/3/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HOMEButtonCell : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UIImageView *icon_ImageView;
@property (retain, nonatomic) IBOutlet UILabel *title_Lab;
@property (retain, nonatomic) IBOutlet UILabel *TipCount_Lab;
@property (retain, nonatomic) IBOutlet UIImageView *tipBg_imgV;
@property (retain, nonatomic) NSMutableArray *ImageArr;
@property (retain, nonatomic) IBOutlet UIImageView *Redpoint;

@end
