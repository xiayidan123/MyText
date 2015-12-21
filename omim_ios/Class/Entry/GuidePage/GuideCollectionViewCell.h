//
//  GuideCollectionViewCell.h
//  dev01
//
//  Created by 杨彬 on 15/3/13.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GuideCollectionViewCell;

@protocol GuideCollectionViewCellDelegate <NSObject>

- (void)enterAppWithGuideCollectionView:(GuideCollectionViewCell *)guideCollectionViewCell;



@end


@interface GuideCollectionViewCell : UICollectionViewCell


@property (retain, nonatomic)UIImage *imageObj;

@property (assign, nonatomic)BOOL isLaste;



@property (assign, nonatomic)id <GuideCollectionViewCellDelegate>delegate;


+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end
