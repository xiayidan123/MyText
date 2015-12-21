//
//  OMAlertViewForNet.m
//  dev01
//
//  Created by 杨彬 on 15/3/17.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMAlertViewForNet.h"

@interface OMAlertViewForNet (){
    Class _delegateClass;
}

@property (retain, nonatomic) IBOutlet UIView *remind_view;

@property (retain, nonatomic) IBOutlet UILabel *remind_label;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadView_activity;

@property (retain, nonatomic) IBOutlet UIImageView *success_imageView;

@property (retain, nonatomic) IBOutlet UIImageView *failure_imageView;


@end


@implementation OMAlertViewForNet

- (void)dealloc {
    [_remind_view release];
    [_remind_label release];
    [_loadView_activity release];
    [_success_imageView release];
    [_title release];
    [_failure_imageView release];
    [super dealloc];
}

-(void)awakeFromNib{
    self.remind_view.layer.masksToBounds = YES;
    self.remind_view.layer.cornerRadius = 5;
    self.success_imageView.hidden = YES;
    self.failure_imageView.hidden = YES;
//    [self.loadView_activity startAnimating];
}

+ (instancetype)OMAlertViewForNet{
    OMAlertViewForNet *alertView = [[[NSBundle mainBundle]loadNibNamed:@"OMAlertViewForNet" owner:self options:nil] lastObject];
    alertView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    return alertView;
}


-(void)setTitle:(NSString *)title{
    [_title release],_title = nil;
    _title = [title copy];
    self.remind_label.text = _title;
}


-(void)setType:(OMAlertViewForNetStatus)type{
    _type = type;
    if (type == OMAlertViewForNetStatus_Loading){
        self.success_imageView.hidden = YES;
        self.failure_imageView.hidden = YES;
        self.loadView_activity.hidden = NO;
        [self.loadView_activity startAnimating];
        if (self.duration != 0){
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, self.duration * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                self.hidden = YES;
            });
        }
    }else if (type == OMAlertViewForNetStatus_Done){
        self.hidden = NO;
        self.success_imageView.hidden = NO;
        self.failure_imageView.hidden = YES;
        self.loadView_activity.hidden = YES;
        [self.loadView_activity stopAnimating];
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(hiddenOMAlertViewForNet:)]){
                [self.delegate hiddenOMAlertViewForNet:self];
            }
            [self removeFromSuperview];
        });
        
    }
    else if (type == OMAlertViewForNetStatus_Done1){
        self.hidden = NO;
        self.success_imageView.hidden = NO;
        self.failure_imageView.hidden = YES;
        self.loadView_activity.hidden = YES;
        [self.loadView_activity stopAnimating];
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(hiddenOMAlertViewForNet:)]){
                [self.delegate hiddenOMAlertViewForNet:self];
            }
            [self removeFromSuperview];
        });
    }
    else if (type == OMAlertViewForNetStatus_Failure){
        self.hidden = NO;
        [self.loadView_activity stopAnimating];
        self.success_imageView.hidden = YES;
        self.failure_imageView.hidden = NO;
        self.loadView_activity.hidden = YES;
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
//            if ([self.delegate respondsToSelector:@selector(hiddenOMAlertViewForNet:)]){
//                [self.delegate hiddenOMAlertViewForNet:self];
//            }
            [self removeFromSuperview];
        });
    }
}

- (void)dismiss{
    self.delegate = nil;
    [self.loadView_activity stopAnimating];
    [self removeFromSuperview];
}


- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.loadView_activity startAnimating];
}

- (void)showInView:(UIView *)view{
//    [self.loadView_activity startAnimating];
    
    self.frame = view.bounds;
    
    [view addSubview:self];
}



@end
