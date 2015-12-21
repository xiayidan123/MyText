//
//  ClassRommCell.m
//  dev01
//
//  Created by Huan on 15/3/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ClassRommCell.h"
#import "ClassRoom.h"

@interface ClassRommCell ()
@property (retain, nonatomic) IBOutlet UIImageView *SelectedImage;
@property (retain, nonatomic) IBOutlet UILabel *ClassRoomName;
@end


@implementation ClassRommCell

- (void)dealloc {
    [_SelectedImage release];
    [_ClassRoomName release];
    [_classRoom release],_classRoom = nil;
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"ClassRoomCellid";
    ClassRommCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassRommCell" owner:self options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    self.SelectedImage.image = [UIImage imageNamed:@"album_photo_select@3x"];
    self.SelectedImage.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setClassRoom:(ClassRoom *)classRoom{
    [_classRoom release],_classRoom = nil;
    _classRoom = [classRoom retain];
    
    _ClassRoomName.text = [NSString stringWithFormat:@"%@ - %@", _classRoom.room_name,_classRoom.room_num];
    
    self.SelectedImage.hidden = _classRoom.isSelected ? NO : YES;

}




@end
