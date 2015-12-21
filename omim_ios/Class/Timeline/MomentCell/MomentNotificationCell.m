//
//  MomentNotificationCell.m
//  dev01
//
//  Created by 杨彬 on 15/5/6.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "MomentNotificationCell.h"
#import "OMHeadImgeView.h"

#import "Review.h"

#import "Database.h"

@interface MomentNotificationCell ()

@property (retain, nonatomic) IBOutlet UIView *bg_view;

@property (retain, nonatomic) IBOutlet OMHeadImgeView *head_view;

@property (retain, nonatomic) IBOutlet UILabel *text_label;

@end


@implementation MomentNotificationCell

- (void)dealloc {
    self.review_array = nil;
    
    [_bg_view release];
    [_head_view release];
    [_text_label release];
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *MomentNotificationCellID = @"MomentNotificationCellID";
    MomentNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:MomentNotificationCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MomentNotificationCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setReview_array:(NSArray *)review_array{
    [_review_array release],_review_array = nil;
    _review_array = [review_array retain];
    if (_review_array == nil){
        self.head_view.buddy = nil;
        
        return;
    }
    NSInteger review_count = _review_array.count;
    self.text_label.text = [NSString stringWithFormat:@"%zi条新消息",review_count];
    
    Review *review = [_review_array firstObject];
    
    
    Buddy *buddy = [Database buddyWithUserID:review.owerID];
    
    self.head_view.buddy = buddy;
    
}



@end
