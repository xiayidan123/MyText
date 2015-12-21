//
//  HomeworkDetailCell.m
//  dev01
//
//  Created by 杨彬 on 15/5/25.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "HomeworkDetailCell.h"

#import "YBImageShowView.h"

#import "NSDate+FATOUTPUT.h"

#import "Homework_Moment.h"

#import "HomeworkReviewModel.h"


@interface HomeworkDetailCell ()

@property (retain, nonatomic) IBOutlet UILabel *time_label;

@property (retain, nonatomic) IBOutlet UIView *bubble_bgView;

@property (retain, nonatomic) IBOutlet UIImageView *bubblu_bgImageView;

@property (retain, nonatomic) IBOutlet YBImageShowView *imageShowView;

@property (retain, nonatomic) UILabel *content_label;



@property (retain, nonatomic) IBOutlet NSLayoutConstraint *bubble_bgView_width;// 气泡背景宽度
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *bubble_bgView_height;// 气泡背景高度
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *bubble_bgView_leading;// 气泡距离左边距离


@property (retain, nonatomic) IBOutlet NSLayoutConstraint *imageShowView_height;// 图片view 的高度
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *imageShowVIew_width;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *imageShowView_leading;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *imageShowView_top;


@property (retain, nonatomic) IBOutlet NSLayoutConstraint *time_label_height;



@property (retain, nonatomic) NSLayoutConstraint *text_label_width;
@property (retain, nonatomic) NSLayoutConstraint *text_label_leading;



@end

@implementation HomeworkDetailCell

- (void)dealloc {
    [_time_label release];
    [_bubble_bgView release];
    [_bubblu_bgImageView release];
    [_imageShowView release];
    [_content_label release];
    [_bubble_bgView_leading release];
    [_imageShowView_height release];
    [_bubble_bgView_width release];
    [_bubble_bgView_height release];
    
    self.homework_objc = nil;
    
    [_time_label_height release];
    [_text_label_width release];
    [_imageShowView_leading release];
    [_text_label_leading release];
    [_imageShowVIew_width release];
    [_imageShowView_top release];
    [super dealloc];
}


- (void)uiConfig{
    
    
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static  NSString *HomeworkDetailCellID = @"HomeworkDetailCellID";
    HomeworkDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeworkDetailCellID];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeworkDetailCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}






- (void)awakeFromNib {
    self.content_label = [[[UILabel alloc]init] autorelease];
    self.content_label.translatesAutoresizingMaskIntoConstraints = NO;
    self.content_label.numberOfLines = 0;
    self.content_label.font = [UIFont systemFontOfSize:Homework_moment_text_font];
    self.content_label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.bubble_bgView addSubview:self.content_label];
    
    
//    self.content_label.backgroundColor = [UIColor greenColor];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.content_label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bubble_bgView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    [self.bubble_bgView addConstraint:leading];
    self.text_label_leading = leading;
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.content_label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageShowView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:content_text_margins_top];
    [self.bubble_bgView addConstraint:top];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.content_label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    [self.content_label addConstraint:width];
    self.text_label_width = width;
    
    
    
//    self.content_label.lineBreakMode = NSLineBreakByCharWrapping;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}




-(void)setHomework_objc:(id)homework_objc{
    [_homework_objc release],_homework_objc = nil;
    _homework_objc = [homework_objc retain];
    if (_homework_objc == nil)return;
    
    if ([homework_objc isKindOfClass:[Homework_Moment class]]){
        Homework_Moment *homework_moment = homework_objc;
        
        self.text_label_width.constant = homework_moment.text_label_width;
        self.text_label_leading.constant = homework_moment.text_label_leading;
        self.content_label.text = homework_moment.text;

        NSMutableArray *image_model_array = [[NSMutableArray alloc]init];
        
        NSArray *wtfile_array = homework_moment.multimedias;
        for (int i=0; i<wtfile_array.count; i++){
            WTFile *file = wtfile_array[i];
            YBImageModel *imageModel = [[YBImageModel alloc]init];
            imageModel.file = file;
            [image_model_array addObject:imageModel];
            [imageModel release];
        }
        self.imageShowView_top.constant = homework_moment.imageShowView_top;
        self.imageShowView.image_model_array = image_model_array;
        
        self.time_label_height.constant = homework_moment.time_label_height;
        if (homework_moment.time_label_height != 0 ){
            self.time_label.text = [NSDate standardAMPMFormat:homework_moment.timestamp];
        }else{
            self.time_label.text = nil;
        }
        
        [image_model_array release];
        
        self.bubble_bgView_width.constant = homework_moment.bubble_bgView_width;
        self.bubble_bgView_height.constant = homework_moment.bubble_bgView_height;
        
        if (homework_moment.isFromMySelf){
            CGFloat bubble_bgView_width = self.bubble_bgView_width.constant;
            CGFloat contentView_width = self.contentView.bounds.size.width;
            
            self.bubble_bgView_leading.constant = contentView_width - bubble_bgView_width;
        }else{
            self.bubble_bgView_leading.constant = 0;
        }
        
        self.imageShowView_height.constant = homework_moment.imageShowView_height;
        self.imageShowVIew_width.constant = homework_moment.imageShowView_width;
        self.imageShowView_leading.constant = homework_moment.imageShowView_leading;
        
        ;
        UIImage *bubble_Image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",homework_moment.isFromMySelf ? @"bg_message_my_words" :@"bg_message_other_words"]];
    
        
        bubble_Image = [bubble_Image stretchableImageWithLeftCapWidth:bubble_Image.size.width/2 topCapHeight:bubble_Image.size.height/2];
        
        self.bubblu_bgImageView.image = bubble_Image;
        
        
        
    }else if ([homework_objc isKindOfClass:[HomeworkReviewModel class]]){
        
        
        
        
    }
}







- (instancetype)init
{
    self = [super init];
    if (self) {
        [self uiConfig];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self uiConfig];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self uiConfig];
    }
    return self;
}


@end
