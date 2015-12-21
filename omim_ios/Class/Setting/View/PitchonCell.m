//
//  PitchonCell.m
//  dev01
//
//  Created by 杨彬 on 15/3/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "PitchonCell.h"
#import "PitchonCellModel.h"


@interface PitchonCell ()
@property (retain, nonatomic) IBOutlet UILabel *title_label;

@property (retain, nonatomic) IBOutlet UIImageView *pitchon_imageView;
@end

@implementation PitchonCell


- (void)dealloc {
    [_pitchonCellModel release];
    [_title_label release];
    [_pitchon_imageView release];
    [super dealloc];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *pitchonCellID = @"PitchonCellID";
    PitchonCell *cell = [tableView dequeueReusableCellWithIdentifier:pitchonCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PitchonCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    
}


-(void)setPitchonCellModel:(PitchonCellModel *)pitchonCellModel{
    [_pitchonCellModel release],_pitchonCellModel = nil;
    _pitchonCellModel = [pitchonCellModel retain];
    
    self.title_label.text = _pitchonCellModel.title;
    
    if (_pitchonCellModel.isPitchon){
        self.pitchon_imageView.hidden = NO;
    }else{
        self.pitchon_imageView.hidden = YES;
    }
}



@end
