//
//  AbilityBgView.m
//  dev01
//
//  Created by 杨彬 on 14-10-13.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "AbilityBgView.h"
#import "AbilityView.h"

@implementation AbilityBgView

- (instancetype)initWithFrame:(CGRect)frame andBackgroundimage:(UIImage *)backgroundImage andAbilityImage:(UIImage *)abilityImage andAbilityArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backgroundimgv = [[UIImageView alloc]initWithFrame:self.bounds];
        backgroundimgv.image = backgroundImage;
        [self addSubview:backgroundimgv];
        [backgroundimgv release];
        
        AbilityView *abilityView = [[AbilityView alloc]initWithFrame:self.bounds andBackgroundImage:abilityImage andScoreArray:array];
        [self addSubview:abilityView];
        
        
        for (int i=0; i<abilityView.pointArray.count; i++){
            UIImageView *pointView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
            pointView.center = [abilityView.pointArray[i] CGPointValue];
            switch (i) {
                case 0:{
                    pointView.image = [UIImage imageNamed:@"growup_icon_yellow"];
                }break;
                case 1:{
                    pointView.image = [UIImage imageNamed:@"growup_icon_green"];
                }break;
                case 2:{
                    pointView.image = [UIImage imageNamed:@"growup_icon_bule"];
                }break;
                case 3:{
                    pointView.image = [UIImage imageNamed:@"growup_icon_purple"];
                }break;
                case 4:{
                    pointView.image = [UIImage imageNamed:@"growup_icon_red"];
                }break;
                case 5:{
                    pointView.image = [UIImage imageNamed:@"growup_icon_orange"];
                }break;
                default:
                    break;
            }
            [self addSubview:pointView];
            [pointView release];
        }
        [abilityView release];
    }
    return self;
}


@end
