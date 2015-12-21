//
//  CourseCell.m
//  dev01
//
//  Created by Huan on 15/3/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "CourseCell.h"
#import "OMBaseCellFrameModel.h"


@interface CourseCell ()

@property (retain, nonatomic) IBOutlet UILabel *nameTitle;
@property (retain, nonatomic) IBOutlet UILabel *Setting;

@end


@implementation CourseCell

- (void)dealloc {
    [_cellFrameModel release];
    [_nameTitle release];
    [_Setting release];
    [super dealloc];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"CourseCellID";
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:nil options:nil] lastObject];
    }
    return cell;
}



-(void)setCellFrameModel:(OMBaseCellFrameModel *)cellFrameModel{
    if (![cellFrameModel isKindOfClass:[OMBaseCellFrameModel class]]){
        self.nameTitle.text = nil;
        self.Setting.text = nil;
        self.textLabel.text = NSLocalizedString(@"Data error",nil);
    }
    
    [_cellFrameModel release],_cellFrameModel = nil;
    
    _cellFrameModel = [cellFrameModel retain];
    
    
    self.nameTitle.text = cellFrameModel.cellModel.title;
    self.Setting.text = cellFrameModel.cellModel.content;
    
}




- (void)awakeFromNib {
    // Initialization code
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}


@end
