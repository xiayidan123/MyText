//
//  GuideCollectionViewCell.m
//  dev01
//
//  Created by 杨彬 on 15/3/13.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "GuideCollectionViewCell.h"



@interface GuideCollectionViewCell ()

@property (retain, nonatomic) IBOutlet UIImageView *guide_imageView;

@property (retain, nonatomic) IBOutlet UIButton *enter_button;

@end

@implementation GuideCollectionViewCell

- (void)dealloc {
    [_imageObj release];
    [_guide_imageView release];
    [_enter_button release];
    [super dealloc];
}


- (IBAction)enterAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(enterAppWithGuideCollectionView:)]){
        [self.delegate enterAppWithGuideCollectionView:self];
    }
}

-(void)setImageObj:(UIImage *)imageObj{
    [_imageObj release],_imageObj = nil;
    _imageObj = [imageObj retain];
    if (![imageObj isKindOfClass:[UIImage class]]){
        self.guide_imageView.hidden = YES;
    }else{
        self.guide_imageView.hidden = NO;
        self.guide_imageView.image = _imageObj;
    }
}



-(void)setIsLaste:(BOOL)isLaste{
    _isLaste = isLaste;
    
    if (_isLaste){
        self.enter_button.hidden = NO;
    }else{
        self.enter_button.hidden = YES;
    }
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"GuideCollectionViewCell" forIndexPath:indexPath];
}


- (void)awakeFromNib {
    // Initialization code
}


@end
