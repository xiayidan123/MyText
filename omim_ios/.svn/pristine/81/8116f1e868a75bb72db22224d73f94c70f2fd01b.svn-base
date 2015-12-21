//
//  LHLineLayout.m
//  dev01
//
//  Created by Huan on 15/5/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "LHLineLayout.h"

@implementation LHLineLayout
static const CGFloat LHItemWH = 80;

//
//-(CGSize)collectionViewContentSize
//{
////    [self.collectionView layoutIfNeeded];
//    
//    return CGSizeMake(320, 80);
//}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
- (void)prepareLayout{
    [super prepareLayout];
    self.itemSize = CGSizeMake(LHItemWH, LHItemWH);
    //    CGFloat inset = (self.collectionView.frame.size.width - LHItemWH) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 5;
}
@end
