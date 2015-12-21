//
//  OMContactFunctionCell.m
//  dev01
//
//  Created by Starmoon on 15/7/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMContactFunctionCell.h"


@interface OMContactFunctionCell ()

@property (retain, nonatomic) IBOutlet UIImageView *head_imageView;


@property (retain, nonatomic) IBOutlet UILabel *title_label;

@end

@implementation OMContactFunctionCell

- (void)dealloc {
    self.info_dic = nil;
    [_head_imageView release];
    [_title_label release];
    [super dealloc];
}



+ (instancetype )cellWithTableview:(UITableView *)tableView{
    static NSString *cellID = @"OMContactFunctionCellID";
    OMContactFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OMContactFunctionCell" owner:self options:nil] lastObject];
    }
    return cell;
}


#pragma mark - Set and Get
-(void)setInfo_dic:(NSDictionary *)info_dic{
    [_info_dic release];_info_dic = nil;
    _info_dic = [info_dic retain];
    
    NSString *title = _info_dic[@"title"];
    NSString *image_name = _info_dic[@"image_name"];
    
    self.head_imageView.image = [UIImage imageNamed:image_name];
    self.title_label.text = title;
}


- (void)awakeFromNib {
    self.head_imageView.layer.masksToBounds = YES;
    self.head_imageView.layer.cornerRadius = self.head_imageView.bounds.size.width/2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
