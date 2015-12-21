//
//  OMBuddyDetailPhotosCell.m
//  dev01
//
//  Created by Starmoon on 15/8/3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMBuddyDetailPhotosCell.h"
#import "OMBuddyDetailItem.h"
#import "WTFile.h"

#import "MediaProcessing.h"
#import "WowTalkWebServerIF.h"
#import "WTError.h"

@interface OMBuddyDetailPhotosCell ()

@property (retain, nonatomic) IBOutlet UILabel *title_label;

@property (copy, nonatomic) NSString * mark_id;

@property (retain, nonatomic) NSMutableArray * photo_imageView_array;


@end


@implementation OMBuddyDetailPhotosCell


-(void)dealloc{
    self.item = nil;
    [_title_label release];
    self.photo_imageView_array = nil;
    self.mark_id = nil;
    [super dealloc];
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = 60;
    CGFloat height = 60;
    
    NSUInteger canShow_photo_count = (self.width - 100 ) / ( width + 10 );// 能展示的照片个数
    
    NSUInteger photo_count = self.item.moment_media_array.count > canShow_photo_count ? canShow_photo_count : self.item.moment_media_array.count ;
    
    
    NSUInteger view_count = self.photo_imageView_array.count;
    NSUInteger count = photo_count > view_count ? photo_count : view_count;
    for (int i=0; i<count; i++) {
        UIImageView *imageView = nil;
        if (i>= view_count){// 控件不够
            imageView = [[UIImageView alloc]init];
            imageView.width = width;
            imageView.height = height;
            imageView.backgroundColor = [UIColor redColor];
//            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.contentView addSubview:imageView];
            [self.photo_imageView_array addObject:imageView];
            [imageView release];
        }else if (i >= photo_count){// 控件多于 隐藏控件
            imageView = self.photo_imageView_array[i];
            imageView.hidden = YES;
        }else{// 正常需要展示的imageView
            imageView = self.photo_imageView_array[i];
            imageView.hidden = NO;
        }
        
        imageView.x = 80 + i* (width + 10);
        imageView.centerY = self.contentView.height / 2.0f;
        WTFile *file = self.item.moment_media_array[i];
        __block UIImageView *image_view = imageView;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [MediaProcessing getMediaForFile:file.thumbnailid withExtension:file.ext];
            
            if (data){
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    image_view.image = image;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imageView setImage:[UIImage imageNamed:@"default_pic.png"]];
                    [WowTalkWebServerIF getMomentMedia:file isThumb:true inShowingOrder:5000 forMoment:self.mark_id withCallback:@selector(didDownloadImage:) withObserver:self];
                });
            }
        });
    }
}

#pragma mark - Network Callback
- (void)didDownloadImage:(NSNotification *)notif{
    NSError *error = [[notif userInfo] valueForKey:WT_ERROR];
    if (error.code == NO_ERROR) {
        NSString *moment_id = [[notif userInfo] valueForKey:@"momentid"];
        if ([moment_id isEqualToString:self.mark_id]){
            [self setNeedsLayout];
        }
    }
}




+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"OMBuddyDetailPhotosCellID";
    OMBuddyDetailPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OMBuddyDetailPhotosCell" owner:self options:nil] lastObject];
    }
    return cell;
}

#pragma mark - Set and Get

-(void)setItem:(OMBuddyDetailItem *)item{
    [_item release],_item = nil;
    _item = [item retain];
    self.title_label.text = _item.title;
    
    [self setNeedsLayout];
}

-(NSMutableArray *)photo_imageView_array{
    if (_photo_imageView_array == nil){
        _photo_imageView_array = [[NSMutableArray alloc]init];
    }
    return _photo_imageView_array;
}

-(NSString *)mark_id{
    if (_mark_id.length == 0){
        _mark_id = [[NSString stringWithFormat:@"%d",arc4random()%1000] copy];
    }
    return _mark_id;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
