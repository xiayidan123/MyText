//
//  Homework_Moment.m
//  dev01
//
//  Created by 杨彬 on 15/5/25.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Homework_Moment.h"

#import "WTFile.h"
#import "WTUserDefaults.h"
#import "Buddy.h"


@interface Homework_Moment ()

@property (assign, nonatomic) BOOL alreadySetSize;

@property (assign, nonatomic) CGFloat bubble_bgView_bottom;

@property (assign, nonatomic) CGFloat text_label_height;

@end

@implementation Homework_Moment



-(void)dealloc{
    
    self.homework_id = nil;
    
    self.lesson_id = nil;
    
    self.student_id = nil;
    
    self.result_id = nil;
    
    [super dealloc];
}


- (instancetype)initWithDict:(NSDictionary *)dict
{
    
    self = [super initWithMomentID:[dict objectForKey:@"moment_id"]
                          withText:[dict objectForKey:@"text_content"]
                        withOwerID:[dict objectForKey:@"uid"]
                      withUserType:[dict objectForKey:@"user_type"]
                      withNickname:[dict objectForKey:@"nickname"]
                     withTimestamp:[dict objectForKey:@"insert_timestamp"]
                     withLongitude:[dict objectForKey:@"insert_longitude"]
                      withLatitude:[dict objectForKey:@"insert_latitude"]
                  withPrivacyLevel:[dict objectForKey:@"privacy_level"]
                   withAllowReview:[dict objectForKey:@"allow_review"]
                     withLikedByMe:[dict objectForKey:@"liked"]
                     withPlacename:[dict objectForKey:@"place"]
                    withMomentType:[dict objectForKey:@"tag"]
                      withDeadline:[dict objectForKey:@"deadline"]];
    if (self) {
        
        if ([dict objectForKey:@"multimedias"])
        {
            if ([[dict objectForKey:@"multimedias"] isKindOfClass:[NSMutableArray class]]){
                for (NSMutableDictionary *mediaDict in [dict objectForKey:@"multimedias"] ) {
                    WTFile* wtfile = [[WTFile alloc] initWithDict:mediaDict] ;
                    wtfile.momentid = self.moment_id;
                    [self.multimedias addObject:wtfile];
                    [wtfile release];
                }
            }
            
            else if([[dict objectForKey:@"multimedias"] isKindOfClass:[NSMutableDictionary class]])
            {
                WTFile* wtfile = [[WTFile alloc] initWithDict:[dict objectForKey:@"multimedias"]];
                wtfile.momentid = self.moment_id;
                [self.multimedias addObject:wtfile];
                [wtfile release];
            }
        }
    }

    return self;
}


-(CGFloat)cell_height{
    
    if (!self.alreadySetSize){
        [self setSize];
        self.alreadySetSize = YES;
    }
    
    return self.bubble_bgView_height + self.time_label_height + Homework_moment_gap_to_bottom ;
}


- (void)setSize{
    NSInteger user_type = [[WTUserDefaults getUsertype] intValue];
    NSString *uid = [WTUserDefaults getUid];
    
    if (user_type == 1 && [uid isEqualToString:self.student_id] ){// 学生
        self.isFromMySelf = YES;
    }else if (user_type == 2 && self.student_id == nil){// 老师
        self.isFromMySelf = YES;
    }else{
        self.isFromMySelf = NO;
    }
    // time_label
    if (self.timestamp - self.last_timeInterval > 64){
        self.time_label_height = time_label_height_original;
    }else{
        self.time_label_height = 0;
    }
    
    // iamgeShowView
    NSInteger image_count = self.multimedias.count;
    if (image_count > 3){
        self.imageShowView_height = Homework_moment_Image_thumbnail_height * 2;
        self.imageShowView_width = Homework_moment_Image_thumbnail_width * 3 + Homework_moment_Image_thumbnail_showview_gap * 2;
    }else if(image_count == 3){
        self.imageShowView_height = Homework_moment_Image_thumbnail_height;
        self.imageShowView_width = Homework_moment_Image_thumbnail_width * 3 + Homework_moment_Image_thumbnail_showview_gap * 2;
    }else if (image_count == 2){
        self.imageShowView_height = Homework_moment_Image_thumbnail_height;
        self.imageShowView_width = Homework_moment_Image_thumbnail_width * 2 + Homework_moment_Image_thumbnail_showview_gap ;
    }else if (image_count == 1){
        self.imageShowView_height = Homework_moment_Image_thumbnail_height;
        self.imageShowView_width = Homework_moment_Image_thumbnail_width;
    }else{
        self.imageShowView_height = 0;
        self.imageShowView_width = 0;
    }
    

    // content_label
//    self.text = @"dfafdsafdsaf fdsafdsafdsaf fdsafdsa fdafdsa fdsa fda fdsa fds";
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:Homework_moment_text_font],NSParagraphStyleAttributeName:paragraphStyle};
    CGSize maxSize = CGSizeMake(Homework_moment_Image_thumbnail_width * 3 + Homework_moment_Image_thumbnail_showview_gap * 2, MAXFLOAT);

    CGSize text_size = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    
    
    // bubble_bgView
    if (text_size.width < self.imageShowView_width){
        self.bubble_bgView_width = self.imageShowView_width + imageShowView_margins_leading + imageShowView_margins_trailing;
        self.text_label_width = self.imageShowView_width;
        maxSize = CGSizeMake(self.text_label_width, MAXFLOAT);
        text_size = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
        self.text_label_height = text_size.height;
    }else{
        self.text_label_height = text_size.height;
        
        self.text_label_width = text_size.width + 10;
        
        self.bubble_bgView_width = self.text_label_width + content_text_margins_leading + content_text_margins_trailing;
    }

    self.bubble_bgView_height = self.imageShowView_top + self.imageShowView_height + self.text_label_top + self.text_label_height +  Homework_bubble_bgView_bottom;

}


-(void)setIsFromMySelf:(BOOL)isFromMySelf{
    _isFromMySelf = isFromMySelf;
    
    if (_isFromMySelf){
        self.imageShowView_leading = imageShowView_margins_leading;
        self.text_label_leading = content_text_margins_leading;
        
    }else{
        self.imageShowView_leading = imageShowView_margins_trailing;
        self.text_label_leading = content_text_margins_trailing;
    }
}

-(void)setImageShowView_height:(CGFloat)imageShowView_height{
    _imageShowView_height = imageShowView_height;
    if (_imageShowView_height == 0){
        self.imageShowView_top = 0;
        self.text_label_top = 10;
    }else{
        self.text_label_top = content_text_margins_top;
        self.imageShowView_top = imageShowView_margins_top;
    }
}



@end
