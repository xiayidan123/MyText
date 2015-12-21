//
//  HomeworkReviewCell.m
//  dev01
//
//  Created by 杨彬 on 15/5/28.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "HomeworkReviewCell.h"

#import "HomeworkReviewModel.h"

#import "HomeworkReviewRankCell.h"


@interface HomeworkReviewCell ()<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *time_label;

@property (retain, nonatomic) IBOutlet UIView *bubble_bgView;

@property (retain, nonatomic) IBOutlet UIImageView *bubble_imageView;

@property (retain, nonatomic) IBOutlet UITableView *review_tableView;

@property (retain, nonatomic) IBOutlet UILabel *content_label;


@property (retain, nonatomic) IBOutlet NSLayoutConstraint *time_label_height;


@property (retain, nonatomic) IBOutlet NSLayoutConstraint *bullble_bgView_width;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *bubble_bgView_height;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *bubble_bgView_leading;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *review_tableView_height;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *review_tableView_width;



@property (retain, nonatomic) IBOutlet NSLayoutConstraint *text_label_width;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *text_label_height;


@end


@implementation HomeworkReviewCell

- (void)dealloc {
    [_bubble_bgView release];
    [_bubble_imageView release];
    [_review_tableView release];
    [_content_label release];
    [_time_label release];
    
    
    
    [_time_label_height release];
    [_bullble_bgView_width release];
    [_bubble_bgView_height release];
    [_review_tableView_height release];
    [_review_tableView_width release];
    
    self.review_model = nil;
    
    [_bubble_bgView_leading release];
    [_text_label_width release];
    [_text_label_height release];
    [super dealloc];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *HomeworkReviewCellID = @"HomeworkReviewCellID";
    HomeworkReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeworkReviewCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeworkReviewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeworkReviewRankCell *cell = [HomeworkReviewRankCell cellWithTableView:tableView];
    cell.rank_model = self.review_model.rank_array[indexPath.row];
    
    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.review_model.rank_array.count;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Homework_Review_rankCell_height;
}



#pragma mark - UITableViewDelegate



-(void)setReview_model:(HomeworkReviewModel *)review_model{
    [_review_model release],_review_model = nil;
    _review_model = [review_model retain];
    if(_review_model == nil)return;
    
    self.time_label_height.constant = review_model.time_label_height;
    
    if (review_model.time_label_height != 0){
        
    }else{
        self.time_label.text = @"";
    }
    
    
    self.content_label.text = _review_model.text;
    self.text_label_height.constant = _review_model.text_label_height;
    self.text_label_width.constant = _review_model.text_label_width;
    
    self.review_tableView_height.constant = _review_model.review_tableView_height;
    
    self.bullble_bgView_width.constant = _review_model.bullble_bgView_width;
    self.bubble_bgView_height.constant = _review_model.bullble_bgView_height;
    
    
    
    if (review_model.isFromMySelf){
        CGFloat bubble_bgView_width = self.bullble_bgView_width.constant;
        CGFloat contentView_width = self.contentView.bounds.size.width;
        
        self.bubble_bgView_leading.constant = contentView_width - bubble_bgView_width;
    }else{
        self.bubble_bgView_leading.constant = 0;
    }
    
    
    UIImage *bubble_Image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",review_model.isFromMySelf ? @"bg_message_my_words" :@"bg_message_other_words"]];
    
    
    bubble_Image = [bubble_Image stretchableImageWithLeftCapWidth:bubble_Image.size.width/2 topCapHeight:bubble_Image.size.height/2];
    
    self.bubble_imageView.image = bubble_Image;
    
    
}


- (void)awakeFromNib {
    // Initialization code
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
