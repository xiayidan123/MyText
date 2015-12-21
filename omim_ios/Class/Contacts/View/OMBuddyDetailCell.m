//
//  OMBuddyDetailCell.m
//  dev01
//
//  Created by Starmoon on 15/7/29.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMBuddyDetailCell.h"

#import "OMBuddyDetailItem.h"

@interface OMBuddyDetailCell ()

@property (retain, nonatomic) IBOutlet UILabel *title_label;

@property (retain, nonatomic) IBOutlet UILabel *content_label;

@end



@implementation OMBuddyDetailCell


- (void)dealloc {
    [_title_label release];
    [_content_label release];
    self.item = nil;
    [super dealloc];
}



#pragma mark - Set and Get
-(void)setItem:(OMBuddyDetailItem *)item{
    [_item release],_item = nil;
    _item = [item retain];
    
    self.title_label.text = _item.title;
    self.content_label.text = _item.content;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"OMBuddyDetailCellID";
    OMBuddyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OMBuddyDetailCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    self.clipsToBounds = YES;
    self.title_label.font = OMBuddyDetailItem_TextFont;
    self.content_label.font = OMBuddyDetailItem_TextFont;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
