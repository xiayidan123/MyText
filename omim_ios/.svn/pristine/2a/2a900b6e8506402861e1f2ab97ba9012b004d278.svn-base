//
//  SharedAlertView.m
//  wowcity
//
//  Created by elvis on 2013/06/08.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "WarningView.h"
#import "PublicFunctions.h"
#import "Constants.h"
#import "AppDelegate.h"

@implementation WarningView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


+(WarningView*)sharedView
{
    
    @synchronized(self)
    {
//        static WarningView *view = nil;
        
//        if (view == nil)
//        {
//            view = [[WarningView alloc] initWithFrame:CGRectMake(85, 120, 150, 150)];
//            
//            UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
//            [imageview setImage:[PublicFunctions strecthableImage:@"alert_bg.png"]];
//            [view addSubview:imageview];
//            
//            UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(45, 30, 60, 60)];
//            [icon setImage:[UIImage imageNamed:@"alert_icon.png"]];
//            [imageview addSubview:icon];
//            [icon release];
//            
//            UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, view.frame.size.width-20, 60)];
//            label.backgroundColor = [ UIColor clearColor];
//            label.text = NSLocalizedString(@"Network is not available", nil);
//            label.font = [UIFont systemFontOfSize:15];
//            label.textColor = [UIColor whiteColor];
//            label.numberOfLines = 0;
//            label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//            label.textAlignment= NSTextAlignmentCenter;
//            
//            [view addSubview:label];
//            [label release];
//            [imageview release];
//            
//        }
        
        return [self sharedViewWithString:NSLocalizedString(@"Network is not available", nil)];
    }
    
}

+(WarningView*)sharedViewWithString:(NSString *) info
{
    
    @synchronized(self)
    {
        static WarningView *view = nil;
        
        if (view == nil)
        {
            view = [[WarningView alloc] initWithFrame:CGRectMake(85, 120, 150, 150)];
            
            UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            [imageview setImage:[PublicFunctions strecthableImage:@"alert_bg.png"]];
            [view addSubview:imageview];
            
            UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(45, 30, 60, 60)];
            [icon setImage:[UIImage imageNamed:@"alert_icon.png"]];
            [imageview addSubview:icon];
            [icon release];
            
            UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, view.frame.size.width-20, 60)];
            label.backgroundColor = [ UIColor clearColor];
            label.text = info;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor whiteColor];
            label.numberOfLines = 0;
            label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            label.textAlignment= NSTextAlignmentCenter;
            
            [view addSubview:label];
            [label release];
            [imageview release];
            
        }
        
        return view;
    }
    
}

-(void)showAlert:(NSError*)error
{
    self.error = error;
    
    if (isShown) {
            return;
        }
    else{
        int timestamp = [[NSDate date] timeIntervalSince1970];
        if (self.lastTime != 0 && timestamp - self.lastTime > 1) {
            [self show];
        }
        else if (self.lastTime == 0){
            [self show];
            self.lastTime = timestamp;
        }
        isShown = TRUE;
    }
}

-(void)show{
    self.alpha = 0;
    [[AppDelegate sharedAppDelegate].window addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:2 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            isShown = FALSE;
            [self removeFromSuperview];
        }];
        
    }];
    
}



@end
